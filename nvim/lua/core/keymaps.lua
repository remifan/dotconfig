-- ============================================================================
-- General Keymaps
-- ============================================================================
-- This file contains general keymaps that are not plugin-specific.
-- Plugin-specific keymaps are defined in their respective plugin configs.

-- NOTE: Leader key configuration is handled by lazy.nvim before plugins load
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

-- Additional general keymaps can be added here as needed
-- Example:
-- vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save file' })
