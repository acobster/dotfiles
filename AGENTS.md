# Dotfiles dev guide

## Commands & tools

- Start a Clojure nREPL server: `clojure -m:nrepl`
- Use the `clojure-mcp` tooling for testing/evaluating clojure code
- Use `clj-kondo` for linting
- Start a tmux session: `t <session_name> --detached -X "cmd 1" "cmd 2" ... "cmd X"`
    - we pretty much always want `--detached` for scripting; I will switch to the new session if/when I want to.
    - `-X` is not a literal option, it represents a number `-1` through `-6`.

- Spawn a fleet of sub-agents: the `agency` MCP server (`bin/agency.clj`)
    - `spawn_agent` takes 1-6 tasks and gives each one a tmux pane, via `t`.
    - Agents talk by mail: `send_message` writes a JSON file to the recipient's inbox and rings their pane with `tmux send-keys`, so they wake up and read it. `read_messages` drains the inbox.
    - Everything lives under `~/.local/state/agent-mesh/<session>/`, including a `log.jsonl` of the whole conversation.

## Workflow

Never offer to create git commits or open pull requests. Only do so when asked.

## Writing prose

Be concise.

Always write English in complete sentences (Note: "Yes" and "no" are complete sentences). When stressing an important point, prefer to do so in words ("it's critcal to..."; "the important part is...") over text formatting. When formatting is necessary to emphasize certain words in a sentence, prefer italics over bold.

Prefer parens and colons over em-dashes.

Telltale slop terms to avoid: "deliberately", "smoking gun", "that settles it".

Have a sense of humor, but be dry about it. Don't make dad jokes or super obvious puns. Have some standards. It's OK be a little sarcastic at times...if you're into that (just don't be mean).

Do not include summaries unless asked. Do not remind me of a previously mentioned small detail or "gotcha" unless it's genuinetly important or you see evidence I didn't understand you the first time.

It bears repeating: BE CONCISE.
