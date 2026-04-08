-- ============================================================================
-- Neovim 0.12 Configuration Entry Point
-- ============================================================================
-- Uses vim.pack (built-in plugin manager), built-in LSP completion,
-- and built-in undotree.
--
-- Configuration Structure:
--   lua/core/          - Core Neovim settings (options, keymaps)
--   after/plugin/      - Plugin configurations (loaded after plugins)
--   lua/config/        - Extended plugin configurations
--
-- Plugin Management:
--   :lua vim.pack.update()                          Update all plugins
--   :lua vim.pack.update(nil, {target='lockfile'})  Sync to lockfile
--   :lua vim.pack.get()                             List installed plugins
--   :checkhealth vim.pack                           Health check

vim.loader.enable()

-- ============================================================================
-- Leader Key Setup
-- ============================================================================
-- IMPORTANT: Must be set before plugins load to ensure mappings work
-- Uncomment these lines if you want to use Space as leader key:
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = " "

-- ============================================================================
-- Load Core Configuration
-- ============================================================================
require('core.options')
require('core.keymaps')

-- ============================================================================
-- Pre-Plugin Settings
-- ============================================================================
-- Settings that must be applied before plugins load (vim.g variables,
-- highlight autocommands, etc.)

-- quick-scope highlight colors (must be set before ColorScheme event)
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('qs_colors', { clear = true }),
  callback = function()
    vim.api.nvim_set_hl(0, 'QuickScopePrimary', { fg = '#f08080', ctermfg = 155 })
    vim.api.nvim_set_hl(0, 'QuickScopeSecondary', { fg = '#FFD700', ctermfg = 81 })
  end,
})

-- neominimap defaults
vim.opt.wrap = false
vim.opt.sidescrolloff = 36
vim.g.neominimap = { auto_enable = false }

-- vimtex viewer
if vim.fn.has('win32') == 1 then
  vim.g.vimtex_view_general_viewer = 'SumatraPDF'
  vim.g.vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'
else
  vim.g.vimtex_view_method = "zathura"
end

-- matchup
vim.g.matchup_matchparen_offscreen = { method = "popup" }

-- ============================================================================
-- Build Hooks (must be defined before vim.pack.add)
-- ============================================================================
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if kind == 'install' or kind == 'update' then
      if name == 'nvim-treesitter' then
        if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
        vim.cmd('TSUpdate')
      end
    end
  end,
})

-- ============================================================================
-- Plugins (vim.pack)
-- ============================================================================
-- All plugins are declared here. Configuration is in after/plugin/*.lua
-- Wrapped in pcall: if some plugins fail to download (network issues),
-- the rest still load. Retry with :lua vim.pack.update()
local pack_ok, pack_err = pcall(vim.pack.add, {
  -- Editor enhancements
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/fedepujol/move.nvim',
  { src = 'https://codeberg.org/andyg/leap.nvim' },
  'https://github.com/bkad/CamelCaseMotion',
  'https://github.com/unblevable/quick-scope',
  'https://github.com/atusy/treemonkey.nvim',
  'https://github.com/kylechui/nvim-surround',
  'https://github.com/wellle/targets.vim',
  'https://github.com/michaeljsmith/vim-indent-object',
  'https://github.com/vim-scripts/ReplaceWithRegister',
  'https://github.com/junegunn/vim-easy-align',
  'https://github.com/AndrewRadev/sideways.vim',
  'https://github.com/andymass/vim-matchup',
  'https://github.com/numToStr/Comment.nvim',
  'https://github.com/mg979/vim-visual-multi',
  'https://github.com/RRethy/vim-illuminate',
  'https://github.com/chrisgrieser/nvim-origami',
  'https://github.com/Isrothy/neominimap.nvim',
  'https://github.com/lervag/vimtex',

  -- LSP and code intelligence
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/remifan/lf.nvim',

  -- UI
  'https://github.com/rockerBOO/boo-colorscheme-nvim',
  'https://github.com/nyoom-engineering/oxocarbon.nvim',
  'https://github.com/remifan/express_line.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-lua/lsp-status.nvim',
  'https://github.com/lukas-reineke/indent-blankline.nvim',
  'https://github.com/sitiom/nvim-numbertoggle',
  'https://github.com/rainbowhxch/beacon.nvim',
  'https://github.com/arnamak/stay-centered.nvim',
  'https://github.com/folke/trouble.nvim',
  'https://github.com/rcarriga/nvim-notify',
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',

  -- Git
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/kdheepak/lazygit.nvim',

  -- Navigation
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/mikavilpas/yazi.nvim',
  'https://github.com/numToStr/FTerm.nvim',

  -- Tools
  'https://github.com/tversteeg/registers.nvim',
  'https://github.com/ojroques/nvim-osc52',
  'https://github.com/kshenoy/vim-signature',
  'https://github.com/danro/rename.vim',
  'https://github.com/nmac427/guess-indent.nvim',
  'https://github.com/HakonHarnes/img-clip.nvim',
  'https://github.com/liangxianzhe/floating-input.nvim',
  'https://github.com/chomosuke/typst-preview.nvim',
})
if not pack_ok then
  vim.notify('vim.pack: some plugins failed to install. Run :lua vim.pack.update() to retry.\n' .. pack_err, vim.log.levels.WARN)
end

-- ============================================================================
-- Built-in Undotree (Neovim 0.12)
-- ============================================================================
vim.cmd.packadd('nvim.undotree')
