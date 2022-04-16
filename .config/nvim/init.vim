" Source vim files IFF they exist
" https://devel.tech/snippets/n/vIIMz8vZ/load-vim-source-files-only-if-they-exist
function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction

call SourceIfExists("~/dotfiles/vim/common.vim")
call SourceIfExists("~/dotfiles/vim/nvim-plugins.vim")
call SourceIfExists("~/dotfiles/vim/syntastic.vim")
call SourceIfExists("~/dotfiles/vim/color.vim")
call SourceIfExists("~/dotfiles/vim/racket.vim")
call SourceIfExists("~/dotfiles/vim/mappings.vim")

" Markdown config (for better performance)
let g:vim_markdown_folding_disabled = 1

" Persistent undo!
set undodir=~/.config/nvim/undodir
set undofile

" Reload nvim config
command Reload :source ~/.config/nvim/init.vim

call SourceIfExists("~/.config/nvim/init.vim.local")
