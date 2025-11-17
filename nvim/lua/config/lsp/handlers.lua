-- ============================================================================
-- LSP Handlers and Configuration
-- ============================================================================
-- This file sets up LSP keymaps, handlers, and server configurations

local lspconfig = require('lspconfig')

-- ============================================================================
-- Verible LSP Setup (SystemVerilog/Verilog)
-- ============================================================================
-- Custom configuration for Verible language server
lspconfig.verible.setup({
  cmd = { "verible-verilog-ls", "--lsp_enable_hover" },
  filetypes = { "verilog", "systemverilog" },
  root_dir = require("lspconfig.util").root_pattern(".git", "."),
})

-- ============================================================================
-- Global LSP Diagnostic Keymaps
-- ============================================================================
-- These work even when LSP is not attached to a buffer

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, {
  desc = 'Open diagnostic float'
})
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {
  desc = 'Go to previous diagnostic'
})
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {
  desc = 'Go to next diagnostic'
})
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, {
  desc = 'Add diagnostics to location list'
})

-- ============================================================================
-- LSP Attach Autocommand
-- ============================================================================
-- Set up buffer-local keymaps and options when LSP attaches to a buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Always show sign column to prevent text shifting
    vim.opt.signcolumn = "yes"

    -- ========================================================================
    -- Buffer-local LSP Keymaps
    -- ========================================================================
    local opts = { buffer = ev.buf }

    -- Navigation
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
      vim.tbl_extend('force', opts, { desc = 'Go to declaration' }))
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition,
      vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,
      vim.tbl_extend('force', opts, { desc = 'Go to implementation' }))
    vim.keymap.set('n', 'gr', vim.lsp.buf.references,
      vim.tbl_extend('force', opts, { desc = 'Show references' }))
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition,
      vim.tbl_extend('force', opts, { desc = 'Go to type definition' }))

    -- Documentation
    vim.keymap.set('n', 'K', vim.lsp.buf.hover,
      vim.tbl_extend('force', opts, { desc = 'Hover documentation' }))
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help,
      vim.tbl_extend('force', opts, { desc = 'Signature help' }))
    vim.keymap.set('n', 'g?', vim.diagnostic.open_float,
      vim.tbl_extend('force', opts, { desc = 'Show diagnostic' }))

    -- Workspace management
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder,
      vim.tbl_extend('force', opts, { desc = 'Add workspace folder' }))
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder,
      vim.tbl_extend('force', opts, { desc = 'Remove workspace folder' }))
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, vim.tbl_extend('force', opts, { desc = 'List workspace folders' }))

    -- Code actions
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename,
      vim.tbl_extend('force', opts, { desc = 'Rename symbol' }))
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action,
      vim.tbl_extend('force', opts, { desc = 'Code action' }))
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format({ async = true })
    end, vim.tbl_extend('force', opts, { desc = 'Format buffer' }))

    -- Telescope integration for symbols
    vim.keymap.set('n', 'gs', "<cmd>lua require'telescope.builtin'.lsp_document_symbols{}<CR>",
      vim.tbl_extend('force', opts, { desc = 'Document symbols' }))
    vim.keymap.set('n', 'gws', "<cmd>lua require'telescope.builtin'.lsp_dynamic_workspace_symbols{}<CR>",
      vim.tbl_extend('force', opts, { desc = 'Workspace symbols (dynamic)' }))
    vim.keymap.set('n', 'gWs', "<cmd>lua require'telescope.builtin'.lsp_workspace_symbols{}<CR>",
      vim.tbl_extend('force', opts, { desc = 'Workspace symbols' }))
  end,
})
