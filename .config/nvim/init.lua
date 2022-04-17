vim.cmd([[
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

  " Reload nvim config
  " TODO figure out how to do this from Lua...
  command! Reload :source $MYVIMRC

  call SourceIfExists("~/.config/nvim/init.vim.local")
]])

local set = vim.opt

set.undodir = "~/.config/nvim/undodir"
set.undofile = true

vim.g.vim_markdown_folding_disabled = 1
