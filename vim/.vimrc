
" OS Specific {{{
    " Windows {{{
        if has('win32')
            set backupdir=$HOME/vimfiles/backup,.
            set directory=$HOME/vimfiles/temp//,.
            set undodir=$HOME/vimfiles/undo,.
            set runtimepath+=$HOME/vimfiles/bundle/vundle/
    " }}}

    " Linux {{{
        else
            set backupdir=~/.vim/backup,.
            set directory=~/.vim/temp//,.
            set undodir=~/.vim/undo,.
            set runtimepath+=~/.vim/bundle/vundle/
        endif
    " }}}
" }}}

" Defaults {{{
    set nocompatible              " be iMproved, required
    filetype off                  " required
    syntax on
    set encoding=utf8
    "set background=dark           " dark background
" }}}

" Editor Settings {{{
    " Set and Leave {{{
    " Folding
    set foldmethod=marker

    " Backspace over autoindent, line breaks, start of insert (see :help 'backspace')
    set backspace=indent,eol,start

    " Use mouse in terminal
    set mouse=a

    " Set to auto read when a file is changed from the outside
    set autoread

    " Autocomplete feature for command mode (i.e. :command)
    set wildmenu
    set wildmode=longest,list,full

    " Set line numbering on left
    set number

    " Set position indicator on bottom right
    set ruler

    " Highlight search results
    set hlsearch

    " Incrementally highlight first matching word as you type a search
    set incsearch

    " Show matching brackets when text indicator is over them
    set showmatch

    " Screw swap files. Cluttering up my files...
    set noswapfile
    
    " How many tenths of a second to blink when matching brackets
    set matchtime=1

    " When searching ignore case unless contains a capital
    " Override with \c/\C flag in regex -- /\cword
    set ignorecase
    set smartcase

    " 1 tab == 4 spaces
    set softtabstop=4
    set shiftwidth=4
    set tabstop=4

    " Use spaces instead of tabs
    set expandtab

    " Wrap lines when hit right side, doesn't affect buffer
    set nowrap

    " When wrapping, respect the indent of original line
    if exists('&breakindent')
      set breakindent
    endif

    " Makes smarter decisions about what stays on wrapped line
    set linebreak
    " }}}

    " VIM Window Size {{{
        " Set minimum screen size for GVim, on console just fill
        if has('gui_running')
          set lines=80 columns=140
        endif
    " }}}
" }}}

" Vundle {{{
    " Windows Vundle {{{
        if has('win32')
            " Vundle Default Settings/Plugins {{{
            "set the runtime path to include Vundle and initialize
            set rtp+=$HOME/vimfiles/bundle/Vundle.vim/
            call vundle#begin('$USERPROFILE/vimfiles/bundle/')
            "alternatively, pass a path where Vundle should install plugins
            "call vundle#begin('~/some/path/here')
        " }}}

    " }}}

    " Linux Vundle {{{
        elseif has('unix')
            set nocompatible
            " Defaults {{{
            "filetype off
            set rtp+=~/.vim/bundle/Vundle.vim
            call vundle#begin()
    " }}}
    endif

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
"Plugin 'ascenator/L9', {'name': 'newL9'}
" }}}

" My Plugins {{{

    " JediVIM
    Plugin 'davidhalter/jedi-vim'
    " Polyglot Language Packs
    Plugin 'sheerun/vim-polyglot'
    " NERDTree
    Plugin 'scrooloose/nerdtree'
    " Python specific settings
    Plugin 'klen/python-mode'
    " Autoload VIM Scripts
    Plugin 'xolox/vim-misc'
    " Airline & Themes
    Plugin 'vim-airline/vim-airline'
    Plugin 'vim-airline/vim-airline-themes'
    " Indentline
    Plugin 'Yggdroot/indentline'
    " Colorschemes & Switcher
    Plugin 'flazz/vim-colorschemes'
    Plugin 'xolox/vim-colorscheme-switcher'
    "Solarized Colorscheme
    Plugin 'altercation/vim-colors-solarized'

" }}}

call vundle#end()            " required
filetype plugin indent on    " required

" Put your non-Plugin stuff after this line
" }}}

" Plugin Settings {{{

    " NERDTree {{{

        " Open NERDTree Automatically if VIM opened empty
        autocmd StdinReadPre * let s:std_in=1
        autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

        "Open NERDTree with CTRL+N
        map <C-n> :NERDTreeToggle<CR>

        "Close VIM if NERDTree is only window left open
        autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
        
        " NERDTree can see hidden files
        let NERDTreeShowHidden=1

    " }}}

    " Airline Statusline {{{

        "Smarter Tabline
        let g:airline#extensions#tabline#enabled = 1
        " Fonts
        let g:airline_powerline_fonts = 1
        "Show Airline on Open
        set laststatus=2

    " Airline Themes {{{

        ":let g:airline_theme='base16_3024'
        ":let g:airline_theme='base16_codeschool'
        ":let g:airline_theme='base16_flat'
        ":let g:airline_theme='base16_embers'
        ":let g:airline_theme='base16_google'
        ":let g:airline_theme='base16_grayscale'
        ":let g:airline_theme='base16_solarized'
        ":let g:airline_theme='base16_tomorrow'
        ":let g:airline_theme='base16_twilight'
        ":let g:airline_theme='luna'
        ":let g:airline_theme='molokai'
        ":let g:airline_theme='monochrome'
        :let g:airline_theme='papercolor'
        ":let g:airline_theme='sol'
        ":let g:airline_theme='solarized'
        ":let g:airline_theme='term'
        ":let g:airline_theme='tomorrow'
        ":let g:airline_theme='wombat'

    " }}}

    " }}}

" }}}

" Colorschemes {{{

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
colorscheme SlateDark
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
"colorscheme flatlandia
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