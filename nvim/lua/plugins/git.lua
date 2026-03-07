-- ============================================================================
-- Git Integration Plugins
-- ============================================================================
-- Plugins for Git integration and version control

return {
  -- Git signs in the gutter (added/modified/deleted lines)
  -- Also provides git hunk operations and navigation
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('config.git')
    end,
  },

  -- Lazygit integration (full git UI in a floating terminal)
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open LazyGit" },
    },
  },
}
