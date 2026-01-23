""Minimal .vimrc without lsp.
set nocompatible

if has ('filetype')
	filetype plugin indent on
endif

if has ('syntax')
	syntax on
endif

set number
set relativenumber

set tabstop=4
set shiftwidth=4 "
set autoindent
set smartindent
set title
set shell=/bin/bash

set nowrap
set hls
set wildmenu
set clipboard=unnamed

nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <C-j> :tabprevious<CR>
nnoremap <C-k> :tabnext<CR>
