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
      -- Mason lacks pre-built binaries for Windows ARM64, so skip
      -- ensure_installed on that platform. Install servers manually
      -- (e.g. npm install -g pyright, cargo install rust-analyzer) and
      -- mason-lspconfig's automatic_enable will pick them up from PATH.
      local is_win_arm64 = vim.fn.has('win32') == 1
        and vim.env.PROCESSOR_ARCHITECTURE == 'ARM64'

      local servers = {
        "lua_ls",           -- Lua
        "rust_analyzer",    -- Rust
        "verible",          -- Verilog/SystemVerilog
        "pyright",          -- Python
        "tinymist",         -- Typst
      }

      require("mason-lspconfig").setup({
        ensure_installed = not is_win_arm64 and servers or {},
        automatic_enable = {
          exclude = {
            "verible",  -- Verible needs custom setup
          }
        }
      })

      -- On Windows ARM64, servers are installed manually (not via Mason),
      -- so automatic_enable won't see them. Explicitly enable them —
      -- lspconfig will only start a server if its executable is on PATH.
      if is_win_arm64 then
        for _, server in ipairs(servers) do
          if server ~= "verible" then
            vim.lsp.enable(server)
          end
        end
      end
    end
  },
  {
    "remifan/lf.nvim",
    ft = "lf",
    cmd = { "LFLspInstall", "LFLspStatus", "LFTSInstall", "LFTSUninstall", "LFTSStatus" },
    dependencies = {
      "nvim-telescope/telescope.nvim",  -- Optional: enhanced library browser
    },
    config = function()
      require("lf").setup({
        enable_lsp = true,

        -- Syntax highlighting
        syntax = {
          auto_detect_target = true,
          target_language = nil,  -- or "C", "Cpp", "Python", "Rust", "TypeScript"
          indent = { size = 4, use_tabs = false },
        },

        diagram = {
          no_browser = true -- Don't auto-open browser, just show URL
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
      })
    end,
  },
}
