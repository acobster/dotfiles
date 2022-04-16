" PLUGINZ

" https://stackoverflow.com/questions/48700563/how-do-i-install-plugins-in-neovim-correctly
" https://github.com/junegunn/vim-plug#usage
call plug#begin(stdpath('data') . '/plugged')

" The colors, Duke! The colors!
Plug 'altercation/vim-colors-solarized'
Plug 'bronson/vim-trailing-whitespace'

" Navigation
Plug 'wesQ3/vim-windowswap' " ,ww for swapping buffers
Plug 'junegunn/fzf', { 'commit': '4145f53f3d343c389ff974b1f1a68eeb39fba18b', 'do': { -> fzf#install } }
Plug 'junegunn/fzf.vim'

" Syntax
Plug 'vim-syntastic/syntastic'
Plug 'elzr/vim-json'
Plug 'machakann/vim-swap' " swap fn args

" Formatting
Plug 'junegunn/vim-easy-align'

" Git
Plug 'airblade/vim-gitgutter'

" Sessions
Plug 'tpope/vim-obsession'

call SourceIfExists("~/.config/nvim/plugins.vim")

" Initialize plugin system
call plug#end()
