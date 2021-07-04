-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
    -- Packer can manage itself as an optional plugin
    use {'wbthomason/packer.nvim', opt = true}
    -- LSP and completion
    use { 'neovim/nvim-lspconfig' }
    use {'kabouzeid/nvim-lspinstall'}
    use { 'hrsh7th/nvim-compe' }
    use { 'onsails/lspkind-nvim' }
    use { 'ray-x/lsp_signature.nvim' }
    use { 'karb94/neoscroll.nvim' }
    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    }
    use {
        'lewis6991/gitsigns.nvim',
        requires = {'nvim-lua/plenary.nvim'}
    }
    use {'kosayoda/nvim-lightbulb'}
    use {'justinmk/vim-sneak'}
    use {'kshenoy/vim-signature'}
    use {'matze/vim-move'}
    use {'junegunn/vim-easy-align'}
    use {'AndrewRadev/sideways.vim'}
    use {'unblevable/quick-scope'}
    use {'andymass/vim-matchup'}
    use {'mhinz/vim-startify'}
    use {'haya14busa/incsearch.vim'}
    use {'haya14busa/incsearch-fuzzy.vim'}
    use {'sheerun/vim-polyglot'}
    use {'terrortylor/nvim-comment'}
    use {'lukas-reineke/indent-blankline.nvim'}
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use {'rafamadriz/neon'}
    use {'marko-cerovac/material.nvim'}
    use {'cocopon/iceberg.vim'}
    use {'folke/lsp-colors.nvim'}
    use {'norcalli/nvim-colorizer.lua'}
    use {
        'hoob3rt/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }
    use { 'danro/rename.vim' }
    use { 'tpope/vim-surround' }
    use { 'sbdchd/neoformat' }
    use {
      "folke/zen-mode.nvim",
      config = function()
        require("zen-mode").setup {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      end
    }
    use {
      "folke/trouble.nvim",
      requires = "kyazdani42/nvim-web-devicons",
      config = function()
        require("trouble").setup {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      end
    }
    use {"tversteeg/registers.nvim"}
    use {"npxbr/glow.nvim"}
end)
