-- ============================================================================
-- Color Scheme (loads first alphabetically to set highlights early)
-- ============================================================================

local ok, boo = pcall(require, "boo-colorscheme")
if not ok then return end

boo.use({
  italic = true,
  theme = "boo"
})
vim.cmd.colorscheme('boo')
