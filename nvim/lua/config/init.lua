require('config.tree-sitter')
require('config.colorscheme')
require('gitsigns').setup()
require('statusline.evil_lualine')
require('config.compe')
require('nvim_comment').setup()
require('colorizer').setup()
require('config.quick-scope')
require('config.floaterm')
require('config.illuminate')
require('config.symbols-outline')

vim.cmd [[
let g:vista_default_executive = 'nvim_lsp'
]]

local actions = require("telescope.actions")
local telescope = require("telescope")

telescope.setup {
  defaults = {
    layout_strategy='vertical',    
    layout_config = {              
      vertical = { width = 0.9 },  
      horizontal = { width = 0.9 },
    },                           
  },
}
