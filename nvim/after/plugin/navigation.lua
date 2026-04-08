-- ============================================================================
-- Navigation and File Management Plugin Configuration
-- ============================================================================

-- ============================================================================
-- Telescope - Fuzzy Finder
-- ============================================================================
local telescope_ok, telescope = pcall(require, "telescope")
if telescope_ok then
  pcall(telescope.load_extension, "notify")
  local builtin = require('telescope.builtin')

  vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
  vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
end

-- ============================================================================
-- Yazi - Terminal File Manager
-- ============================================================================
local yazi_ok, yazi = pcall(require, "yazi")
if yazi_ok then
  yazi.setup({
    open_for_directories = true,
    keymaps = {
      show_help = "<f1>",
    },
  })

  vim.keymap.set({ "n", "v" }, '<leader>e', '<cmd>Yazi<cr>', { desc = 'Open file manager (yazi)' })
  vim.keymap.set('n', '<leader>yc', '<cmd>Yazi cwd<cr>', { desc = 'Open file manager (yazi, cwd)' })
  vim.keymap.set('n', '<leader>yr', '<cmd>Yazi toggle<cr>', { desc = 'Resume last yazi session' })
end

-- ============================================================================
-- FTerm - Floating Terminal
-- ============================================================================
local fterm_ok, fterm = pcall(require, 'FTerm')
if fterm_ok then
  fterm.setup({
    dimensions = {
      height = 0.9,
      width = 0.9,
    }
  })

  vim.keymap.set('n', '<leader>t', '<CMD>lua require("FTerm").toggle()<CR>', {
    desc = 'Toggle floating terminal'
  })
  vim.keymap.set('t', '<leader>t', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', {
    desc = 'Toggle floating terminal'
  })
end
