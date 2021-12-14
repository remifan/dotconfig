-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
    use { 'wbthomason/packer.nvim', opt = true } -- Packer can manage itself as an optional plugin
    use { 'neovim/nvim-lspconfig' } -- LSP and completion
    use { 'williamboman/nvim-lsp-installer' } -- seamlessly manage LSP servers locally with :LspInstall
    use { 'hrsh7th/nvim-compe' } -- Auto completion Lua plugin for nvim
    use { 'onsails/lspkind-nvim' } --  pictograms for neovim lsp completion items
    use { 'ray-x/lsp_signature.nvim' }  -- LSP signature hint as you type
    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    } -- highly extendable fuzzy finder over lists
    use {
        'lewis6991/gitsigns.nvim',
        requires = {'nvim-lua/plenary.nvim'}
    } -- Git integration for buffers
    use {'voldikss/vim-floaterm'} -- Terminal manager for (neo)vim
    use {'justinmk/vim-sneak'} -- easy motion by s{char}{char}
    use {'kshenoy/vim-signature'} -- toggle, display and navigate marks
    use {'matze/vim-move'} -- move lines and selections up and down
    use {'mg979/vim-visual-multi'} -- Multiple cursors plugin for vim/neovim
    use {'junegunn/vim-easy-align'} -- A Vim alignment plugin
    use {'AndrewRadev/sideways.vim'} -- move function arguments left and right
    use {'wellle/targets.vim'} -- provides additional text objects
    use {'unblevable/quick-scope'} -- left-right movement in Vim
    use {'andymass/vim-matchup'} -- even better % navigate and highlight matching words
    use {'mhinz/vim-startify'} -- fancy start screen for Vim
    use {'RRethy/vim-illuminate'} -- automatically highlighting other uses of the word under the cursor
    use {'haya14busa/incsearch.vim'} -- Improved incremental searching for Vim
    use {'haya14busa/incsearch-fuzzy.vim'} -- incremantal fuzzy search extension for incsearch.vim
    use {'sheerun/vim-polyglot'} -- A solid language pack for Vim
    use {'terrortylor/nvim-comment'} -- A comment toggler for Neovim
    use {'mbbill/undotree'} -- The undo history visualizer
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }  -- Nvim Treesitter
    use {'folke/lsp-colors.nvim'} -- creates missing LSP diagnostics highlight groups for color old schemes
    use {'norcalli/nvim-colorizer.lua'} -- Neovim colorizer
    use {
        'nvim-lualine/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true}
    } -- A blazing fast and easy to configure neovim statusline
    use { 'danro/rename.vim' } -- Rename the current file in the vim buffer + retain relative path
    use { 'tpope/vim-surround' } -- Delete/change/add parentheses/quotes
    use { 'sbdchd/neoformat' } --  A (Neo)vim plugin for formatting code.
    use { 'junegunn/fzf' } -- A command-line fuzzy finder
    use {
        "folke/zen-mode.nvim",
        config = function()
            require("zen-mode").setup {
              -- your configuration comes here
              -- or leave it empty to use the default settings
              -- refer to the configuration section below
            }
        end
    } -- Distraction-free coding for Neovim
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
    } -- A pretty diagnostics, references, telescope results
    use {"tversteeg/registers.nvim"} -- preview the contents of the registers
    use {"npxbr/glow.nvim"} -- A markdown preview directly in your neovim
    -- color schemes --
    use {'rafamadriz/neon'}
    use {'marko-cerovac/material.nvim'}
    use {'cocopon/iceberg.vim'}
end)
