" {{{ Basic Setup

    " Allow true colors
    set termguicolors

    "" Encoding
    set encoding=utf-8
    set fileencoding=utf-8
    set fileencodings=utf-8
    set bomb
    set binary

    set foldmethod=marker

    "" Fix backspace indent
    set backspace=indent,eol,start

    "" Tabs. May be overwritten by autocmd rules
    set tabstop=4
    set softtabstop=0
    set shiftwidth=4
    set expandtab

    "" Map leader to ,
    let mapleader=','

    "" Enable hidden buffers
    set hidden

    "" Searching
    set hlsearch
    set incsearch
    set ignorecase
    set smartcase

    "" Directories for swp files
    set nobackup
    set noswapfile

    set fileformats=unix,dos,mac
    set showcmd

    " Python
    " let g:python3_host_prog='C:/Users/foo/Envs/neovim3/Scripts/python.exe'
    let g:python_host_prog='C:\Users\jxk5224\AppData\Local\nvim\neovim\Scripts'

" }}}

" {{{ Vim-Plug

    " {{{ Vim-Plug core settings

    if has('vim_starting')
      set nocompatible               " Be iMproved
    endif

    let vimplug_exists=expand('C:\Users\jxk5224\AppData\Local\nvim\autoload\plug.vim')

    let g:vim_bootstrap_langs = "python"
    let g:vim_bootstrap_editor = "nvim"             " nvim or vim

    if !filereadable(vimplug_exists)
      echo "Installing Vim-Plug..."
      echo ""
      silent !\curl -fLo C:\Users\jxk5224\AppData\Local\nvim\autoload\plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      let g:not_finish_vimplug = "yes"

      autocmd VimEnter * PlugInstall
    endif

    " Required:
    call plug#begin('C:\Users\jxk5224\AppData\Local\nvim\plugged')
    " expand('C:\Users\jxk5224\AppData\Local\nvim\plugged')

    " }}}

    " {{{ Plug Packages Install

    Plug 'scrooloose/nerdtree'
    Plug 'nathanaelkane/vim-indent-guides'
    Plug 'scrooloose/syntastic'
    Plug 'jistr/vim-nerdtree-tabs'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-fugitive'
    Plug 'vim-airblade/vim-gitgutter'
    "Plug 'vim-airline/vim-airline'
    "Plug 'vim-airline/vim-airline-themes'
    Plug 'airblade/vim-gitgutter'
    Plug 'vim-scripts/grep.vim'
    Plug 'vim-scripts/CSApprox'
    Plug 'bronson/vim-trailing-whitespace'
    Plug 'Raimondi/delimitMate'
    Plug 'majutsushi/tagbar'
    Plug 'scrooloose/syntastic'
    Plug 'Yggdroot/indentLine'
    Plug 'avelino/vim-bootstrap-updater'
    Plug 'sheerun/vim-polyglot'
    Plug 'altercation/vim-colors-solarized'
    Plug 'flazz/vim-colorschemes'
    Plug 'xolox/vim-colorscheme-switcher'
    Plug 'yuttie/comfortable-motion.vim'
    Plug 'davidhalter/jedi-vim'

    " {{{ Plug Configuration
    "if isdirectory('/usr/local/opt/fzf')
      "Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
    "else
      "Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
      "Plug 'junegunn/fzf.vim'
    "endif
    "let g:make = 'gmake'
    "if exists('make')
            "let g:make = 'make'
    "endif
    "Plug 'Shougo/vimproc.vim', {'do': g:make}

    "" Vim-Session
    "Plug 'xolox/vim-misc'
    "Plug 'xolox/vim-session'

    "if v:version >= 703
      "Plug 'Shougo/vimshell.vim'
    "endif

    "if v:version >= 704
      "" Snippets
      "Plug 'SirVer/ultisnips'
    "endif

    "Plug 'honza/vim-snippets'

    "" Color
    "Plug 'tomasr/molokai'

    " }}}

    call plug#end()

    " Required:
    filetype plugin indent on

    " }}}

" }}}

" {{{  Visual Settings

    syntax on
    set ruler
    set number

    let no_buffers_menu=1
    if !exists('g:not_finish_vimplug')

" {{{ Colorschemes

    "colorscheme SolarizedDark
    "colorscheme solarized
    "colorscheme 0x7A69_dark
    "colorscheme 256-grayvim
    "colorscheme 256-jungle
    "colorscheme 256_noir
    "colorscheme Benokai
    "colorscheme CodeFactoryv3
    "colorscheme Dev_Delight
    "colorscheme Monokai
    "colorscheme MountainDew
    "colorscheme OceanicNext
    "colorscheme PaperColor
    "colorscheme Revolution
    "colorscheme SlateDark
    "colorscheme Spink
    "colorscheme Tomorrow-Night-Blue
    "colorscheme Tomorrow-Night-Bright
    "colorscheme Tomorrow-Night-Eighties
    "colorscheme Tomorrow-Night
    "colorscheme Tomorrow
    "colorscheme adobe
    "colorscheme alduin
    "colorscheme anotherdark
    "colorscheme atom
    "colorscheme blackboard
    "colorscheme breeze
    "colorscheme brogrammer
    "colorscheme bubblegum-256-dark
    "colorscheme clearance
    "colorscheme cobalt
    "colorscheme cobalt2
    "colorscheme coda
    "colorscheme codeschool
    "colorscheme colorsbox-material
    "colorscheme dark-ruby
    "colorscheme darkZ
    "colorscheme dusk
    "colorscheme flatland
    "colorscheme flattended_dark
    "colorscheme flattr
    "colorscheme flatui
    "colorscheme impact
    "colorscheme itg_flat
    "colorscheme lucid
    "colorscheme material-theme
    "colorscheme material
    "colorscheme materialbox
    "colorscheme materialtheme
    "colorscheme mellow
    "colorscheme midnight
    "colorscheme midnight2
    "colorscheme molokai
    "colorscheme zen
    "colorscheme wombat
    "colorscheme wombat256
    "colorscheme wombat256i
    "colorscheme wombat256mod
    "colorscheme visualstudio
    "colorscheme termschool
    "colorscheme tango
    "colorscheme tango2
    "colorscheme tangox
    "colorscheme spacegray
    "colorscheme soda

" }}}

endif

"set mousemodel=popup
"set t_Co=256
"set guioptions=egmrti
"set gfn=Monospace\ 10

"" Disable the blinking cursor.
"set gcr=a:blinkon0
"set scrolloff=3

"" Status bar
"set laststatus=2

"" Use modeline overrides
"set modeline
"set modelines=10
