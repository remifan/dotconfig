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
}
