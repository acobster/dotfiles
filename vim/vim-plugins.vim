" PLUGINZ

" https://github.com/junegunn/vim-plug#usage
call plug#begin()

" The colors, Duke! The colors!
Plug 'altercation/vim-colors-solarized'
Plug 'bronson/vim-trailing-whitespace'

" Navigation
Plug 'wesQ3/vim-windowswap' " ,ww for swapping buffers
Plug 'junegunn/fzf', { 'commit': '4145f53f3d343c389ff974b1f1a68eeb39fba18b', 'do': { -> fzf#install } }
Plug 'junegunn/fzf.vim'

" Syntax
Plug 'vim-syntastic/syntastic'

" Initialize plugin system
call plug#end()
