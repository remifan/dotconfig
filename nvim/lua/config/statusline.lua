-- ============================================================================
-- Statusline Configuration (Express Line)
-- ============================================================================
-- Custom statusline configuration using express_line.nvim

local generator = function(--[[ win_id ]])
  local builtin = require("el.builtin")
  local extensions = require("el.extensions")
  local sections = require("el.sections")
  local subscribe = require("el.subscribe")

  -- ========================================================================
  -- Statusline Color Highlights
  -- ========================================================================
  vim.cmd([[highlight Statusline guifg=#808080 gui=nocombine]])
  vim.cmd([[highlight ElNormal guifg=#708090 gui=nocombine]])
  vim.cmd([[highlight ElInsert guifg=#BC8F8F gui=nocombine]])
  vim.cmd([[highlight ElInsertCompletion guifg=#BC8F8F gui=nocombine]])
  vim.cmd([[highlight ElVisual guifg=#87CEEB gui=nocombine]])
  vim.cmd([[highlight ElVisualBlock guifg=#87CEEB gui=nocombine]])
  vim.cmd([[highlight ElVisualLine guifg=#87CEEB gui=nocombine]])
  vim.cmd([[highlight ElVisualReplace guifg=#87CEEB gui=nocombine]])
  vim.cmd([[highlight ElCommand guifg=#F5DEB3 gui=nocombine]])
  vim.cmd([[highlight ElCommandEx guifg=#F5DEB3 gui=nocombine]])
  vim.cmd([[highlight ElCommandCV guifg=#F5DEB3 gui=nocombine]])

  -- ========================================================================
  -- Statusline Layout
  -- ========================================================================
  return {
    -- Left side
    extensions.mode,              -- Current mode (NORMAL, INSERT, etc)
    sections.split,               -- Separator
    builtin.file_relative,        -- Relative file path
    sections.collapse_builtin({
      " ",
      builtin.modified_flag,      -- [+] if modified
    }),

    -- Git information
    sections.collapse_builtin({
      subscribe.buf_autocmd("el_git_branch", "BufEnter", function(window, buffer)
        local branch = extensions.git_branch(window, buffer)
        if branch then
          return " | -" .. branch
        end
      end),
      subscribe.buf_autocmd("el_git_status", "BufWritePost", function(window, buffer)
        local changes = extensions.git_changes(window, buffer)
        if changes then
          return changes
        end
      end),
    }),

    sections.split,               -- Push remaining to right side

    -- Right side
    -- Uncomment these if you want LSP status in statusline:
    -- lsp_statusline.segment,
    -- lsp_statusline.current_function,

    "[",
    builtin.line_with_width(4),   -- Line number
    ":",
    builtin.column_with_width(3), -- Column number
    "]",
    sections.collapse_builtin({
      "[",
      builtin.help_list,          -- [Help] if help buffer
      builtin.readonly_list,      -- [RO] if readonly
      "]",
    }),
    builtin.filetype,             -- File type
  }
end

-- Initialize express_line with custom generator
require('el').setup({ generator = generator })
