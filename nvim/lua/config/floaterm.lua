vim.cmd [[
" Close window if the job exits normally, otherwise stay it with messages like [Process exited 101]
let g:floaterm_autoclose = 1
let g:floaterm_width = 0.8
let g:floaterm_height = 0.8

" Set floaterm window background to gray once the cursor moves out from it
hi FloatermNC guibg=gray

" colors
hi FloatermBorder guibg=None guifg=gray
]]
