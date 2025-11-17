-- ============================================================================
-- Editor Enhancement Plugins
-- ============================================================================
-- Plugins that enhance text editing, motions, selections, and manipulations

return {
  -- ============================================================================
  -- Treesitter - Advanced syntax highlighting and code understanding
  -- ============================================================================
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter').setup({
        indent = { enable = true },
      })
      require('nvim-treesitter.configs').setup({
        -- Incremental selection with v/V keys
        incremental_selection = {
          enable = true,
          keymaps = {
            node_incremental = "v",
            node_decremental = "V",
          },
        },
      })
    end,
  },

  -- ============================================================================
  -- Motion and Movement Plugins
  -- ============================================================================

  -- Move lines and blocks with Alt+hjkl
  {
    "fedepujol/move.nvim",
    config = function()
      local opts = { noremap = true, silent = true }
      -- Normal mode: move lines and characters
      vim.keymap.set('n', '<A-j>', ':MoveLine(1)<CR>', opts)
      vim.keymap.set('n', '<A-k>', ':MoveLine(-1)<CR>', opts)
      vim.keymap.set('n', '<A-h>', ':MoveHChar(-1)<CR>', opts)
      vim.keymap.set('n', '<A-l>', ':MoveHChar(1)<CR>', opts)
      vim.keymap.set('n', '<leader>wf', ':MoveWord(1)<CR>', opts)
      vim.keymap.set('n', '<leader>wb', ':MoveWord(-1)<CR>', opts)

      -- Visual mode: move blocks
      vim.keymap.set('v', '<A-j>', ':MoveBlock(1)<CR>', opts)
      vim.keymap.set('v', '<A-k>', ':MoveBlock(-1)<CR>', opts)
      vim.keymap.set('v', '<A-h>', ':MoveHBlock(-1)<CR>', opts)
      vim.keymap.set('v', '<A-l>', ':MoveHBlock(1)<CR>', opts)
    end
  },

  -- Lightning-fast navigation with leap (s/S keys)
  {
    "ggandor/leap.nvim",
    config = function()
      require('leap').add_default_mappings()
    end
  },

  -- CamelCase and snake_case word motions (W/B/E)
  {
    "bkad/CamelCaseMotion",
    init = function()
      vim.cmd([[
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
      ]])
    end,
  },

  -- Highlight unique characters for f/F/t/T motions
  {
    "unblevable/quick-scope",
    init = function()
      -- Custom colors for dark theme (set before plugin loads)
      vim.cmd([[
        augroup qs_colors
          autocmd!
          autocmd ColorScheme * highlight QuickScopePrimary guifg='#f08080' ctermfg=155
          autocmd ColorScheme * highlight QuickScopeSecondary guifg='#FFD700' ctermfg=81
        augroup END
      ]])
    end
  },

  -- Navigate and select treesitter nodes (m in visual/operator mode)
  {
    "atusy/treemonkey.nvim",
    init = function()
      vim.keymap.set({"x", "o"}, "m", function()
        require("treemonkey").select({ ignore_injections = false })
      end)
    end
  },

  -- ============================================================================
  -- Text Objects and Selections
  -- ============================================================================

  -- Surround text objects (ys/cs/ds commands)
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- Additional useful text objects
  { "wellle/targets.vim" },        -- Add more text objects (pair, quote, separator, argument)
  { "michaeljsmith/vim-indent-object" },  -- Indent-based text objects (ii/ai)

  -- ============================================================================
  -- Text Manipulation
  -- ============================================================================

  -- Replace text with register content (gr + motion)
  { "vim-scripts/ReplaceWithRegister" },

  -- Align text with visual selection (ga)
  {
    "junegunn/vim-easy-align",
    config = function()
      vim.cmd([[
        xmap ga <Plug>(EasyAlign)
        nmap ga <Plug>(EasyAlign)
      ]])
    end
  },

  -- Swap function arguments left/right (Ctrl+h/l)
  {
    "AndrewRadev/sideways.vim",
    config = function()
      vim.keymap.set('n', '<c-h>', '<cmd>SidewaysLeft<cr>', { noremap = true })
      vim.keymap.set('n', '<c-l>', '<cmd>SidewaysRight<cr>', { noremap = true })
    end
  },

  -- Enhanced matching with % (if/endif, html tags, etc)
  {
    "andymass/vim-matchup",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },

  -- ============================================================================
  -- Editing Utilities
  -- ============================================================================

  -- Toggle comments (gcc, gc + motion)
  {
    'numToStr/Comment.nvim',
    opts = {},
    lazy = false,
  },

  -- Multiple cursors (<C-n> to select next occurrence)
  { "mg979/vim-visual-multi" },

  -- Highlight word under cursor
  { "RRethy/vim-illuminate" },

  -- Smart folding based on indentation
  {
    "chrisgrieser/nvim-origami",
    event = "VeryLazy",
    opts = {},
  },
  ---@module "neominimap.config.meta"
  {
    "Isrothy/neominimap.nvim",
    version = "v3.x.x",
    lazy = false, -- NOTE: NO NEED to Lazy load
    -- Optional. You can also set your own keybindings
    keys = {
      -- Global Minimap Controls
      { "<leader>nm", "<cmd>Neominimap Toggle<cr>", desc = "Toggle global minimap" },
      { "<leader>no", "<cmd>Neominimap Enable<cr>", desc = "Enable global minimap" },
      { "<leader>nc", "<cmd>Neominimap Disable<cr>", desc = "Disable global minimap" },
      { "<leader>nr", "<cmd>Neominimap Refresh<cr>", desc = "Refresh global minimap" },

      -- Window-Specific Minimap Controls
      { "<leader>nwt", "<cmd>Neominimap WinToggle<cr>", desc = "Toggle minimap for current window" },
      { "<leader>nwr", "<cmd>Neominimap WinRefresh<cr>", desc = "Refresh minimap for current window" },
      { "<leader>nwo", "<cmd>Neominimap WinEnable<cr>", desc = "Enable minimap for current window" },
      { "<leader>nwc", "<cmd>Neominimap WinDisable<cr>", desc = "Disable minimap for current window" },

      -- Tab-Specific Minimap Controls
      { "<leader>ntt", "<cmd>Neominimap TabToggle<cr>", desc = "Toggle minimap for current tab" },
      { "<leader>ntr", "<cmd>Neominimap TabRefresh<cr>", desc = "Refresh minimap for current tab" },
      { "<leader>nto", "<cmd>Neominimap TabEnable<cr>", desc = "Enable minimap for current tab" },
      { "<leader>ntc", "<cmd>Neominimap TabDisable<cr>", desc = "Disable minimap for current tab" },

      -- Buffer-Specific Minimap Controls
      { "<leader>nbt", "<cmd>Neominimap BufToggle<cr>", desc = "Toggle minimap for current buffer" },
      { "<leader>nbr", "<cmd>Neominimap BufRefresh<cr>", desc = "Refresh minimap for current buffer" },
      { "<leader>nbo", "<cmd>Neominimap BufEnable<cr>", desc = "Enable minimap for current buffer" },
      { "<leader>nbc", "<cmd>Neominimap BufDisable<cr>", desc = "Disable minimap for current buffer" },

      ---Focus Controls
      { "<leader>nf", "<cmd>Neominimap Focus<cr>", desc = "Focus on minimap" },
      { "<leader>nu", "<cmd>Neominimap Unfocus<cr>", desc = "Unfocus minimap" },
      { "<leader>ns", "<cmd>Neominimap ToggleFocus<cr>", desc = "Switch focus on minimap" },
    },
    init = function()
      -- The following options are recommended when layout == "float"
      vim.opt.wrap = false
      vim.opt.sidescrolloff = 36 -- Set a large value

      --- Put your configuration here
      ---@type Neominimap.UserConfig
      vim.g.neominimap = {
        auto_enable = false, -- Enable the plugin by default
      }
    end,
  },
}
