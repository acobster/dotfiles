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

filetype off

" Project stuff
cmap ~tour ~/workspace/docker/tourusa/
cmap ~mod ~/workspace/docker/tourusa/local/modules/TourUsa/
cmap ~vs ~/.vim/session/

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'altercation/vim-colors-solarized'
Plugin 'bronson/vim-trailing-whitespace'

" Navigation
Plugin 'vim-scripts/L9' " FuzzyFinder dependency
Plugin 'vim-scripts/FuzzyFinder'
Plugin 'wesQ3/vim-windowswap'

" Syntax
Plugin 'vim-syntastic/syntastic'
Plugin 'lumiliet/vim-twig'
Plugin 'bkad/vim-stylus'
Plugin 'posva/vim-vue'
Plugin 'elmcast/elm-vim'
Plugin 'wlangstroth/vim-racket'

" Formatting
Plugin 'junegunn/vim-easy-align'

" Fancy-ass statusline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Git
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'

" Markdown
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

" Multiple cursors
Plugin 'terryma/vim-multiple-cursors'

" Sessions
Plugin 'tpope/vim-obsession'
Plugin 'mhinz/vim-startify'

call vundle#end()

filetype plugin indent on

set laststatus=2

" ,h redraws the screen and removes any search highlighting.
nnoremap <leader>h :nohlsearch<cr>

" ctags
set tags=./tags;/,tags;/

" tabs n spaces
autocmd FileType make setlocal noexpandtab
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" File/Tab navigation
cnoremap %% <C-R>=expand('%:h').'/'<cr>
cnoremap N% tab new<Space>
cnoremap S% split<Space>
cnoremap V% vert new<Space>
nnoremap <C-l> :tabnext<CR>
nnoremap <C-h> :tabprevious<CR>

" configure unite file search
let g:unite_source_history_yank_enable = 1
try
  let g:unite_source_rec_async_command='ag --nocolor --nogroup -g ""'
  call unite#filters#matcher_default#use(['matcher_fuzzy'])
catch
endtry
" search a file in the filetree
nnoremap <space><space> :<C-u>Unite -start-insert file_rec/async<cr>
" reset not it is <C-l> normally
nnoremap <space>r <Plugin>(unite_restart)


" type & to searh the word in all files in the current dir
nmap & :Ag <c-r>=expand("<cword>")<cr><cr>
" Trailing space is necessary:
nnoremap <space>/ :Ag 


" Configure split behavior
nnoremap <c-w>h :vertical resize -5<cr>
nnoremap <c-l> :vertical resize +5<cr>
nnoremap <c-w>l :vertical resize +5<cr>
set splitbelow
set splitright

" Shell behavior
set shell=/bin/bash\ -i

" Syntax highlighting/linting
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let syntastic_mode_map = { 'passive_filetypes': ['html'] }
let g:syntastic_twig_checkers = ['twig']
let g:syntastic_html_tidy_ignore_errors = [
  \ 'plain text isn''t allowed in <head> elements',
  \ '<img> escaping malformed URI reference'
  \ ]
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exe = 'eslint'

if has("autocmd")
  au BufReadPost *.rkt,*.rktl set filetype=racket
  au filetype racket set lisp
  au filetype racket set autoindent
endif

" In vim-airline, only display "hunks" if the diff is non-zero
let g:airline#extensions#hunks#non_zero_only = 1

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

" Markdown config
let g:vim_markdown_folding_disabled = 1


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM MAPPINGS!
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap <leader>r :w\|:!rspec --format=d spec/routing<cr>
nmap <leader>c :w\|:!rspec --format=d spec/controllers<cr>
nmap <leader>m :w\|:!rspec --format=d spec/models<cr>
nmap <leader>l :w\|:!rspec --format=d spec/lib<cr>

" File buffering
nmap <leader>ff :FufCoverageFile<CR>
nmap <leader>fl :FufFile<CR>
nmap <leader>fd :FufFileWithCurrentBufferDir<CR>
nmap <leader>fb :FufBuffer<CR>
nmap <leader>ft :FufTaggedFile<CR>




""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Start an editor command to set up the mapping for executing stuff in named
" pipe
cnoremap <c-P><c-P> nmap ,t :w\\|:silent !echo 'lando unit' > test.pipe<c-v>u003Ccr>:redraw!<c-v>u003Ccr>
cnoremap <c-P><c-W> nmap ,s :w\\|:silent !echo 'lando sniff' > test.pipe<c-v>u003Ccr>:redraw!<c-v>u003Ccr>



" Include machine-specific .vimrc
so ~/.local.vimrc
