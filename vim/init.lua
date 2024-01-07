-------------------------
-- Misc. configuration --
-------------------------

local set = vim.opt

set.undodir = vim.fn.stdpath('config') .. '/undodir'
set.undofile = true

vim.g.vim_markdown_folding_disabled = 1


--------------------------
     -- Fuzzy Find --
--------------------------

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>ag', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

local mapping_table = {
  mappings = {
    i = {
      ["<C-L>"] = "select_tab",
      ["<C-K>"] = "select_vertical",
    },
  },
}
require('telescope').setup {
  pickers = {
    find_files = mapping_table,
    live_grep  = mapping_table,
    buffers    = mapping_table,
    help_tags  = mapping_table,
  },
}


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
