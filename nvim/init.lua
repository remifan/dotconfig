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
        -- interop with matchup
        matchup = {
          enable = true,              -- mandatory, false will disable the whole extension
          -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
        },
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
    end
  },
  {
    "williamboman/mason.nvim",
    build=":MasonUpdate",
    lazy=false,
    config=function()
      require("mason").setup()
    end
  },
  {
    "numToStr/FTerm.nvim",
    config = function()
      require'FTerm'.setup({
        border = 'none',
        dimensions  = {
            height = 0.9,
            width = 0.9,
        }
      })
      vim.keymap.set('n', '<A-i>', '<CMD>lua require("FTerm").toggle()<CR>')
      vim.keymap.set('t', '<A-i>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
    end,
    dependencies={theme},
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
  {"folke/which-key.nvim"},
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
  -- {"RRethy/vim-illuminate"},
  {
    "terrortylor/nvim-comment",
    config = function()
      require('nvim_comment').setup()
    end
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
    "nyoom-engineering/oxocarbon.nvim",
    lazy=false,
    init=function ()
      vim.wo.relativenumber = true
      vim.o.background = "dark"
      vim.o.termguicolors = true
    end,
    config=function ()
      vim.cmd('colorscheme oxocarbon')
    end
  },
  -- {
  --   "lukas-reineke/indent-blankline.nvim",
  --   init = function()
  --     -- color tweaks to match the theme
  --     vim.cmd [[highlight IndentBlanklineIndent1 guifg=#3B3B3B gui=nocombine]]
  --     vim.cmd [[highlight IndentBlanklineContextStart guisp=#808080 gui=nocombine]]
  --     vim.cmd [[highlight IndentBlanklineContextChar guifg=#808080 gui=nocombine]]
  --   end,
  --   config = function()
  --     require("ibl").setup {
  --         space_char_blankline = " ",
  --         show_current_context = true,
  --         show_current_context_start = true,
  --         char_highlight_list = {
  --             "IndentBlanklineIndent1",
  --         },
  --     }
  --   end,
  --   dependencies={theme}
  -- },
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
    end
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitconf')
    end,
  },
  {
    "ziontee113/SelectEase",
    config = function()
        require('seconf')
    end
  },
  {
    "tjdevries/express_line.nvim",
    config = function()
      require('elconf')
    end,
    dependencies = { "nvim-lua/plenary.nvim", "nvim-lua/lsp-status.nvim"}
  },
  { "rainbowhxch/beacon.nvim" }
})

