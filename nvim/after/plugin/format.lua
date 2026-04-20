-- ============================================================================
-- Formatting (conform.nvim)
-- ============================================================================

local ok, conform = pcall(require, 'conform')
if not ok then return end

conform.setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'black' },
    rust = { 'rustfmt' },
    typst = { 'typstfmt' },
    javascript = { 'prettier' },
    typescript = { 'prettier' },
    json = { 'prettier' },
    yaml = { 'prettier' },
    markdown = { 'prettier' },
    html = { 'prettier' },
    css = { 'prettier' },
    sh = { 'shfmt' },
    bash = { 'shfmt' },
  },
})

vim.keymap.set({ 'n', 'v' }, '<leader>ft', function()
  conform.format({ async = true, lsp_format = 'fallback' })
end, { desc = 'Format buffer/selection' })
