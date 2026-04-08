-- ============================================================================
-- Git Integration Plugin Configuration
-- ============================================================================

-- Gitsigns: Git signs in the gutter + hunk operations
pcall(require, 'config.git')

-- Lazygit: Full git UI in a floating terminal
vim.keymap.set('n', '<leader>lg', '<cmd>LazyGit<cr>', { desc = 'Open LazyGit' })
