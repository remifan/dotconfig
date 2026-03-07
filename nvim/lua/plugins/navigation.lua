-- ============================================================================
-- Navigation and File Management Plugins
-- ============================================================================
-- Plugins for file exploration, fuzzy finding, and terminal access

-- Theme dependency for consistent UI
local theme = "nyoom-engineering/oxocarbon.nvim"

return {
  -- ============================================================================
  -- Fuzzy Finder - Telescope
  -- ============================================================================
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require("telescope").load_extension("notify")
      local builtin = require('telescope.builtin')

      -- Keymaps
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
    end
  },

  -- ============================================================================
  -- Terminal File Manager - yazi.nvim
  -- ============================================================================
  {
    "mikavilpas/yazi.nvim",
    version = "*", -- use the latest stable version
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
      {
        "<leader>e",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open file manager (yazi)",
      },
      {
        "<leader>yc",
        "<cmd>Yazi cwd<cr>",
        desc = "Open file manager (yazi, cwd)",
      },
      {
        "<leader>yr",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume last yazi session",
      },
    },
    ---@type YaziConfig | {}
    opts = {
      open_for_directories = true,
      keymaps = {
        show_help = "<f1>",
      },
    },
  },

  -- ============================================================================
  -- Terminal
  -- ============================================================================
  {
    "numToStr/FTerm.nvim",
    config = function()
      require('FTerm').setup({
        dimensions = {
          height = 0.9,
          width = 0.9,
        }
      })

      -- Toggle terminal with <leader>t
      vim.keymap.set('n', '<leader>t', '<CMD>lua require("FTerm").toggle()<CR>', {
        desc = 'Toggle floating terminal'
      })
      vim.keymap.set('t', '<leader>t', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', {
        desc = 'Toggle floating terminal'
      })
    end,
    dependencies = { theme },
  },
}
