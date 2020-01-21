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

" Quick Hits
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
  "}}}

  " code folding
  set foldmethod=marker

  " filetype inedentation
  filetype plugin indent on
  " syntax
  syntax on
  syntax enable

  " colorscheme {{{
   
    " make background dark/light
    set background=dark

    " Uncomment a theme below to set
      " colorscheme challenger_deep
      " colorscheme minimalist
      colorscheme hybrid
  "}}}
  
  " True Color support if available
  if has("termguicolors")
    set termguicolors
  endif

  " line numbers
  set number
  " numbers scroll around current line
  " set relativenumber

  " open invisible buffer on start
  set hidden
  " mouse support
  set mouse=a
  " Do not show -- INSERTION -- in command line
  set noshowmode
  set noshowmatch
  set nolazyredraw

  " Turn off backup
  set nobackup
  set noswapfile
  set nowritebackup

  " Improve searching within file
  set ignorecase
  set smartcase

  " Tab and indent configuration
  set expandtab
  set tabstop=4
  set shiftwidth=4

  " vim-autoformat
  noremap <F3> :Autoformat<CR>
  
"}}}

" Vim plug {{{
call plug#begin(g:plugged_home)

" Plugin installs/activations
  
  " UI {{{
    
    " Airline
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    
    " Awesome vim colorschemes
    Plug 'rafi/awesome-vim-colorschemes'
    " vim-themes
    Plug 'mswift42/vim-themes'
    " Highlight yank (copy) area
    Plug 'machakann/vim-highlightedyank'
    " Code folding
    Plug 'tmhedberg/SimpylFold'
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
    " nerdtree for file-browsing
    Plug 'scrooloose/nerdtree'
    " Formatter
    Plug 'Chiel92/vim-autoformat'
  "}}}

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
  
"}}}

" Other {{{

  " pylint
    
    " when to activate neomake
    call neomake#configure#automake('nrw', 50)
    " Enable pylint in neovim
    let g:neomake_python_enabled_makers = ['flake8', 'pylint']
    
"}}}
