let g:rainbow_active = 1

let g:clojure_syntax_keywords = {
    \   'clojureMacro': ["defaction", "add-hook", "set-config-cond->",
    \                    "add-hook", "add-hooks->", "add-effects->", "try-hook"]
    \ }

" Syntax highlighting/linting
" Don't lint every single buffer every time I open vim...
let g:ale_lint_on_enter = 0

" Prettier
augroup FiletypeGroup
    autocmd!
    au BufNewFile,BufRead *.tsx set filetype=typescript.tsx
    au BufNewFile,BufRead *.ts set filetype=typescript.ts
augroup END
let g:ale_fixers = {
\   'typescript': ['prettier', 'eslint'],
\   'python': ['black'],
\   'css': ['prettier'],
\}
let g:ale_fix_on_save = 1

if has("autocmd")
  au BufReadPost *.rkt,*.rktl set filetype=racket
  au filetype racket set lisp
  au filetype racket set autoindent
endif
