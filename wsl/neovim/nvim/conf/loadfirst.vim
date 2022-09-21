" Environment detection
if has('win32') || has ('win64')
  let g:plugged_home = "~/AppData/Local/nvim/plugged"
else
  let g:plugged_home = "~/.local/share/nvim/plugged"
endif

" Allow cursor change in tmux
let no_buffers_menu=1
if !exists('g:not_finish_vimplug')
  if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI ="\<Esc>]50;CursorShape=0\x7"
  endif
endif

" Syntax
syntax on
syntax enable
set ruler

" Change window title to current file being edited
set title

" Disable error beeps
set noerrorbells

" Display cli tab complete options as menu
set wildmenu

" True color support, if available
if has("termguicolors")
  set termguicolors
endif

" Set rendering options
set encoding=utf-8
set fileencoding=utf-8
set linebreak
set wrap

" Enable line numbers
set number

" Open invisible buffer on start
set hidden

" Show last command
set showcmd

" Mouse support
set mouse=a

" Cleanup commandline
set noshowmode
set noshowmatch
set lazyredraw

" Improve searching within file
set ignorecase
set smartcase
" Highlight while searching
set hlsearch
" Enable incremental search
set incsearch

" Tab/indent config
set expandtab
set tabstop=2
set shiftwidth=2
set shiftround
set smarttab

" Performance options
set complete-=i

" Turn off backup
set nobackup
set noswapfile
set nowritebackup

" Vim autoformat
noremap <F3> :Autoformat<CR>

" Misc
set autoread
set backspace=indent,eol,start
set confirm
set history=1000
set wildignore+=.pyc,.swp
set bomb
let mapleader=','

" Try to set shell from env, default to bash
if exists("$SHELL")
  set shell=$SHELL
else
  set shell=/bin/bash
endif

" Session management
let g:session_directory = "~/.config/nvim/session"
