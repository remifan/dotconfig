require('config.lspkind')
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

vim.cmd [[
let g:vista_default_executive = 'nvim_lsp'
]]

local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")

local telescope = require("telescope")

telescope.setup {
  defaults = {
    mappings = {
      i = { ["<c-t>"] = trouble.open_with_trouble },
      n = { ["<c-t>"] = trouble.open_with_trouble },
    },
  },
}
