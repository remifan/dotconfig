-- ============================================================================
-- UI Enhancement Plugin Configuration
-- ============================================================================
-- Note: Colorscheme is in after/plugin/colorscheme.lua (loads first)

-- ============================================================================
-- Statusline
-- ============================================================================
pcall(require, 'config.statusline')

-- ============================================================================
-- Visual Enhancements
-- ============================================================================

-- indent-blankline: Show indent guides
local ibl_ok, ibl = pcall(require, "ibl")
if ibl_ok then
  ibl.setup({
    scope = { enabled = false },
  })
end

-- stay-centered: Optionally keep cursor centered
local sc_ok, stay_centered = pcall(require, 'stay-centered')
if sc_ok then
  stay_centered.setup({
    enabled = false  -- Disabled by default, toggle with <leader>st
  })
  vim.keymap.set({ 'n', 'v' }, '<leader>st', stay_centered.toggle, {
    desc = 'Toggle stay-centered.nvim'
  })
end

-- ============================================================================
-- Developer Tools UI
-- ============================================================================

-- trouble.nvim: Enhanced diagnostics list
local trouble_ok, trouble = pcall(require, "trouble")
if trouble_ok then
  trouble.setup({
    icons = false,
    fold_open = "v",
    fold_closed = ">",
    indent_lines = false,
    signs = {
      error = "E",
      warning = "W",
      hint = "H",
      information = "I"
    },
    use_diagnostic_signs = false
  })
  vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
  vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
  vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
  vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
  vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
  vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)
end
