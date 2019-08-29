set nocompatible		" http://stackoverflow.com/questions/5845557/in-a-vimrc-is-set-nocompatible-completely-useless

syntax enable			" Turn on syntax highlighting.

set ignorecase			" Case-insensitive searching
set smartcase			" But case-sensitive if expression contains a capital
set showcmd			" Display incomplete commands
set showmode			" Display the current mode

set scrolloff=3			" Show 3 lines of context around the cursor.
set number			" Show line numbers.
set ruler			" Show cursor position.
set visualbell			" No beeping.
set expandtab
set tabstop=2
set shiftwidth=2
set incsearch " incremental search
set hlsearch  " hilight search terms



let mapleader=","



" what does this even
filetype off



" PLUGINZ

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()


Plugin 'VundleVim/Vundle.vim'

" The colors, Duke! The colors!
Plugin 'altercation/vim-colors-solarized'
Plugin 'bronson/vim-trailing-whitespace'

" Navigation
Plugin 'wesQ3/vim-windowswap'
Plugin 'junegunn/fzf.vim'

" Syntax
Plugin 'vim-syntastic/syntastic'
Plugin 'lumiliet/vim-twig'
Plugin 'bkad/vim-stylus'
Plugin 'posva/vim-vue'
Plugin 'elmcast/elm-vim'
Plugin 'wlangstroth/vim-racket'
Plugin 'StanAngeloff/php.vim'
Plugin 'slim-template/vim-slim.git'
Plugin 'elzr/vim-json'
Plugin 'tpope/vim-surround'

" Lisp-y stuff
Plugin 'guns/vim-clojure-static'
Plugin 'guns/vim-sexp'
Plugin 'tpope/vim-fireplace'
Plugin 'clojure-vim/vim-cider'
Plugin 'junegunn/rainbow_parentheses.vim'

" Case
Plugin 'tpope/vim-abolish'

" Markdown
Plugin 'junegunn/goyo.vim'

" Formatting
Plugin 'junegunn/vim-easy-align'
Plugin 'editorconfig/editorconfig-vim'

" Fancy-ass statusline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Git
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'

" Sessions
Plugin 'tpope/vim-obsession'
Plugin 'mhinz/vim-startify'

call vundle#end()


filetype plugin indent on



" ???
set laststatus=2


" ,h redraws the screen and removes any search highlighting.
nnoremap <leader>h :nohlsearch<cr>

" ctags
set tags=./tags;/,tags;/

" tabs n spaces
autocmd FileType make setlocal noexpandtab
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd BufNewFile,BufRead *.dat set filetype=ledger

" File/Tab navigation
cnoremap %% <C-R>=expand('%:h').'/'<cr>
cnoremap N% tab new<Space>
cnoremap S% split<Space>
cnoremap V% vert new<Space>
nnoremap <c-l> :tabnext<CR>
nnoremap <c-h> :tabprevious<CR>
" Move current buffer one tab to the left
nmap <leader>z :tabprevious<cr>:vert<space>new<cr>,ww:tabnext<cr>,ww:q<cr>:tabprevious<cr>
" Move current buffer one tab to the right
nmap <leader>v :tabnext<cr>:vert<space>new<cr>,ww:tabprevious<cr>,ww:q<cr>:tabnext<cr>

" Configure split behavior
nnoremap <c-w>h :vertical resize -5<cr>
nnoremap <c-w>l :vertical resize +5<cr>
set splitbelow
set splitright
" Move tabs how I want, when I want
cnoremap <c-t><c-t> tabm<Space>0<cr>
cnoremap <c-t><c-h> tabm<Space>-<cr>
cnoremap <c-t><c-l> tabm<Space>+<cr>

" THE LOZENGE ◊
imap <c-l> ◊

" Shell behavior
set shell=/bin/bash\ -i



" Syntax highlighting/linting
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let syntastic_mode_map = { 'passive_filetypes': ['html'] }
let g:syntastic_twig_checkers = ['twig']
" WiP - ignore racket check warning
let g:syntastic_quiet_messages = {
  \ "regex": '.*racket: checks disabled for security reasons.*' }
let g:syntastic_html_tidy_ignore_errors = [
  \ 'plain text isn''t allowed in <head> elements',
  \ '<img> escaping malformed URI reference'
  \ ]
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exe = 'eslint'

let g:sexp_enable_insert_mode_mappings = 0

augroup rainbow_lisp
  autocmd!
  autocmd FileType lisp,clojure,scheme RainbowParentheses
augroup END

if has("autocmd")
  au BufReadPost *.rkt,*.rktl set filetype=racket
  au filetype racket set lisp
  au filetype racket set autoindent
endif


" Markdown
nmap <leader>gg :Goyo<cr>


" Easy align interactive
vnoremap <silent> <Enter> :EasyAlign<cr>

" put symbols in the sign column
hi clear SignColumn

" ----- scrooloose/syntastic settings -----
let g:syntastic_error_symbol = '✘'
let g:syntastic_warning_symbol = "▲"
augroup mySyntastic
  au!
  au FileType tex let b:syntastic_mode = "passive"
augroup END

" Toggle paste mode easily
" Useful for pasting code without autoformatting
set pastetoggle=<F3>

" Highlight current line in active window
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END


" Coloring for 80-char column
if (exists('+colorcolumn'))
  set colorcolumn=80
  highlight ColorColumn ctermbg=9
endif

" -- solarized personal conf
if has('gui_running')
  set background=light
else
  set background=dark
endif

try
  colorscheme solarized
catch
endtry

" https://superuser.com/questions/895180/solarized-dark-gnome-terminal-vim-vim-airline
let &t_Co=256

" Markdown config
let g:vim_markdown_folding_disabled = 1


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM MAPPINGS!
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap <leader>c :w<cr>cpr

"nmap <leader>r :w\|:!rspec --format=d spec/routing<cr>
"nmap <leader>c :w\|:!rspec --format=d spec/controllers<cr>
"nmap <leader>m :w\|:!rspec --format=d spec/models<cr>
"nmap <leader>l :w\|:!rspec --format=d spec/lib<cr>

" js (mocha) tests
imap <c-t><c-d> describe('', () => {<cr><cr>})<esc>kkf'a
imap <c-t><c-i> it('', () => {<cr><cr>})<esc>kkf'a
imap <c-t><c-e> beforeEach(() => {<cr>})<esc>O
imap <c-t><c-b> before(() => {<cr>})<esc>O

" bash text completion
imap <c-b><c-i> if [[ X ]] ; then<cr><cr>fi<esc>kkfXs

" Search config
set rtp+=~/.fzf
nmap <leader>ff :Files<cr>
nmap <leader>ag :Ag<cr>

let g:fzf_action = {
  \ 'ctrl-k': 'vsplit',
  \ 'ctrl-l': 'tab split' }




" Project path stuff
cmap ~vs ~/.vim/session/
cmap ~gr ~/projects/groot/
cmap ~con ~/projects/conifer/




" Assets - display assets from Ledger-CLI

command Assets r!date '+;; \%Y-\%m-\%d ALL ACCOUNTS BALANCED'; echo ';;'; ledger -f ~/ledger/ledger.dat balance assets --cleared | sed -s 's/^/;; /'




" Rename.vim  -  Rename a buffer within Vim and on the disk
"
" Copyright June 2007-2011 by Christian J. Robinson <heptite@gmail.com>
"
" Distributed under the terms of the Vim license.  See ":help license".
"
" Usage:
"
" :Rename[!] {newname}

command! -nargs=* -complete=file -bang Rename call Rename(<q-args>, '<bang>')

function! Rename(name, bang)
	let l:name    = a:name
	let l:oldfile = expand('%:p')

	if bufexists(fnamemodify(l:name, ':p'))
		if (a:bang ==# '!')
			silent exe bufnr(fnamemodify(l:name, ':p')) . 'bwipe!'
		else
			echohl ErrorMsg
			echomsg 'A buffer with that name already exists (use ! to override).'
			echohl None
			return 0
		endif
	endif

	let l:status = 1

	let v:errmsg = ''
	silent! exe 'saveas' . a:bang . ' ' . l:name

	if v:errmsg =~# '^$\|^E329'
		let l:lastbufnr = bufnr('$')

		if expand('%:p') !=# l:oldfile && filewritable(expand('%:p'))
			if fnamemodify(bufname(l:lastbufnr), ':p') ==# l:oldfile
				silent exe l:lastbufnr . 'bwipe!'
			else
				echohl ErrorMsg
				echomsg 'Could not wipe out the old buffer for some reason.'
				echohl None
				let l:status = 0
			endif

			if delete(l:oldfile) != 0
				echohl ErrorMsg
				echomsg 'Could not delete the old file: ' . l:oldfile
				echohl None
				let l:status = 0
			endif
		else
			echohl ErrorMsg
			echomsg 'Rename failed for some reason.'
			echohl None
			let l:status = 0
		endif
	else
		echoerr v:errmsg
		let l:status = 0
	endif

	return l:status
endfunction

" end Rename




command Php r!snip phpclass
command Bashargs r!snip bashargs
command Wpcli r!snip wpcli



" 'start'/'end' replacements
nnoremap <leader>se 5send<esc>
nnoremap <leader>es 3sstart<esc>
" 'first'/'last' replacements
nnoremap <leader>fl 5slast<esc>
nnoremap <leader>lf 4sfirst<esc>
" 'create'/'update' replacements
nnoremap <leader>cu 3supd<esc>
nnoremap <leader>uc 3scre<esc>





""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Start an editor command to set up the mapping for executing stuff in named
" pipe
cnoremap <c-P><c-P> nmap ,t :w\\|:silent !echo 'test_cmd' > test.pipe<c-v>u003Ccr>:redraw!<c-v>u003Ccr>
cnoremap <c-P><c-R> nmap ,r :w\\|:silent !echo 'command' > test.pipe<c-v>u003Ccr>:redraw!<c-v>u003Ccr>
cnoremap <c-P><c-E> nmap ,e :w\\|:silent !echo 'command' > test.pipe<c-v>u003Ccr>:redraw!<c-v>u003Ccr>
cnoremap <c-P><c-W> nmap ,s :w\\|:silent !echo 'command' > test.pipe<c-v>u003Ccr>:redraw!<c-v>u003Ccr>

cnoremap <c-P>a nmap ,a :w\\|:silent !echo 'ledger -f ~/ledger/ledger.dat balance assets' > test.pipe<c-v>u003Ccr>:redraw!<c-v>u003Ccr>





" Include machine-specific .vimrc
so ~/.local.vimrc
