------------------------------
-- Install common Vim stuff --
------------------------------

vim.cmd([[
  " Source vim files IFF they exist
  " https://devel.tech/snippets/n/vIIMz8vZ/load-vim-source-files-only-if-they-exist
  function! SourceIfExists(file)
    if filereadable(expand(a:file))
      exe 'source' a:file
    endif
  endfunction

  call SourceIfExists("~/dotfiles/vim/common.vim")
  "call SourceIfExists("~/dotfiles/vim/nvim-plugins.vim")
  call SourceIfExists("~/dotfiles/vim/syntastic.vim")
  call SourceIfExists("~/dotfiles/vim/color.vim")
  call SourceIfExists("~/dotfiles/vim/racket.vim")
  call SourceIfExists("~/dotfiles/vim/mappings.vim")

  " Reload nvim config
  " TODO figure out how to do this from Lua...
  command! Reload :source $MYVIMRC

  call SourceIfExists("~/.config/nvim/init.vim.local")
]])



-------------------------
-- Misc. configuration --
-------------------------

local set = vim.opt

set.undodir = vim.fn.stdpath('config') .. '/undodir'
set.undofile = true

vim.g.vim_markdown_folding_disabled = 1



--------------------
-- Org-mode setup --
--------------------

-- Load custom tree-sitter grammar for org filetype
-- require('orgmode').setup_ts_grammar()

-- Tree-sitter configuration
--require'nvim-treesitter.configs'.setup {
--  -- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
--  highlight = {
--    enable = true,
--    disable = {'org'}, -- Remove this to use TS highlighter for some of the highlights (Experimental)
--    additional_vim_regex_highlighting = {'org'}, -- Required since TS highlighter doesn't support all syntax features (conceal)
--  },
--  ensure_installed = {'org'}, -- Or run :TSUpdate org
--}

--require('orgmode').setup({
--  org_agenda_files = {'~/sync/org/*'},
--  org_default_notes_file = '~/syng/org/notes.org',
--})
