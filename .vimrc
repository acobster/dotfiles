set nocompatible		" http://stackoverflow.com/questions/5845557/in-a-vimrc-is-set-nocompatible-completely-useless

syntax enable			" Turn on syntax highlighting.

set ignorecase			" Case-insensitive searching
set smartcase			" But case-sensitive if expression contains a capital
set showcmd			" Display incomplete commands
set showmode			" Display the current mode
set backspace=indent,eol,start	" Intuitive backspacing.
set scrolloff=3			" Show 3 lines of context around the cursor.
set number			" Show line numbers.
set ruler			" Show cursor position.
set visualbell			" No beeping.
set expandtab
set tabstop=2
set shiftwidth=2

filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'altercation/vim-colors-solarized'
Plugin 'bronson/vim-trailing-whitespace'

" Navigation
Plugin 'scrooloose/nerdtree'
Plugin 'ctrlpvim/ctrlp.vim'

" Syntax
Plugin 'lumiliet/vim-twig'
Plugin 'vim-syntastic/syntastic'

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

call vundle#end()

filetype plugin indent on

set laststatus=2

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let syntastic_mode_map = { 'passive_filetypes': ['html'] }

" In vim-airline, only display "hunks" if the diff is non-zero
let g:airline#extensions#hunks#non_zero_only = 1

" put symbols in the sign column
hi clear SignColumn

" ----- scrooloose/syntastic settings -----
let g:syntastic_error_symbol = '✘'
let g:syntastic_warning_symbol = "▲"
augroup mySyntastic
  au!
  au FileType tex let b:syntastic_mode = "passive"
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

"NERDTree
" Toggle NERDTree
map <C-n> :NERDTreeToggle<CR>
" close vim if NERDTree is the only tab left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Markdown config
let g:vim_markdown_folding_disabled = 1


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INLINE VARIABLE (SKETCHY)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InlineVariable()
    " Copy the variable under the cursor into the 'a' register
    :let l:tmp_a = @a
    :normal "ayiw
    " Delete variable and equals sign
    :normal 2daW
    " Delete the expression into the 'b' register
    :let l:tmp_b = @b
    :normal "bd$
    " Delete the remnants of the line
    :normal dd
    " Go to the end of the previous line so we can start our search for the
    " usage of the variable to replace. Doing '0' instead of 'k$' doesn't
    " work; I'm not sure why.
    normal k$
    " Find the next occurence of the variable
    exec '/\<' . @a . '\>'
    " Replace that occurence with the text we yanked
    exec ':.s/\<' . @a . '\>/' . escape(@b, "/")
    :let @a = l:tmp_a
    :let @b = l:tmp_b
endfunction
nnoremap <leader>ri :call InlineVariable()<cr>

