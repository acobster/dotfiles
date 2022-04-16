set nocompatible		" http://stackoverflow.com/questions/5845557/in-a-vimrc-is-set-nocompatible-completely-useless

" Turn on syntax highlighting.
syntax enable

set ignorecase   " Case-insensitive searching
set smartcase    " But case-sensitive if expression contains a capital
set showcmd      " Display incomplete commands
set showmode     " Display the current mode
set scrolloff=3  " Show 3 lines of context around the cursor.
set number       " Show line numbers.
set ruler        " Show cursor position.
set visualbell   " No beeping.
set expandtab    " Spaces
set tabstop=2    " tab = 2 spaces
set shiftwidth=2 " >> / << behavior
set incsearch    " incremental search
set hlsearch     " hilight search terms

" https://en.parceljs.org/hmr.html#safe-write
set backupcopy=yes

" don't redraw in the middle of macros
set lazyredraw

let mapleader=","
let maplocalleader=","

" what does this even
filetype off

" make Parcel work
set backupcopy=yes

" https://vi.stackexchange.com/a/10125/14583
filetype plugin indent on


" ???
set laststatus=2

" ,n redraws the screen and removes any search highlighting.
nnoremap <leader>n :nohlsearch<cr>

" ctags
set tags=./tags;/,tags;/

" tabs n spaces
autocmd FileType make setlocal noexpandtab
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd BufNewFile,BufRead *.dat set filetype=ledger

" Shell behavior
set shell=/bin/bash\ -i

" Toggle paste mode easily
" Useful for pasting code without autoformatting
set pastetoggle=<F3>

" put symbols in the sign column
hi clear SignColumn

" Highlight current line in active window
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END
