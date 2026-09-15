-------------------------
-- Misc. configuration --
-------------------------

local set = vim.opt

set.undodir = vim.fn.stdpath('config') .. '/undodir'
set.undofile = true

vim.g.vim_markdown_folding_disabled = 1
