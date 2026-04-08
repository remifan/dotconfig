-- ============================================================================
-- General Keymaps
-- ============================================================================
-- This file contains general keymaps that are not plugin-specific.
-- Plugin-specific keymaps are defined in their respective plugin configs.

-- NOTE: Leader key must be set in init.lua before plugins load.
-- To change leader key, uncomment and modify these lines in init.lua:
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = " "

-- ============================================================================
-- Editor Shortcuts
-- ============================================================================

-- Clear search highlights with Enter in normal mode
vim.keymap.set('n', '<CR>', '<cmd>noh<CR>', {
  silent = true,
  desc = 'Clear search highlights'
})

-- ============================================================================
-- Built-in Undotree (Neovim 0.12)
-- ============================================================================
vim.keymap.set('n', '<leader>u', '<cmd>Undotree<CR>', {
  silent = true,
  desc = 'Toggle undotree'
})
