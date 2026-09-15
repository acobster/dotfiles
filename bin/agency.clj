#!/usr/bin/env bb

;; agent-mesh: spawn a fleet of Claude agents into tmux panes and let them
;; talk to each other.
;;
;;   agent-mesh serve   MCP stdio server (this is what claude connects to)
;;   agent-mesh run     pane bootstrap; execs claude for one agent
;;
;; Messages are files. Each one lands in the recipient's inbox as
;; <epoch-ms>-<sender>.json, and a tmux send-keys nudge wakes the recipient so
;; it actually notices. read_messages drains inbox/ into read/.

(require
  '[babashka.fs :as fs]
  '[babashka.process :as p]
  '[cheshire.core :as json]
  '[clojure.string :as string])

(def script-path (fs/canonicalize *file*))
(def bin-dir (fs/parent script-path))
(def t-script (str (fs/path bin-dir "t")))

(def state-root
  (fs/path (or (System/getenv "XDG_STATE_HOME")
               (str (System/getenv "HOME") "/.local/state"))
           "agent-mesh"))

(defn log [& args]
  (binding [*out* *err*]
    (apply println "[agent-mesh]" args)))

(defn now [] (System/currentTimeMillis))

;; ---------------------------------------------------------------- state

(defn session-dir [session] (fs/path state-root session))
(defn agent-dir [dir name] (fs/path dir "agents" name))
(defn inbox-dir [dir name] (fs/path (agent-dir dir name) "inbox"))
(defn read-dir  [dir name] (fs/path (agent-dir dir name) "read"))

(defn read-json [path]
  (when (fs/exists? path)
    (json/parse-string (slurp (str path)) true)))

(defn write-json [path data]
  (fs/create-dirs (fs/parent path))
  (spit (str path) (json/generate-string data {:pretty true})))

(defn manifest [dir] (read-json (fs/path dir "session.json")))

(defn agent-names [dir] (->> (manifest dir) :agents keys (map name) sort))

(defn read-status [dir name]
  (let [f (fs/path (agent-dir dir name) "status")]
    (if (fs/exists? f) (string/trim (slurp (str f))) "unknown")))

(defn write-status [dir name status]
  (let [f (fs/path (agent-dir dir name) "status")]
    (fs/create-dirs (fs/parent f))
    (spit (str f) status)))

(defn pane-id [dir name]
  (let [f (fs/path (agent-dir dir name) "pane")]
    (when (fs/exists? f) (string/trim (slurp (str f))))))

(defn append-log [dir entry]
  (spit (str (fs/path dir "log.jsonl"))
        (str (json/generate-string entry) "\n")
        :append true))

;; ---------------------------------------------------------------- identity

;; Sub-agents get AGENT_MESH_DIR and AGENT_MESH_SELF from the command t sends
;; into their pane. The lead has neither, so it is "lead" and remembers which
;; session it spawned most recently.
(def self (or (System/getenv "AGENT_MESH_SELF") "lead"))
(def bound-dir (System/getenv "AGENT_MESH_DIR"))
(def current-session (atom nil))

(defn resolve-dir
  "Session dir for this call: an explicit arg wins, then the env binding a
  sub-agent was launched with, then whatever the lead spawned last."
  [args]
  (or (when-let [s (:session args)] (session-dir s))
      (when bound-dir (fs/path bound-dir))
      @current-session
      (throw (ex-info "no session: pass `session`, or call spawn_agent first" {}))))

;; ---------------------------------------------------------------- messaging

(defn deliver-message
  "Write the message file, log it, then ring the recipient's doorbell."
  [dir from to text]
  (let [ts (now)
        msg {:from from :to to :ts ts :text text}
        file (fs/path (inbox-dir dir to) (format "%d-%s.json" ts from))]
    (write-json file msg)
    (append-log dir (assoc msg :event "message"))
    (let [pane (pane-id dir to)
          nudge (format "[agent-mesh] new mail from %s - call read_messages" from)]
      (if pane
        (try
          (p/shell {:out :string :err :string}
                   "tmux" "send-keys" "-t" pane nudge "C-m")
          {:delivered true :doorbell pane}
          (catch Exception e
            (log "doorbell failed for" to ":" (ex-message e))
            {:delivered true :doorbell nil
             :warning "message written but doorbell failed; recipient is asleep"}))
        {:delivered true :doorbell nil
         :warning "no pane registered yet; recipient will see it on next read_messages"}))))

(defn drain-inbox
  "Move every message from inbox/ to read/ and return them in send order."
  [dir name]
  (let [in (inbox-dir dir name)]
    (fs/create-dirs in)
    (fs/create-dirs (read-dir dir name))
    (let [files (sort-by fs/file-name (fs/list-dir in))]
      (doall
        (for [f files
              :let [msg (read-json f)]]
          (do (fs/move f (fs/path (read-dir dir name) (fs/file-name f))
                       {:replace-existing true})
              msg))))))

(defn unread-count [dir name]
  (let [in (inbox-dir dir name)]
    (if (fs/exists? in) (count (fs/list-dir in)) 0)))

;; ---------------------------------------------------------------- spawning

(def protocol-prompt
  "You are a member of an agent-mesh fleet running in a tmux pane. You have
these tools from the agent-mesh MCP server:

- read_messages: drain your inbox. Call this whenever you are told you have
  new mail, and once before you decide you are finished.
- send_message: write to another agent in the fleet. Their pane gets a nudge,
  so they will actually see it.
- list_agents: see who else is in the fleet and what state they are in.
- set_status: report your own state. Use 'waiting' when you are blocked on
  another agent, 'done' when your task is complete (include a summary note),
  'blocked' when you need a human.

Work your task. If you need something another agent owns, ask for it with
send_message rather than guessing, then set_status waiting. When you finish,
call set_status done with a one-paragraph summary of what you did. Do not exit
or clear the session; stay up so you can answer follow-up mail.")

(defn agent-command
  "The shell line t will type into one pane."
  [dir name]
  (format "AGENT_MESH_DIR=%s AGENT_MESH_SELF=%s %s run"
          (str dir) name (str script-path)))

(defn spawn-agent [{:keys [session agents permission_mode model cwd claude_bin]}]
  (when (empty? agents)
    (throw (ex-info "agents must be a non-empty list" {})))
  (when (> (count agents) 6)
    (throw (ex-info "t tops out at 6 panes; spawn a second fleet" {})))
  (let [dir (session-dir session)
        base-cwd (or cwd (System/getProperty "user.dir"))
        mode (or permission_mode "acceptEdits")]
    (when (fs/exists? dir)
      (throw (ex-info (format "session '%s' already exists at %s" session (str dir))
                      {})))
    ;; lay down the mailboxes before anything is allowed to start talking
    (doseq [{:keys [name task]} agents]
      (let [ad (agent-dir dir name)]
        (fs/create-dirs (inbox-dir dir name))
        (fs/create-dirs (read-dir dir name))
        (spit (str (fs/path ad "task.md")) task)
        (write-status dir name "starting")))
    ;; the lead has a mailbox too, so sub-agents can report back
    (fs/create-dirs (inbox-dir dir "lead"))
    (fs/create-dirs (read-dir dir "lead"))
    (write-status dir "lead" "running")
    (write-json (fs/path dir "session.json")
                {:session session
                 :created (now)
                 :cwd base-cwd
                 :permission-mode mode
                 :model model
                 :claude-bin (or claude_bin "claude")
                 :agents (into {} (for [{:keys [name task cwd]} agents]
                                    [name {:task task :cwd (or cwd base-cwd)}]))})
    ;; sub-agents connect to this same server, so they get the same tools
    (write-json (fs/path dir "mcp.json")
                {:mcpServers {:agent-mesh {:command (str script-path)
                                           :args ["serve"]}}})
    (let [cmds (mapv #(agent-command dir (:name %)) agents)
          args (concat [t-script session] cmds
                       [(str "-" (count agents)) "--detached"])
          res (apply p/shell {:out :string :err :string :continue true} args)]
      (when-not (zero? (:exit res))
        (throw (ex-info (str "t failed: " (:err res)) {})))
      (reset! current-session dir)
      {:session session
       :dir (str dir)
       :agents (mapv :name agents)
       :permission-mode mode
       :attach (format "tmux attach -t %s" session)
       :note "Agents are booting. Their panes register themselves, so give them a moment before the first send_message."})))

;; ---------------------------------------------------------------- run mode

(defn run-agent
  "Bootstrap one pane: register the pane id, then become claude."
  []
  (let [dir (or bound-dir (throw (ex-info "AGENT_MESH_DIR is not set" {})))
        name self
        m (manifest (fs/path dir))
        conf (get-in m [:agents (keyword name)])
        task (slurp (str (fs/path (agent-dir (fs/path dir) name) "task.md")))
        pane (System/getenv "TMUX_PANE")
        mode (or (:permission-mode m) "acceptEdits")
        work (or (:cwd conf) (:cwd m))]
    (when pane
      (spit (str (fs/path (agent-dir (fs/path dir) name) "pane")) pane))
    (write-status (fs/path dir) name "running")
    (let [prompt (format "You are agent '%s' in fleet '%s'.\n\nYour task:\n\n%s"
                         name (:session m) task)
          cmd (cond-> [(or (:claude-bin m) "claude")
                       "--mcp-config" (str (fs/path dir "mcp.json"))
                       "--permission-mode" mode
                       "--append-system-prompt" protocol-prompt]
                (:model m) (conj "--model" (:model m))
                true (conj prompt))]
      (apply p/exec {:dir work} cmd))))

;; ---------------------------------------------------------------- tools

(def tools
  [{:name "spawn_agent"
    :description "Spawn a fleet of Claude agents, one per tmux pane, using bin/t. Takes 1-6 agents. Each gets a mailbox and can message the others. Returns the session name and how to attach."
    :inputSchema
    {:type "object"
     :required ["session" "agents"]
     :properties
     {:session {:type "string"
                :description "tmux session name for the fleet. Must not already exist."}
      :agents {:type "array" :minItems 1 :maxItems 6
               :description "The roster, one pane each."
               :items {:type "object"
                       :required ["name" "task"]
                       :properties {:name {:type "string"
                                           :description "Short identifier, used for addressing mail."}
                                    :task {:type "string"
                                           :description "The agent's full task. This becomes its opening prompt."}
                                    :cwd {:type "string"
                                          :description "Working directory. Defaults to the fleet cwd."}}}}
      :cwd {:type "string" :description "Default working directory for all agents."}
      :model {:type "string" :description "Model for the sub-agents, e.g. claude-sonnet-5."}
      :claude_bin {:type "string" :description "Binary to exec in each pane. Defaults to whatever 'claude' resolves to. Useful for pinning a build or wrapping it."}
      :permission_mode {:type "string"
                        :enum ["acceptEdits" "auto" "bypassPermissions" "manual" "dontAsk" "plan"]
                        :description "Permission mode for sub-agents. Defaults to acceptEdits. A mode that prompts will stall the pane until a human answers it."}}}}

   {:name "send_message"
    :description "Send a message to another agent in the fleet. Writes it to their inbox and nudges their pane so they wake up and read it."
    :inputSchema
    {:type "object"
     :required ["to" "text"]
     :properties {:to {:type "string" :description "Recipient agent name, or 'lead'."}
                  :text {:type "string" :description "Message body."}
                  :session {:type "string" :description "Fleet to address. Defaults to your own."}}}}

   {:name "read_messages"
    :description "Drain your inbox and return messages in send order. Call this when nudged about new mail, and once more before concluding you are done."
    :inputSchema
    {:type "object"
     :properties {:session {:type "string" :description "Fleet to read from. Defaults to your own."}}}}

   {:name "await_messages"
    :description "Block until mail arrives or the timeout expires. Use when you have nothing to do until another agent answers you."
    :inputSchema
    {:type "object"
     :properties {:timeout_seconds {:type "integer"
                                    :description "How long to wait. Default 60, max 600."}
                  :session {:type "string"}}}}

   {:name "list_agents"
    :description "Roster of the fleet with each agent's status and unread count."
    :inputSchema
    {:type "object"
     :properties {:session {:type "string"}}}}

   {:name "set_status"
    :description "Report your own state to the fleet: running, waiting, done, or blocked."
    :inputSchema
    {:type "object"
     :required ["status"]
     :properties {:status {:type "string" :enum ["running" "waiting" "done" "blocked"]}
                  :note {:type "string" :description "Summary or reason. Required in spirit for done and blocked."}
                  :session {:type "string"}}}}])

(defn call-tool [name args]
  (case name
    "spawn_agent" (spawn-agent args)

    "send_message"
    (let [dir (resolve-dir args)
          to (:to args)]
      (when-not (or (= to "lead") (some #{to} (agent-names dir)))
        (throw (ex-info (format "no agent '%s' in this fleet; roster is %s"
                                to (pr-str (agent-names dir))) {})))
      (deliver-message dir self to (:text args)))

    "read_messages"
    (let [dir (resolve-dir args)
          msgs (drain-inbox dir self)]
      {:count (count msgs) :messages msgs})

    "await_messages"
    (let [dir (resolve-dir args)
          timeout (min (or (:timeout_seconds args) 60) 600)
          deadline (+ (now) (* 1000 timeout))]
      (write-status dir self "waiting")
      (loop []
        (let [msgs (drain-inbox dir self)]
          (cond
            (seq msgs) (do (write-status dir self "running")
                           {:count (count msgs) :messages msgs})
            (< (now) deadline) (do (Thread/sleep 1000) (recur))
            :else {:count 0 :messages []
                   :note (format "no mail after %ds" timeout)}))))

    "list_agents"
    (let [dir (resolve-dir args)
          m (manifest dir)]
      {:session (:session m)
       :dir (str dir)
       :you self
       :agents (vec (for [n (cons "lead" (agent-names dir))]
                      {:name n
                       :status (read-status dir n)
                       :unread (unread-count dir n)
                       :pane (pane-id dir n)}))})

    "set_status"
    (let [dir (resolve-dir args)
          status (:status args)]
      (write-status dir self status)
      (append-log dir {:event "status" :agent self :status status
                       :note (:note args) :ts (now)})
      ;; tell the lead, so a finished agent does not go unnoticed
      (when (and (not= self "lead") (#{"done" "blocked"} status))
        (deliver-message dir self "lead"
                         (format "[%s] %s%s" self status
                                 (if-let [n (:note args)] (str ": " n) ""))))
      {:agent self :status status})

    (throw (ex-info (str "unknown tool: " name) {}))))

;; ---------------------------------------------------------------- jsonrpc

(defn result [id data]
  {:jsonrpc "2.0" :id id :result data})

(defn error [id code message]
  {:jsonrpc "2.0" :id id :error {:code code :message message}})

(defn handle [{:keys [method params id]}]
  (case method
    "initialize"
    (result id {:protocolVersion (or (:protocolVersion params) "2025-06-18")
                :capabilities {:tools {}}
                :serverInfo {:name "agent-mesh" :version "0.1.0"}})

    "notifications/initialized" nil
    "notifications/cancelled" nil

    "ping" (result id {})

    "tools/list" (result id {:tools tools})

    "tools/call"
    (try
      (let [data (call-tool (:name params) (or (:arguments params) {}))]
        (result id {:content [{:type "text"
                               :text (json/generate-string data {:pretty true})}]}))
      (catch Exception e
        (log "tool error:" (ex-message e))
        (result id {:isError true
                    :content [{:type "text" :text (str "error: " (ex-message e))}]})))

    (if id
      (error id -32601 (str "method not found: " method))
      nil)))

(defn serve []
  (fs/create-dirs state-root)
  (log "serving as" self (when bound-dir (str "in " bound-dir)))
  (loop []
    (when-let [line (read-line)]
      (when-not (string/blank? line)
        (try
          (when-let [resp (handle (json/parse-string line true))]
            (println (json/generate-string resp))
            (flush))
          (catch Exception e
            (log "parse/dispatch failure:" (ex-message e)))))
      (recur))))

;; ---------------------------------------------------------------- main

(let [cmd (first *command-line-args*)]
  (case cmd
    "serve" (serve)
    "run"   (run-agent)
    (do (println "usage: agent-mesh serve | agent-mesh run")
        (System/exit 1))))
