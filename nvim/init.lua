-- vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
-- vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correctv

-- general
vim.cmd 'filetype plugin indent on'
intent = 4
vim.o.tabstop = intent
vim.o.softtabstop = intent
vim.o.shiftwidth = intent
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.keymap.set('n', '<CR>', '<cmd>noh<CR>', {silent = true}) -- Clear highlights
theme = "nyoom-engineering/oxocarbon.nvim"

if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0.0
end

-- bootstrap Lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- fire lazy plugins
require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require'nvim-treesitter'.setup {
        indent = { enable = true },
      }
      require'nvim-treesitter.configs'.setup {
        incremental_selection = {
          enable = true,
          keymaps = {
            node_incremental = "v",
            node_decremental = "V",
          },
        },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function ()
      require('lsp')
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = {"lua_ls", "rust_analyzer", "verible", "pyright"},
        automatic_enable = {
          exclude = {
              "verible",
          }
        }
      }
    end
  },
  {
    "numToStr/FTerm.nvim",
    config = function()
      require'FTerm'.setup({
        -- border = 'none',
        dimensions  = {
            height = 0.9,
            width = 0.9,
        }
      })
      vim.keymap.set('n', '<leader>t', '<CMD>lua require("FTerm").toggle()<CR>')
      vim.keymap.set('t', '<leader>t', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
    end,
    dependencies={theme},
  },
  {
    "fedepujol/move.nvim",
    config = function()
      local opts = { noremap = true, silent = true }
      -- Normal-mode commands
      vim.keymap.set('n', '<A-j>', ':MoveLine(1)<CR>', opts)
      vim.keymap.set('n', '<A-k>', ':MoveLine(-1)<CR>', opts)
      vim.keymap.set('n', '<A-h>', ':MoveHChar(-1)<CR>', opts)
      vim.keymap.set('n', '<A-l>', ':MoveHChar(1)<CR>', opts)
      vim.keymap.set('n', '<leader>wf', ':MoveWord(1)<CR>', opts)
      vim.keymap.set('n', '<leader>wb', ':MoveWord(-1)<CR>', opts)
      
      -- Visual-mode commands
      vim.keymap.set('v', '<A-j>', ':MoveBlock(1)<CR>', opts)
      vim.keymap.set('v', '<A-k>', ':MoveBlock(-1)<CR>', opts)
      vim.keymap.set('v', '<A-h>', ':MoveHBlock(-1)<CR>', opts)
      vim.keymap.set('v', '<A-l>', ':MoveHBlock(1)<CR>', opts)
    end
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {"vim-scripts/ReplaceWithRegister"},
  {
    "ggandor/leap.nvim",
    config = function()
      require('leap').add_default_mappings()
    end
  },
  {
    "bkad/CamelCaseMotion",
    init = function()
      vim.cmd [[
        map <silent> W <Plug>CamelCaseMotion_w
        map <silent> B <Plug>CamelCaseMotion_b
        map <silent> E <Plug>CamelCaseMotion_e
        map <silent> gE <Plug>CamelCaseMotion_ge
        omap <silent> iW <Plug>CamelCaseMotion_iw
        xmap <silent> iW <Plug>CamelCaseMotion_iw
        omap <silent> iB <Plug>CamelCaseMotion_ib
        xmap <silent> iB <Plug>CamelCaseMotion_ib
        omap <silent> iE <Plug>CamelCaseMotion_ie
        xmap <silent> iE <Plug>CamelCaseMotion_ie
      ]]
    end,
  },
  {"michaeljsmith/vim-indent-object"},
  {
    "junegunn/vim-easy-align",
    config = function()
      vim.cmd [[
      xmap ga <Plug>(EasyAlign)
      nmap ga <Plug>(EasyAlign)
      ]]
    end
  },
  {
    "AndrewRadev/sideways.vim",
    config = function ()
      vim.keymap.set('n', '<c-h>', '<cmd>SidewaysLeft<cr>', {noremap = true})
      vim.keymap.set('n', '<c-l>', '<cmd>SidewaysRight<cr>', {noremap = true})
    end
  },
  {'wellle/targets.vim'},
  {
    "unblevable/quick-scope",
    init=function()
      -- color tweak for dark theme, has to be placed before it's loaded
      vim.cmd [[
        augroup qs_colors
          autocmd!
          autocmd ColorScheme * highlight QuickScopePrimary guifg='#f08080' ctermfg=155
          autocmd ColorScheme * highlight QuickScopeSecondary guifg='#FFD700' ctermfg=81
        augroup END
      ]]
    end
    },
  {
    "andymass/vim-matchup",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
    dependencies={theme}
  },
  {"RRethy/vim-illuminate"},
  {
    'numToStr/Comment.nvim',
    opts = {
        -- add any options here
    },
    lazy = false,
  },
  {"danro/rename.vim"}, -- maybe helpful without lsp
  {"mg979/vim-visual-multi"},
  {"rcarriga/nvim-notify"},
  {
    "tversteeg/registers.nvim",
     name = "registers",
     keys = {
       { "\"",    mode = { "n", "v" } },
       { "<C-R>", mode = "i" }
     },
     cmd = "Registers",
  },
  {"kshenoy/vim-signature"},
  {
    'rockerBOO/boo-colorscheme-nvim',
    lazy=false,
    init=function ()
      -- vim.wo.relativenumber = true
      vim.wo.number = true
      vim.o.background = "dark"
      vim.o.termguicolors = true
    end,
    config=function ()
      vim.cmd('colorscheme boo')
      require("boo-colorscheme").use({
        italic = true,
        theme = "boo"
      })
    end
  },
  { "sitiom/nvim-numbertoggle" },
  {
    'ojroques/nvim-osc52',
    config=function ()
      vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, {expr = true})
      vim.keymap.set('n', '<leader>cc', '<leader>c_', {remap = true})
      vim.keymap.set('v', '<leader>c', require('osc52').copy_visual)
      require('osc52').setup {
        max_length = 0,           -- Maximum length of selection (0 for no limit)
        silent = false,           -- Disable message on successful copy
        trim = false,             -- Trim surrounding whitespaces before copy
        tmux_passthrough = true, -- Use tmux passthrough (requires tmux: set -g allow-passthrough on)
      }
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("ibl").setup {
        scope = { enabled = false },
      }
    end,
    dependencies={theme}
  },
  {"nmac427/guess-indent.nvim", config = function() require('guess-indent').setup {} end},
  {"nvim-tree/nvim-web-devicons"},
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup {
        icons = false,
        fold_open = "v", -- icon used for open folds
        fold_closed = ">", -- icon used for closed folds
        indent_lines = false, -- add an indent guide below the fold icons
        signs = {
            -- icons / text used for a diagnostic
            error = "E",
            warning = "W",
            hint = "H",
            information = "I"
        },
        use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
      }
      vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
      vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
      vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
      vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
      vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
      vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)
    end
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitconf')
    end,
  },
  {
    "remifan/express_line.nvim",
    config = function()
      require('elconf')
    end,
    dependencies = { "nvim-lua/plenary.nvim", "nvim-lua/lsp-status.nvim"}
  },
  { "rainbowhxch/beacon.nvim" },
  {
    "echasnovski/mini.files",
    version = false, -- use latest
    config = function()
      require("mini.files").setup()
      -- Optional: open mini.files with current file's directory
      vim.keymap.set("n", "<leader>e", function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
      end, { desc = "Open file explorer (mini.files)" })
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    -- tag = '0.1.1',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require("telescope").load_extension("notify")
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    end
  },
  {
    "olimorris/codecompanion.nvim",
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" }
  },
  {
    "HakonHarnes/img-clip.nvim",
    opts = {
      filetypes = {
        codecompanion = {
          prompt_for_file_name = false,
          template = "[Image]($FILE_PATH)",
          use_absolute_path = true,
        },
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({})
    end,
  },
  {
    "chrisgrieser/nvim-origami",
    event = "VeryLazy",
    opts = {}, -- needed even when using default config

    -- recommended: disable vim's auto-folding
    init = function()
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
    end,
  },
  {
    "atusy/treemonkey.nvim",
    init = function()
      vim.keymap.set({"x", "o"}, "m", function()
        require("treemonkey").select({ ignore_injections = false })
      end)
    end
  },
  {"liangxianzhe/floating-input.nvim"}
})

