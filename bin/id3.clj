#!/usr/bin/env bb
(ns id3
  (:require
    [clojure.java.shell :refer [sh]]
    [clojure.java.io :as io]
    [clojure.string :as string]
    [clojure.tools.cli :as cli]))

(defn- zero-pad [n ct]
  (let [len (- (count (str ct)) (count (str n)))
        zeros (apply str (repeat len "0"))]
    (str zeros n)))

(defn- regex [s]
  (java.util.regex.Pattern/compile s))

(defn- basename [filename]
  (string/split
    (last (string/split filename (regex java.io.File/separator)))
    #"\."))

(defn- strip-extenion [filename]
  (string/join "." (butlast
                     (basename filename))))

(defn- output-name [in {:keys [dir
                               ext
                               track-count
                               track-number
                               track-titles
                               number-tracks?]}]
  (let [dirpath (when (seq dir)
                  (str dir java.io.File/separator))
        leftpad (when number-tracks?
                  (str (zero-pad track-number track-count) "-"))
        filename (if (seq track-titles)
                   (get track-titles (dec track-number))
                   (strip-extenion in))
        renamed (string/replace (string/lower-case (str filename "." ext))
                                " " "-")]
    (str leftpad (string/replace (string/lower-case (str filename "." ext))
                                 " " "-"))
    (str dirpath leftpad renamed)))

(defn- to-int [s]
  (try
    (Integer/parseInt s)
    (catch Throwable _ nil)))

(defn- extract-track-number [s]
  (reduce (fn [_ s]
            (when-let [i (to-int s)]
              (reduced i)))
          (string/split s #"( |-|\.)+")))

(defn- maybe-sort-by-track-number [sort? tracks]
  (if sort? (sort-by :track-number tracks) tracks))

(defn- parse-track-metadata [line delimiter]
  (when line (let [[maybe-artist maybe-title]
                   (map string/trim (string/split line (regex delimiter)))]
               (if maybe-title
                 {:artist maybe-artist
                  :title maybe-title}
                 {:title maybe-artist}))))

(defn- quoted [ss]
  (str "'" (apply str ss) "'"))

;; ffmpeg -i Track\ 2.wav -map 0 -write_id3v2 1 -metadata 'artist=Mark Isham' -metadata 'album=Tibet' -metadata 'track=2/5' -metadata 'title=Part II' -y 02.flac
(defn- convert [{:keys [in
                        metadata
                        metadata-args
                        dir
                        output-format
                        number-tracks?
                        track-number
                        track-count
                        track-titles
                        delimiter]}]
  (let [metadata (if track-titles
                   (merge metadata (parse-track-metadata
                                     (get track-titles (dec track-number))
                                     delimiter))
                   metadata)
        metadata-opts
        (reduce (fn [opts [k v]]
                  (if v
                    (concat opts ["-metadata" [(name k) "=" v]])
                    opts))
                [] metadata)
        metadata-args
        (interleave (repeat "-metadata") (map quoted metadata-args))
        out (output-name in {:dir dir
                             :ext (name (or output-format "flac"))
                             :number-tracks? number-tracks?
                             :track-count track-count
                             :track-number track-number
                             :track-titles track-titles})
        command (concat
                  ["ffmpeg" "-y" "-i" [in] "-map" "0" "-write_id3v2" "1"]
                  metadata-opts
                  metadata-args
                  [out])]
    command))

(defn- run-commands! [run? cmds]
  (doseq [cmd cmds]
    (let [human-readable (map #(if (vector? %) (quoted %) %) cmd)
          cmd (map #(if (vector? %) (apply str %) %) cmd)]
      (println (string/join " " human-readable))
      (when run?
        ;; TODO real error handling and such...
        (apply sh cmd)))))

(def cli-options
  [["-h" "--help" "Show usage"]
   ["-a" "--artist ARTIST" "Artist"]
   ["-b" "--album ALBUM" "Album"]
   ["-c" "--track-count COUNT" "Track count (for x/COUNT track tag)"]
   ["-l" "--delimiter DELIM" "Delimiter for tracks file, to parse 'ARTIST NAME - TRACK NAME' lines"
    :default "-"]
   [nil "--number-tracks" "Prefix output files with track number"
    :default false]
   [nil "--sort" "Sort by file name"]
   [nil "--dry-run" "Output commands to be run, but do not run them"]
   ["-f" "--output-format FORMAT" "destination format"
    :default :flac]
   ["-d" "--dir DIR" "destination directory"
    :default "."]
   ["-m" "--metadata DATA" "Specify a `-metadata` arg to all underlying ffmpeg commands"
    :multi true
    :default []
    :update-fn conj]
   ;; File can look like:
   ;; Name of Track 1
   ;; Name of Track 2
   ;; ...
   ;;
   ;; OR:
   ;; Artist 1 -  Name of Track 1
   ;; Artist 2 -  Name of Track 2
   ;; ...
   ["-t" "--tracks-file example.txt" "Tracks file (track titles, in order)"
    :validate [(comp boolean slurp) "File not found"]]])

(defn main [args]
  (let [{:keys [options errors summary]} (cli/parse-opts args cli-options)]
    (cond
      errors
      (println "ERROR\n\n" (string/join "\n" errors))
      (:help options)
      (println summary)
      :default
      (let [lines (string/split (slurp *in*) #"\n")
            track-titles (when (:tracks-file options)
                           (into {} (map-indexed
                                      #(vector %1 %2)
                                      (string/split
                                        (slurp (:tracks-file options))
                                        #"\n"))))
            track-count (or (:track-count options) (count lines))]
        (->> lines
             (map-indexed
               (fn [idx line]
                 (let [track-number (or (extract-track-number line) (inc idx))]
                   {:in line
                    :dir (:dir options)
                    :output-format (:output-format options)
                    :number-tracks? (:number-tracks options)
                    :track-count track-count
                    :track-number track-number
                    :track-titles track-titles
                    :delimiter (:delimiter options)
                    :metadata
                    {:artist (:artist options)
                     :album (:album options)
                     :track (str track-number "/" track-count)
                     :title (when track-titles
                              (get track-titles (dec track-number)))}
                    :metadata-args (:metadata options)})))
             (maybe-sort-by-track-number (:sort options))
             (map convert)
             (run-commands! (not (:dry-run options))))))))

(comment
  (last (convert {:in "Track 1.wav"
                  :metadata {:artist "A Perfect Circle"
                             :album "The Thirteenth Step"
                             :track 1/12}
                  :track-number 1
                  :track-count 12
                  :output-format :flac
                  :delimiter "-"}))

  (extract-track-number "Track 01.wav")
  (extract-track-number "Track 10.wav")
  (extract-track-number "Track 11.wav")
  (extract-track-number "Track xyz")
  (try
    (Integer/parseInt "Track ")
    (catch Throwable _ nil))
  (Integer/parseInt "01")

  (io/resource "hi.txt")
  (string/join " " ["a" "b" "c"]))

(main *command-line-args*)
