-- ============================================================================
-- Utility Plugins
-- ============================================================================
-- Miscellaneous utilities and helper plugins

return {
  -- ============================================================================
  -- Register and Clipboard Management
  -- ============================================================================

  -- Preview and select from registers (quote key or Ctrl-R in insert)
  {
    "tversteeg/registers.nvim",
    name = "registers",
    keys = {
      { "\"",    mode = { "n", "v" } },
      { "<C-R>", mode = "i" }
    },
    cmd = "Registers",
  },

  -- Copy to system clipboard over SSH/tmux using OSC52
  {
    'ojroques/nvim-osc52',
    config = function()
      vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, {
        expr = true,
        desc = 'Copy with OSC52'
      })
      vim.keymap.set('n', '<leader>cc', '<leader>c_', {
        remap = true,
        desc = 'Copy line with OSC52'
      })
      vim.keymap.set('v', '<leader>c', require('osc52').copy_visual, {
        desc = 'Copy selection with OSC52'
      })

      require('osc52').setup({
        max_length = 0,           -- No limit on selection length
        silent = false,           -- Show message on successful copy
        trim = false,             -- Don't trim whitespace
        tmux_passthrough = true,  -- Enable tmux passthrough (requires: set -g allow-passthrough on)
      })
    end,
  },

  -- ============================================================================
  -- Marks and Navigation
  -- ============================================================================

  -- Show marks in the gutter
  { "kshenoy/vim-signature" },

  -- ============================================================================
  -- File Utilities
  -- ============================================================================

  -- Rename files (:Rename command)
  { "danro/rename.vim" },

  -- Auto-detect and set indent settings
  {
    "nmac427/guess-indent.nvim",
    config = function()
      require('guess-indent').setup({})
    end
  },

  -- ============================================================================
  -- Image and Media
  -- ============================================================================

  -- Paste images from clipboard into markdown
  { "HakonHarnes/img-clip.nvim" },

  -- ============================================================================
  -- Input Utilities
  -- ============================================================================

  -- Floating input box for various plugins
  { "liangxianzhe/floating-input.nvim" },

  -- ============================================================================
  -- Typst
  -- ============================================================================

  -- Live preview for Typst documents
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    opts = {},
  },
}
