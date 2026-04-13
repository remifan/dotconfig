-- ============================================================================
-- Editor Enhancement Plugin Configuration
-- ============================================================================

-- ============================================================================
-- Treesitter
-- ============================================================================
local ts_ok, ts = pcall(require, 'nvim-treesitter')
if ts_ok then
  ts.setup({
    indent = { enable = true },
  })

  -- Prompt to install missing treesitter parsers on FileType
  local prompted = {}
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('ts_auto_prompt', { clear = true }),
    callback = function(ev)
      local ft = ev.match
      if prompted[ft] then return end
      -- lf.nvim handles its own treesitter install in its ftplugin; don't double-prompt.
      if ft == 'lf' then return end
      -- Skip plugin/special buffers
      local bt = vim.bo[ev.buf].buftype
      if bt ~= '' then return end

      local lang = vim.treesitter.language.get_lang(ft) or ft
      if pcall(vim.treesitter.language.inspect, lang) then return end

      -- Only prompt if nvim-treesitter has a parser available for this language
      local ok, parsers = pcall(require, 'nvim-treesitter.parsers')
      if not ok or not parsers.get_parser_configs()[lang] then return end

      prompted[ft] = true

      vim.schedule(function()
        vim.ui.select({ 'Yes', 'No' }, {
          prompt = "Install treesitter parser for '" .. lang .. "'?",
        }, function(choice)
          if choice ~= 'Yes' then return end
          vim.cmd('TSInstall ' .. lang)
        end)
      end)
    end,
  })

  -- Incremental treesitter node selection
  local function get_node_range(node)
    local sr, sc, er, ec = node:range()
    return sr, sc, er, ec
  end

  vim.keymap.set('n', '<CR>', function()
    local node = vim.treesitter.get_node()
    if not node then return end
    local sr, sc, er, ec = get_node_range(node)
    vim.api.nvim_buf_set_mark(0, '<', sr + 1, sc, {})
    vim.api.nvim_buf_set_mark(0, '>', er + 1, ec - 1, {})
    vim.cmd('normal! gv')
  end, { desc = 'Init treesitter selection' })

  vim.keymap.set('v', '<CR>', function()
    local node = vim.treesitter.get_node()
    if not node then return end
    local parent = node:parent()
    if not parent then return end
    local sr, sc, er, ec = get_node_range(parent)
    vim.api.nvim_buf_set_mark(0, '<', sr + 1, sc, {})
    vim.api.nvim_buf_set_mark(0, '>', er + 1, ec - 1, {})
    vim.cmd('normal! gv')
  end, { desc = 'Expand treesitter selection' })

  vim.keymap.set('v', '<BS>', function()
    local node = vim.treesitter.get_node()
    if not node then return end
    for child in node:iter_children() do
      if child:named() then
        local sr, sc, er, ec = get_node_range(child)
        local cursor = vim.api.nvim_win_get_cursor(0)
        if sr <= cursor[1] - 1 and er >= cursor[1] - 1 then
          vim.api.nvim_buf_set_mark(0, '<', sr + 1, sc, {})
          vim.api.nvim_buf_set_mark(0, '>', er + 1, ec - 1, {})
          vim.cmd('normal! gv')
          return
        end
      end
    end
  end, { desc = 'Shrink treesitter selection' })
end

-- ============================================================================
-- Motion and Movement
-- ============================================================================

-- move.nvim: Move lines and blocks with Alt+hjkl
local move_opts = { noremap = true, silent = true }
vim.keymap.set('n', '<A-j>', ':MoveLine(1)<CR>', move_opts)
vim.keymap.set('n', '<A-k>', ':MoveLine(-1)<CR>', move_opts)
vim.keymap.set('n', '<A-h>', ':MoveHChar(-1)<CR>', move_opts)
vim.keymap.set('n', '<A-l>', ':MoveHChar(1)<CR>', move_opts)
vim.keymap.set('n', '<leader>wf', ':MoveWord(1)<CR>', move_opts)
vim.keymap.set('n', '<leader>wb', ':MoveWord(-1)<CR>', move_opts)
vim.keymap.set('v', '<A-j>', ':MoveBlock(1)<CR>', move_opts)
vim.keymap.set('v', '<A-k>', ':MoveBlock(-1)<CR>', move_opts)
vim.keymap.set('v', '<A-h>', ':MoveHBlock(-1)<CR>', move_opts)
vim.keymap.set('v', '<A-l>', ':MoveHBlock(1)<CR>', move_opts)

-- leap.nvim: Lightning-fast navigation (s/S keys)
vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap)')
vim.keymap.set('n',             'S', '<Plug>(leap-from-window)')

-- CamelCaseMotion: CamelCase and snake_case word motions
vim.cmd([[
  map <silent> W <Plug>CamelCaseMotion_w
  map <silent> B <Plug>CamelCaseMotion_b
  map <silent> E <Plug>CamelCaseMotion_e
  map <silent> gE <Plug>CamelCaseMotion_ge
  omap <silent> iW <Plug>CamelCaseMotion_iw
  xmap <silent> iW <Plug>CamelCaseMotion_iw
  omap <silent> iB <Plug>CamelCaseMotion_ib
  xmap <silent> iB <Plug>CamelCaseMotion_ib
  omap <silent> iE <Plug>CamelCaseMotion_ie
  xmap <silent> iE <Plug>CamelCaseMotion_ie
]])

-- treemonkey: Navigate and select treesitter nodes (m in visual/operator mode)
vim.keymap.set({"x", "o"}, "m", function()
  require("treemonkey").select({ ignore_injections = false })
end)

-- ============================================================================
-- Text Objects and Manipulation
-- ============================================================================

-- nvim-surround
local surround_ok, surround = pcall(require, "nvim-surround")
if surround_ok then surround.setup() end

-- vim-easy-align
vim.cmd([[
  xmap ga <Plug>(EasyAlign)
  nmap ga <Plug>(EasyAlign)
]])

-- sideways.vim: Swap function arguments (Ctrl+h/l)
vim.keymap.set('n', '<c-h>', '<cmd>SidewaysLeft<cr>', { noremap = true })
vim.keymap.set('n', '<c-l>', '<cmd>SidewaysRight<cr>', { noremap = true })

-- ============================================================================
-- Editing Utilities
-- ============================================================================

-- Comment.nvim
local comment_ok, comment = pcall(require, 'Comment')
if comment_ok then comment.setup() end

-- nvim-origami: Smart folding
local origami_ok, origami = pcall(require, "origami")
if origami_ok then origami.setup() end

-- neominimap keymaps
vim.keymap.set('n', '<leader>nm', '<cmd>Neominimap Toggle<cr>', { desc = 'Toggle global minimap' })
vim.keymap.set('n', '<leader>no', '<cmd>Neominimap Enable<cr>', { desc = 'Enable global minimap' })
vim.keymap.set('n', '<leader>nc', '<cmd>Neominimap Disable<cr>', { desc = 'Disable global minimap' })
vim.keymap.set('n', '<leader>nr', '<cmd>Neominimap Refresh<cr>', { desc = 'Refresh global minimap' })
vim.keymap.set('n', '<leader>nwt', '<cmd>Neominimap WinToggle<cr>', { desc = 'Toggle minimap for current window' })
vim.keymap.set('n', '<leader>nwr', '<cmd>Neominimap WinRefresh<cr>', { desc = 'Refresh minimap for current window' })
vim.keymap.set('n', '<leader>nwo', '<cmd>Neominimap WinEnable<cr>', { desc = 'Enable minimap for current window' })
vim.keymap.set('n', '<leader>nwc', '<cmd>Neominimap WinDisable<cr>', { desc = 'Disable minimap for current window' })
vim.keymap.set('n', '<leader>ntt', '<cmd>Neominimap TabToggle<cr>', { desc = 'Toggle minimap for current tab' })
vim.keymap.set('n', '<leader>ntr', '<cmd>Neominimap TabRefresh<cr>', { desc = 'Refresh minimap for current tab' })
vim.keymap.set('n', '<leader>nto', '<cmd>Neominimap TabEnable<cr>', { desc = 'Enable minimap for current tab' })
vim.keymap.set('n', '<leader>ntc', '<cmd>Neominimap TabDisable<cr>', { desc = 'Disable minimap for current tab' })
vim.keymap.set('n', '<leader>nbt', '<cmd>Neominimap BufToggle<cr>', { desc = 'Toggle minimap for current buffer' })
vim.keymap.set('n', '<leader>nbr', '<cmd>Neominimap BufRefresh<cr>', { desc = 'Refresh minimap for current buffer' })
vim.keymap.set('n', '<leader>nbo', '<cmd>Neominimap BufEnable<cr>', { desc = 'Enable minimap for current buffer' })
vim.keymap.set('n', '<leader>nbc', '<cmd>Neominimap BufDisable<cr>', { desc = 'Disable minimap for current buffer' })
vim.keymap.set('n', '<leader>nf', '<cmd>Neominimap Focus<cr>', { desc = 'Focus on minimap' })
vim.keymap.set('n', '<leader>nu', '<cmd>Neominimap Unfocus<cr>', { desc = 'Unfocus minimap' })
vim.keymap.set('n', '<leader>ns', '<cmd>Neominimap ToggleFocus<cr>', { desc = 'Switch focus on minimap' })
