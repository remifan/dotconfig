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

  -- ============================================================================
  -- LSP UI Enhancements
  -- ============================================================================

  -- Show LSP progress notifications (bottom right)
  {
    "j-hui/fidget.nvim",
    opts = {},
  },
}
