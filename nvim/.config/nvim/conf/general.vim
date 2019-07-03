"" General Editor Settings

" editor settings, indents, etc
set number " show line numbers
set autoindent " inherit last line's indentation
set expandtab " convert tabs to spaces
set shiftround " round indentation to nearest multiple of shiftwidth
set shiftwidth=4
set smarttab " insert tabstop number of spaces when tab is pressed
set tabstop=4
set softtabstop=0
set colorcolumn=90  " Show 90th character
"set termguicolors  " breaks stuff over ssh
set showcmd  " shows last command

" search options
set hlsearch " search highlighting
set ignorecase
set incsearch " incremental search/partial matches
set smartcase " switch to case sensitive if uppercase letter detected


" performance options
set complete-=i " limit files searched for autocomplete
set lazyredraw " don't update screen during macro/script execution
set nobackup
set noswapfile


" text rendering options
set display+=lastline " always try to show paragraph's last line
set encoding=utf-8
set fileencoding=utf-8
set linebreak " avoid wrapping line in middle of a word
set scrolloff=1 " number of screen lines to keep above/below cursor
set wrap " enable line wrapping
"

" Misc options
set autoread " automatically re-read if unmodified version open in nvim
set backspace=indent,eol,start " allow backspacing over indents, line breaks, inserts
"set backupdir=~/.cache/nvim " dir to store backup files
set confirm " prompt when closing without saving file with changes
set history=1000 " increase undo limit
set wildignore+=.pyc,.swp " ignored file extensions
set bomb  " editing between Windows & Linux
set foldmethod=marker  " Code folding
let mapleader=','  " Not sure what this does
set hidden  " enable hidden buffers
filetype plugin indent on

" tries to set shell from env, defaults to bash
if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/sh
endif

" session management
let g:session_directory = "~/.config/nvim/session"
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1
