if exists('g:fvim_loaded')
" good old 'set guifont' compatibility
  set guifont=Fira\ Code:h16
" Ctrl-ScrollWheel for zooming in/out
  nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
  nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>
  nnoremap <A-CR> :FVimToggleFullScreen<CR>
endif

if exists('g:fvim_loaded')
  FVimCursorSmoothBlink v:true
  FVimCustomTitleBar v:true
endif
