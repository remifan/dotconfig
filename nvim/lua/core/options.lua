-- ============================================================================
-- General Neovim Options
-- ============================================================================
-- This file contains all general vim options and settings that are not
-- plugin-specific. These are the core editor behaviors and preferences.

-- Enable filetype detection, plugins, and indentation
vim.cmd('filetype plugin indent on')

-- ============================================================================
-- Indentation Settings
-- ============================================================================
local indent = 4

vim.o.tabstop = indent        -- Number of spaces a tab counts for
vim.o.softtabstop = indent    -- Number of spaces for tab in insert mode
vim.o.shiftwidth = indent     -- Number of spaces for auto-indent
vim.o.expandtab = true        -- Use spaces instead of tabs
vim.o.autoindent = true       -- Copy indent from current line when starting new line
vim.o.smartindent = true      -- Smart autoindenting when starting a new line

-- ============================================================================
-- UI Settings
-- ============================================================================
vim.wo.number = true          -- Show line numbers
-- vim.wo.relativenumber = true  -- Show relative line numbers (commented, toggle with sitiom/nvim-numbertoggle)
vim.o.background = "dark"     -- Use dark background
vim.o.termguicolors = true    -- Enable 24-bit RGB colors

-- ============================================================================
-- Neovide-specific Settings
-- ============================================================================
-- Disable cursor animation in Neovide GUI
if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0.0
end

-- ============================================================================
-- Folding Settings
-- ============================================================================
-- Start with all folds open (used with nvim-origami plugin)
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
