" init.vim contents
"   tip: use search (:/%s) to jump to sections quickly
"
" 1. Neovim environment
"    sections:
"     environment detection
"     colorscheme
" 2. Vim plug
"    sections:
"      plug installs/activations
"        UI
"        Code completion & syntax
" 3. Plugin settings
" 4. Other
" -------------------------------------------------------------------------
" Quick Hints
"   Search and replace:
"     :%s/orig/replace/g (or /gc for confirmation)
"     :%s/\<orig\>/replace/g - replace only exact matches
"     :%s/orig/replace/[iI] - case insensitive (i) or case sensitive (I)
"     NOTE: You must escape characters like symbols, i.e. \.
"   Code folding:
"     <zo> or right-arrow to open fold
"     <zc> to close fold
"   Go to top/go to bottom:
"     <gg> to go to top
"     <G> to go to bottom
"   Scroll lines:
"     <C-u>/<C-d> to scroll screen by half increments
"     <C-f>/<C-b> to scroll full screen
"     <z-Return> to scroll current line to top
"    <[line-number]z-Return> to goto line
"      OR
"    [line-number]G to goto line
"  Cursor control:
"    <H> to move cursor to top line of screen
"    <H> to move cursor to middle of screen
"    <L> to move cursor to last line of screen
"  Word movement:
"    <e> to move to end of next word
"    <b> to move backwards a word
"    <w> to move forward a word, leave cursor at start
"  Text block movement:
"    ( and ) to move forward/backward a sentence
"    { and } to navigate paragraphs
"    % to move to next/previous related item (i.e. brackets, comments, etc)
"
" -------------------------------------------------------------------------
"
" Begin init.vim
"

" Neovim Environment {{{

  " environment detection {{{
  if has('win32') || has('win64')
    let g:plugged_home = '~/AppData/Local/nvim/plugged'
  else
    let g:plugged_home = '~/.local/share/nvim/plugged'
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
      
  "}}}

  " code folding
  set foldmethod=marker

  " filetype inedentation
  filetype plugin indent on
  " syntax
  syntax on
  syntax enable
  set ruler

  " colorscheme {{{
   
    " make background dark/light
    set background=dark

    " Uncomment a theme below to set
      " colorscheme challenger_deep
      " colorscheme minimalist
      colorscheme hybrid
  "}}}
  
  " change window title to current file being edited
  set title
  " disable error beeps
  set noerrorbells
  " display cli tab complete options as menu
  set wildmenu
  
  " True Color support if available
  if has("termguicolors")
    set termguicolors
  endif
  
  " text rendering options
  set encoding=utf-8
  set fileencoding=utf-8
  set linebreak " avoid wrapping line in middle of a word
  set wrap " enable line wrapping

  " line numbers
  set number
  " numbers scroll around current line
  " set relativenumber

  " open invisible buffer on start
  set hidden
  " show the last command
  set showcmd
  " mouse support
  set mouse=a
  " Do not show -- INSERTION -- in command line
  set noshowmode
  set noshowmatch
  set lazyredraw

  " Improve searching within file
  set ignorecase
  set smartcase
  set hlsearch " search highlighting
  set incsearch " incremental search/partial matches

  " Tab and indent configuration
  set expandtab
  set tabstop=4
  set shiftwidth=4
  set shiftround " round indentation to nearest multiple of shiftwidth
  set smarttab " insert tabstop number of spaces when tab is pressed

  " Performance options
    set complete-=i " limit files searched for autocomplete
    " Turn off backup
    set nobackup
    set noswapfile
    set nowritebackup 
  
  " vim-autoformat
  noremap <F3> :Autoformat<CR>
 
  " Misc
  set autoread " automatically re-read if unmodified version is open in nvim
  set backspace=indent,eol,start " allow backspacing over indents, line breaks, inserts
  set confirm " prompt when closing without saving
  set history=1000 " increase undo limit
  set wildignore+=.pyc,.swp " ignored file extensions
  set bomb " editing between Windows & Linux
  let mapleader=',' " not sure what this does

  " Tries to set shell from env, defaults to bash
  if exists('$SHELL')
    set shell=$SHELL
  else
    set shell=/bin/sh
  endif

  " session management
  " let g:session_directory = "~/.config/nvim/session"  

"}}}

" Vim plug {{{

" Vim PlugDefaults {{{
    if has('vim_starting') 
        set nocompatible " Be iMproved
    endif

    let vimplug_exists=expand('~/.config/nvim/autoload/plug.vim')

    let g:vim_bootstrap_langs = "python"
    let g:vim_bootstrap_editor = "nvim"

    " Install vim-plug if it's not already installed {{{
    if !filereadable(vimplug_exists)
        echo "Installing Vim Plug..."
        echo ""
        silent !\curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        let g:not_finish_vimplug = "yes"

        autocmd VimEnter * PlugInstall
    endif
    "}}}
    
" }}}

call plug#begin(g:plugged_home)

" Plugin installs/activations {{{

  " UI {{{
    
    " Airline
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    
    " Smooth scrolling motion
    Plug 'yuttie/comfortable-motion.vim' 
    " Awesome vim colorschemes
    Plug 'rafi/awesome-vim-colorschemes'
    " Vim colorpack
    Plug 'flazz/vim-colorschemes' 
    " vim-themes
    Plug 'mswift42/vim-themes'
    " Highlight yank (copy) area
    Plug 'machakann/vim-highlightedyank'
    " Code folding
    Plug 'tmhedberg/SimpylFold'
  "}}}
  
"}}}

  " Code completion & syntax {{{
    
    " jedi-vim
    Plug 'davidhalter/jedi-vim'
    " deoplete
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    " deoplete-jedi
    Plug 'zchee/deoplete-jedi'
    " autopairs for quote/bracket completion
    Plug 'jiangmiao/auto-pairs'
    " auto-format for code formatting
    Plug 'sbdchd/neoformat'
    " neomake, mostly for linting with pylint
    Plug 'neomake/neomake'
    " display indents with thin lines
    Plug 'Yggdroot/indentline'
    " Collectionof language packs for (n)vim
    Plug 'sheerun/vim-polyglot'
    " nerdtree for file-browsing
    Plug 'scrooloose/nerdtree'
    " Formatter
    Plug 'Chiel92/vim-autoformat'
    " Syntax checker/linter
    Plug 'scrooloose/syntastic'
    " Auto-indent rules for Python
    Plug 'vim-scripts/indentpython.vim'
    " Highlight whitespace with red, fix with :FixWhitespace
    " Plug 'bronson/vim-trailing-whitespace'

  "}}}

" Include user's extra bundle(s)
if filereadable(expand('~/.config/nvim/local_bundles.vim'))
    source ~/.config/nvim/local_bundles.vim
endif

" End Vim plug
call plug#end()

"}}}

" Plugin settings {{{

" airline {{{
  " conf
    let g:airline_powerline_fonts=1
    
    if !exists('g:airline_symbols')
      let g:airline_symbols={}
    endif

    let g:airline_symbols.space="\ua0"
    let g:airline#extensions#tabline#enabled=1
    let g:airline#extensions#tabline#show_buffers=0
    let g:airline#extensions#hunks#enabled=0
    let g:airline#extensions#branch#enabled=1
    let g:powerline_pycmd="py3"
    let g:airline_skip_empty_sections = 1
    let g:airline#extensions#tagbar#enabled = 1
    let g:airline#extensions#syntastic#enabled = 1

  " airline theme {{{
    " let g:airline_theme='dark'
    " let g:airline_theme='hybridline'
    " let g:airline_theme='bubblegum'
    " let g:airline_theme='badwolf'
    " let g:airline_theme='badwolf'
    let g:airline_theme='angr'
    
  "}}}

"}}}

" deoplete {{{

    let g:deoplete#enable_at_startup = 1
    " deoplete: set preview completion window to auto-close
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
    " deopelete: tab navigation
    inoremap <expr><tab> pumvisible() ?"\<c-n>" : "\<tab>"
  "}}}
  
  " neoformat {{{
  
    " neoformat: enable-alignment
    let g:neoformat_basic_format_align = 1
    " neoformat: tab to spaces conversion
    let g:neoformat_basic_format_retab = 1
    " neoformat: trim trailing whitespace
    let g:neoformat_basic_format_trim = 1
  "}}}
  
  " jedi {{{
    
    " jedi: disable autocompletion, which we use deoplete for
    let g:jedi#completions_enabled = 0
    " jedi: open go-to function in split, not another buffer
    let g:jedi#use_splits_not_buffers = "right"
  "}}}
  
  " nerdtree {{{

    " nerdtree: open/close with C-k, C-B
    nnoremap <silent> <C-k><C-B> :NerdTreeToggle<CR>
    " nerdtree: ignore files
    let NERDTreeIgnore = ['\.pyc$', '^__pycache__$']
  "}}}
  
  " highlightedyank/highlightyank {{{
  
    " fix colorscheme issues
    hi HighlightedyankRegion cterm=reverse gui=reverse
    " highlight duration, measured in ms
    let g:highlightedyank_highlight_duration = 1000
  "}}}
 
    " syntastic {{{
        set statusline+=%#warningmsg#
        set statusline+=%{SyntasticStatuslineFlag()}
        set statusline+=%*
        
        let g:syntastic_python_checkers = ['python', 'flake8']
        let g:syntastic_always_populate_loc_list = 1
        let g:syntastic_auto_loc_list = 1
        let g:syntastic_check_on_open = 1
        let g:syntastic_check_on_wq = 0
    "}}}

    " comfortable-motion {{{
        noremap <silent> <ScrollWheelDown> :call comfortable_motion#flick(40)<CR>
        noremap <silent> <ScrollWheelUp> :call comfortable_motion#flick(-40)<CR>
    "}}}
    
"}}}

" Other {{{

  " pylint
    
    " when to activate neomake
    call neomake#configure#automake('nrw', 50)
    " Enable pylint in neovim
    let g:neomake_python_enabled_makers = ['flake8', 'pylint']
    
"}}}

" AutoCMD Rules {{{

    " This PC is fast enough, do syntax highlight synching from start, unless 200 lines
    augroup vimrc-sync-fromstart
        autocmd!
        autocmd BufEnter * :syntax sync maxlines=200
    augroup END

    " Remember cursor position
    augroup vimrc-remember-cursor-position
        autocmd!
        autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    augroup END

    " txt
    augroup vimrc-wrapping
        autocmd!
        autocmd BufRead,BufNewFile *.txt call s:setupWrapping()
    augroup END

    " make/cmake
    augroup vimrc-make-cmake
        autocmd!
        autocmd FileType make setlocal noexpandtab
        autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
    augroup END
"}}}

" Mappings {{{
    " Split
    noremap <Leader>h :<C-u>split<CR>
    noremap <Leader>v :<C-u>vsplit<CR>

    " Session management
    nnoremap <leader>so :OpenSession<Space>
    nnoremap <leader>ss :SaveSession<Space>
    nnoremap <leader>sd :DeleteSession<CR>
    nnoremap <leader>sc :CloseSession<CR>

"}}}

