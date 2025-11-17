-- ============================================================================
-- Git Configuration (Gitsigns)
-- ============================================================================
-- Configure gitsigns for git integration in Neovim

require('gitsigns').setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- ========================================================================
    -- Navigation between git hunks
    -- ========================================================================
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true, desc = 'Next git hunk' })

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true, desc = 'Previous git hunk' })

    -- ========================================================================
    -- Hunk Actions
    -- ========================================================================
    map('n', '<leader>hs', gs.stage_hunk, { desc = 'Stage hunk' })
    map('n', '<leader>hr', gs.reset_hunk, { desc = 'Reset hunk' })
    map('v', '<leader>hs', function()
      gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = 'Stage selected hunk' })
    map('v', '<leader>hr', function()
      gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = 'Reset selected hunk' })

    -- Buffer-level operations
    map('n', '<leader>hS', gs.stage_buffer, { desc = 'Stage entire buffer' })
    map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' })
    map('n', '<leader>hR', gs.reset_buffer, { desc = 'Reset entire buffer' })

    -- Preview and blame
    map('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview hunk' })
    map('n', '<leader>hb', function()
      gs.blame_line({ full = true })
    end, { desc = 'Blame line (full)' })
    map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'Toggle line blame' })

    -- Diff operations
    map('n', '<leader>hd', gs.diffthis, { desc = 'Diff this' })
    map('n', '<leader>hD', function()
      gs.diffthis('~')
    end, { desc = 'Diff this (cached)' })
    map('n', '<leader>td', gs.toggle_deleted, { desc = 'Toggle deleted lines' })

    -- ========================================================================
    -- Text object for git hunks
    -- ========================================================================
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select git hunk' })
  end
})
