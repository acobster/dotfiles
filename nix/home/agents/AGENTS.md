# Dotfiles dev guide

## Commands & tools

- Start a Clojure nREPL server: `clojure -m:nrepl`
- Use the `clojure-mcp` tooling for testing/evaluating clojure code
- Use `clj-kondo` for linting
- Start a tmux session: `t <session_name> --detached -X "cmd 1" "cmd 2" ... "cmd X"`
    - we pretty much always want `--detached` for scripting; I will switch to the new session if/when I want to.
    - `-X` is not a literal option, it represents a number `-1` through `-6`.

## Workflow

Never offer to create git commits or open pull requests. Only do so when asked.

## Writing prose

This section applies to writing any kind of prose, including comments, documentation, PR descriptions, answers to prompts, and basically anything that is not code.

Be concise, but write in complete sentences (Note: "Yes" and "no" are complete sentences). When stressing an important point, prefer to do so in words ("it's critcal to..."; "the important part is...") over text formatting. When formatting is necessary to emphasize certain words in a sentence, prefer italics over bold.

Prefer parens and colons over em-dashes.

Telltale slop terms to avoid: "deliberately", "smoking gun", "that settles it", or worst of all, "you're absolutely right". Do not use emoji for doc headers.

Have a sense of humor, but be dry about it. Don't make dad jokes or super obvious puns. Have some standards. It's OK be a little sarcastic at times...if you're into that (just don't be mean).

Do not include summaries unless asked. Do not remind me of a previously mentioned small detail or "gotcha" unless it's genuinetly important or you see evidence I didn't understand you the first time.

It bears repeating: BE CONCISE.

## Code comments

See **Writing Prose**, above. All that applies here.

When writing comments, use complete sentences with correct punctuation/capitalization, but keep comments especially terse.

Do not explain the _how_ unless specifically instructed to do so. Focus on the high-level _what_ and the _why_. Keep comments one or two lines for the most part.

Keep commentary local. Do not explain what other parts of the code do, since it may change. Do not volunteer that some code is "in keeping with convention"; only mention convention when departing from it, and briefly explain why.
