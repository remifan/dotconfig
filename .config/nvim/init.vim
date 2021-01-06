set nocompatible
" vim plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'tpope/vim-sensible'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'airblade/vim-gitgutter'
Plug 'kshenoy/vim-signature'
Plug 'danro/rename.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'matze/vim-move'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'unblevable/quick-scope'
if !exists('g:vscode')
  if !has('win32')
    Plug 'mcchrish/nnn.vim'
  endif
  Plug 'sheerun/vim-polyglot'
  Plug 'ntpeters/vim-better-whitespace'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'mhinz/vim-startify'
  Plug 'AndrewRadev/sideways.vim'
  Plug 'cocopon/iceberg.vim'
  Plug 'goerz/jupytext.vim'
  Plug 'brooth/far.vim'
  Plug 'wesQ3/vim-windowswap'
endif
call plug#end()

" color scheme
set background=dark
set t_Co=256
colorscheme iceberg

" to make float window work
set hidden

" turn hybrid line numbers on
set number relativenumber

" Blink cursor on error instead of beeping (grr)
set visualbell

"This unsets the "last search pattern" register by hitting return
nnoremap <silent> <CR> :nohlsearch<CR><CR>


" --------------------    nnn   ------------------------
if !has('win32') && !exists('g:vscode')
  let g:nnn#layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Debug' } }

  let g:nnn#action = {
        \ '<c-t>': 'tab split',
        \ '<c-x>': 'split',
        \ '<c-v>': 'vsplit' }
end

" -------------------- EasyAlign -----------------------

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


" -------------------- EasyMotion ----------------------
" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)


" ------------------ incsearch + easymontion ----------------------
function! s:config_easymotion(...) abort
  return incsearch#util#deepextend(deepcopy({
  \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  \   'keymap': {
  \     "\<Space>\<CR>": '<Over>(easymotion)'
  \   },
  \   'is_expr': 0
  \ }), get(a:, 1, {}))
endfunction

function! s:config_easyfuzzymotion(...) abort
  return extend(copy({
  \   'converters': [incsearch#config#fuzzyword#converter()],
  \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  \   'keymap': {"\<Space>\<CR>": '<Over>(easymotion)'},
  \   'is_expr': 0,
  \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> /  incsearch#go(<SID>config_easymotion())
noremap <silent><expr> ?  incsearch#go(<SID>config_easymotion({'command': '?'}))
noremap <silent><expr> g/ incsearch#go(<SID>config_easymotion({'is_stay': 1}))
noremap <silent><expr> z/ incsearch#go(<SID>config_easyfuzzymotion())
noremap <silent><expr> z? incsearch#go(<SID>config_easyfuzzymotion({'command': '?'}))
noremap <silent><expr> zg/ incsearch#go(<SID>config_easyfuzzymotion({'is_stay': 1}))


" ----------------- sideways  --------------------
if !exists('g:vscode')
  " sideways arguments movement
  nnoremap <c-h> :SidewaysLeft<cr>
  nnoremap <c-l> :SidewaysRight<cr>

  " sideways text objects
  omap aa <Plug>SidewaysArgumentTextobjA
  xmap aa <Plug>SidewaysArgumentTextobjA
  omap ia <Plug>SidewaysArgumentTextobjI
  xmap ia <Plug>SidewaysArgumentTextobjI
endif


" ------------------ fzf -------------------------
if !exists('g:vscode')
  map <c-p> :Files<CR>
  map <c-k> :Buffers<CR>
endif


" ------------------ Far -------------------------
if !exists('g:vscode')
  set lazyredraw            " improve scrolling performance when navigating through large results
  set regexpengine=1        " use old regexp engine
  set ignorecase smartcase  " ignore case only when the pattern contains no capital letters

  " shortcut for far.vim find
  nnoremap <silent> <Find-Shortcut>  :Farf<cr>
  vnoremap <silent> <Find-Shortcut>  :Farf<cr>

  " shortcut for far.vim replace
  nnoremap <silent> <Replace-Shortcut>  :Farr<cr>
  vnoremap <silent> <Replace-Shortcut>  :Farr<cr>
endif


" ------------------ quickscope -------------------
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']


