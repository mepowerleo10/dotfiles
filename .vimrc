source $VIMRUNTIME/defaults.vim
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set clipboard=unnamedplus

call plug#begin()
  Plug 'ghifarit53/tokyonight.vim'
  Plug 'itchyny/lightline.vim'
  Plug 'sheerun/vim-polyglot'
  Plug 'joshdick/onedark.vim'
  Plug 'jiangmiao/auto-pairs'
call plug#end()

set termguicolors


syntax on
" colorscheme onedark

let g:onedark_hide_endofbuffer = 1
let g:onedark_terminal_italics = 1

set laststatus=2
set noshowmode

" lightline config
let g:lightline = {
        \ 'colorscheme': 'onedark',
        \ 'active': {
        \   'left': [ ['mode', 'paste'] ],
        \   'right': [ ['readonly', 'filename'], ['filetype'] ]
        \ },
        \ 'inactive': {
        \ 'left': [ [] ],
        \ 'right': [ ['filename'] ] } }
let g:lightline.tabline = {
        \ 'left': [ ['tabs'] ],
        \ 'right': [ [] ] }
let g:lightline.tab = {
        \ 'active' : [ 'filename', 'modified' ],
        \ 'inactive' : [ 'filename', 'modified' ] }

let g:lightline = {'colorscheme' : 'onedark'}

