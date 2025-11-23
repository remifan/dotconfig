-- ============================================================================
-- LSP (Language Server Protocol) Plugins
-- ============================================================================
-- Plugins for code intelligence, autocompletion, and language servers

return {
  -- ============================================================================
  -- Core LSP Configuration
  -- ============================================================================
  {
    "neovim/nvim-lspconfig",
    config = function()
      require('config.lsp.handlers')
    end,
  },

  -- ============================================================================
  -- Mason - LSP Server Manager
  -- ============================================================================
  -- Automatically install and manage language servers
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        -- Automatically install these language servers
        ensure_installed = {
          "lua_ls",           -- Lua
          "rust_analyzer",    -- Rust
          "verible",          -- Verilog/SystemVerilog
          "pyright",          -- Python
        },
        -- Auto-enable all servers except those in exclude list
        automatic_enable = {
          exclude = {
            "verible",  -- Verible needs custom setup
          }
        }
      })
    end
  },
-- lazy.nvim
  {
    "remifan/lf.nvim",
    ft = "lf",
    dependencies = {
      "nvim-telescope/telescope.nvim",  -- Optional: enhanced library browser
    },
    -- Note: Diagram dependencies build automatically on first use
    -- No need to specify build command!
    config = function()
      require("lf").setup({
        enable_lsp = true,

        -- Syntax highlighting
        syntax = {
          auto_detect_target = true,
          target_language = nil,  -- or "C", "Cpp", "Python", "Rust", "TypeScript"
          indent = { size = 2, use_tabs = false },
        },

        -- LSP configuration
        lsp = {
          -- Auto-detected if nil. Priority order:
          -- 1. Environment variable: LF_LSP_JAR
          -- 2. Explicit jar_path config below
          -- 3. Common locations (~/lingua-franca/lsp/build/libs/, etc.)
          jar_path = nil,  -- or vim.fn.expand("~/lingua-franca/lsp/build/libs/lsp-*-all.jar")
          java_cmd = "java",
          java_args = { "-Xmx2G" },
          auto_start = true,
        },

        -- Build settings
        build = {
          auto_validate = true,
          show_progress = true,
          open_quickfix = true,
        },

        -- Keymaps
        keymaps = {
          build = "<leader>lb",
          run = "<leader>lr",
          diagram = "<leader>ld",
          library = "<leader>ll",
          show_ast = "<leader>la",
        },

        -- Diagram settings
        diagram = {
          no_browser = true,   -- Default: show URL without auto-opening browser (good for SSH)
                               -- Set to false to auto-open browser locally
          auto_update = true,  -- Auto-refresh diagram when switching between LF files
        },
      })
    end,
  },
}
