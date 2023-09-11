local generator = function(--[[ win_id ]])
  local builtin = require "el.builtin"
  local extensions = require "el.extensions"
  local log = require "el.log"
  local meta = require "el.meta"
  local processor = require "el.processor"
  local sections = require "el.sections"
  local subscribe = require "el.subscribe"
  local lsp_statusline = require "el.plugins.lsp_status"
  vim.cmd [[highlight Statusline guifg=#808080 gui=nocombine ]]
  vim.cmd [[highlight ElNormal guifg=#708090 gui=nocombine ]]
  vim.cmd [[highlight ElInsert guifg=#BC8F8F gui=nocombine ]]
  vim.cmd [[highlight ElInsertCompletion guifg=#BC8F8F gui=nocombine ]]
  vim.cmd [[highlight ElVisual guifg=#87CEEB gui=nocombine ]]
  vim.cmd [[highlight ElVisualBlock guifg=#87CEEB gui=nocombine ]]
  vim.cmd [[highlight ElVisualLine guifg=#87CEEB gui=nocombine ]]
  vim.cmd [[highlight ElVisualReplace guifg=#87CEEB gui=nocombine ]]
  vim.cmd [[highlight ElCommand guifg=#F5DEB3 gui=nocombine ]]
  vim.cmd [[highlight ElCommandEx guifg=#F5DEB3 gui=nocombine ]]
  vim.cmd [[highlight ElCommandCV guifg=#F5DEB3 gui=nocombine ]]


  return {
    extensions.mode,
    sections.split,
    builtin.file_relative,
    sections.collapse_builtin {
      " ",
      builtin.modified_flag,
    },
    sections.collapse_builtin {
      subscribe.buf_autocmd("el_git_branch", "BufEnter", function(window, buffer)
        branch = extensions.git_branch(window, buffer)
        if branch then
            branch = " | -" .. branch
            return branch
        end
      end),
      subscribe.buf_autocmd("el_git_status", "BufWritePost", function(window, buffer)
        changes = extensions.git_changes(window, buffer)
        if changes then
            return changes -- .. " "
        end
      end),
    },
    sections.split,
    -- lsp_statusline.segment,
    -- lsp_statusline.current_function,
    "[",
    builtin.line_with_width(4),
    ":",
    builtin.column_with_width(3),
    "]",
    sections.collapse_builtin {
      "[",
      builtin.help_list,
      builtin.readonly_list,
      "]",
    },
    builtin.filetype,
  }
end

-- And then when you're all done, just call
require('el').setup { generator = generator }
