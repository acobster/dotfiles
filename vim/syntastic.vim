let g:rainbow_active = 1

let g:clojure_syntax_keywords = {
    \   'clojureMacro': ["defaction", "add-hook", "set-config-cond->",
    \                    "add-hook", "add-hooks->", "add-effects->", "try-hook"]
    \ }

" Syntax highlighting/linting
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let syntastic_mode_map = { 'passive_filetypes': ['html'] }
let g:syntastic_twig_checkers = ['twig']
" WiP - ignore racket check warning
"let g:syntastic_quiet_messages = {
"  \ "regex": '.*racket: checks disabled for security reasons.*' }
let g:syntastic_html_tidy_ignore_errors = [
  \ 'plain text isn''t allowed in <head> elements',
  \ '<img> escaping malformed URI reference'
  \ ]
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exe = 'eslint'

" scrooloose/syntastic settings
let g:syntastic_error_symbol = '✘'
let g:syntastic_warning_symbol = "▲"
augroup mySyntastic
  au!
  au FileType tex let b:syntastic_mode = "passive"
augroup END
