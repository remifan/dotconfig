-- ============================================================================
-- Utility Plugin Configuration
-- ============================================================================

-- ============================================================================
-- Clipboard: Copy to system clipboard over SSH/tmux using OSC52
-- ============================================================================
local osc52_ok, osc52 = pcall(require, 'osc52')
if osc52_ok then
  vim.keymap.set('n', '<leader>c', osc52.copy_operator, {
    expr = true,
    desc = 'Copy with OSC52'
  })
  vim.keymap.set('n', '<leader>cc', '<leader>c_', {
    remap = true,
    desc = 'Copy line with OSC52'
  })
  vim.keymap.set('v', '<leader>c', osc52.copy_visual, {
    desc = 'Copy selection with OSC52'
  })

  osc52.setup({
    max_length = 0,
    silent = false,
    trim = false,
    tmux_passthrough = true,
  })
end

-- ============================================================================
-- Indent Detection
-- ============================================================================
local gi_ok, guess_indent = pcall(require, 'guess-indent')
if gi_ok then guess_indent.setup({}) end
