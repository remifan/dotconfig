set nocompatible
" vim plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'ntpeters/vim-better-whitespace'
Plug 'AndrewRadev/sideways.vim'
Plug 'airblade/vim-gitgutter'
Plug 'mhinz/vim-startify'
" toggle, display and navigate marks
Plug 'kshenoy/vim-signature'
Plug 'mcchrish/nnn.vim'
Plug 'danro/rename.vim'
" fzf utitlies
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" A Git wrapper
Plug 'tpope/vim-fugitive'
" comment stuff out
Plug 'tpope/vim-commentary'
" move lines and selections up and down
Plug 'matze/vim-move'
" A solid language pack for Vim
Plug 'sheerun/vim-polyglot'
" Bluish color scheme for Vim and Neovim
Plug 'cocopon/iceberg.vim'
" Vim/Neovim plugin for editing Jupyter notebook (ipynb) files
Plug 'goerz/jupytext.vim'
call plug#end()

" For plugins to load correctly
filetype plugin indent on

" Encoding
set encoding=utf-8

" to make float window work
set hidden

" color scheme
set background=dark
set t_Co=256
colorscheme iceberg

"This unsets the "last search pattern" register by hitting return
nnoremap <silent> <CR> :nohlsearch<CR><CR>

syntax enable

" turn hybrid line numbers on
:set number relativenumber
:set nu rnu
" :highlight LineNr ctermfg=grey

" Show file stats
set ruler

" Blink cursor on error instead of beeping (grr)
set visualbell

set formatoptions-=t
set textwidth=79
" Status bar
" set laststatus=2
" Whitespace
" set tabstop=4
" set shiftwidth=4
" set softtabstop=4
" set expandtab
" set noshiftround
" set autoindent
"highlight clear SignColumn

" --------------------    nnn   ------------------------
let g:nnn#layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Debug' } }

let g:nnn#action = {
      \ '<c-t>': 'tab split',
      \ '<c-x>': 'split',
      \ '<c-v>': 'vsplit' }

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
"  sideways arguments movement
nnoremap <c-h> :SidewaysLeft<cr>
nnoremap <c-l> :SidewaysRight<cr>

" sideways text objects
omap aa <Plug>SidewaysArgumentTextobjA
xmap aa <Plug>SidewaysArgumentTextobjA
omap ia <Plug>SidewaysArgumentTextobjI
xmap ia <Plug>SidewaysArgumentTextobjI


" ------------------ fzf -------------------------
map <c-p> :Files<CR>
map <c-b> :Buffers<CR>


