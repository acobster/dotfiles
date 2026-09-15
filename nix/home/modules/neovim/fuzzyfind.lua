--------------------------
     -- Fuzzy Find --
--------------------------

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>ag', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

local finder = {
  mappings = {
    i = {
      ["<C-L>"] = "select_tab",
      ["<C-K>"] = "select_vertical",
    },
  },
}
require('telescope').setup {
  pickers = {
    find_files = {
      hidden   = true,
      mappings = finder['mappings'],
    },
    live_grep  = finder,
    buffers    = finder,
    help_tags  = finder,
  },
}
