local utils = require('utils')
utils.map('n', '<CR>', '<cmd>noh<CR>', {silent = true}) -- Clear highlights

vim.cmd [[
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
]]

vim.cmd [[
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
map z/ <Plug>(incsearch-fuzzyspell-/)
map z? <Plug>(incsearch-fuzzyspell-?)
map zg/ <Plug>(incsearch-fuzzyspell-stay)
]]

utils.map('n', '<c-h>', '<cmd>SidewaysLeft<cr>', {noremap = true})
utils.map('n', '<c-l>', '<cmd>SidewaysRight<cr>', {noremap = true})

utils.map('n', '<leader>ff', '<cmd>Telescope find_files<CR>', {noremap = true})
utils.map('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', {noremap = true})
utils.map('n', '<leader>fb', '<cmd>Telescope buffers<CR>', {noremap = true})
utils.map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', {noremap = true})


utils.map("n", "<F7>",  "<cmd>FloatermNew<CR>", {silent = true, noremap = true})
utils.map("t", "<F7>",  "<C-\\><C-n><cmd>FloatermNew<CR>", {silent = true, noremap = true})
utils.map("n", "<F8>",  "<cmd>FloatermPrev<CR>", {silent = true, noremap = true})
utils.map("t", "<F8>",  "<C-\\><C-n><cmd>FloatermPrev<CR>", {silent = true, noremap = true})
utils.map("n", "<F9>",  "<cmd>FloatermNext<CR>", {silent = true, noremap = true})
utils.map("t", "<F9>",  "<C-\\><C-n><cmd>FloatermNext<CR>", {silent = true, noremap = true})
utils.map("n", "<F12>", "<cmd>FloatermToggle<CR>", {silent = true, noremap = true})
utils.map("t", "<F12>", "<C-\\><C-n><cmd>FloatermToggle<CR>", {silent = true, noremap = true})


vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>Trouble lsp_workspace_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble lsp_document_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "gR", "<cmd>Trouble lsp_references<cr>",
  {silent = true, noremap = true}
)
