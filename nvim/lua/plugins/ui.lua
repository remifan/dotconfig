-- ============================================================================
-- UI Enhancement Plugins
-- ============================================================================
-- Plugins for visual enhancements, themes, statusline, and UI components

-- Theme to use across UI plugins
local theme = "nyoom-engineering/oxocarbon.nvim"

return {
  -- ============================================================================
  -- Color Scheme
  -- ============================================================================
  {
    'rockerBOO/boo-colorscheme-nvim',
    lazy = false,     -- Load immediately (needed for UI)
    priority = 1000,  -- Load before other plugins
    init = function()
      vim.wo.number = true
      vim.o.background = "dark"
      vim.o.termguicolors = true
    end,
    config = function()
      vim.cmd('colorscheme boo')
      require("boo-colorscheme").use({
        italic = true,
        theme = "boo"
      })
    end
  },

  -- ============================================================================
  -- Statusline
  -- ============================================================================
  {
    "remifan/express_line.nvim",
    config = function()
      require('config.statusline')
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-lua/lsp-status.nvim"
    }
  },

  -- ============================================================================
  -- Visual Enhancements
  -- ============================================================================

  -- Show indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("ibl").setup({
        scope = { enabled = false },
      })
    end,
    dependencies = { theme }
  },

  -- Automatically toggle between relative/absolute line numbers
  { "sitiom/nvim-numbertoggle" },

  -- Highlight cursor position on jump
  { "rainbowhxch/beacon.nvim" },

  -- Optionally keep cursor centered
  {
    'arnamak/stay-centered.nvim',
    lazy = false,
    config = function()
      require('stay-centered').setup({
        enabled = false  -- Disabled by default, toggle with <leader>st
      })
      vim.keymap.set({ 'n', 'v' }, '<leader>st', require('stay-centered').toggle, {
        desc = 'Toggle stay-centered.nvim'
      })
    end
  },

  -- ============================================================================
  -- Developer Tools UI
  -- ============================================================================

  -- Enhanced diagnostics list (LSP errors/warnings)
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup({
        icons = false,
        fold_open = "v",
        fold_closed = ">",
        indent_lines = false,
        signs = {
          error = "E",
          warning = "W",
          hint = "H",
          information = "I"
        },
        use_diagnostic_signs = false
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
      vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
      vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
      vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
      vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
      vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)
    end
  },

  -- Better notification UI
  { "rcarriga/nvim-notify" },

  -- Markdown rendering in Neovim
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" }  -- Only load for markdown files
  },

  -- Icons for file types
  { "nvim-tree/nvim-web-devicons" },
}
