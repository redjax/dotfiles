"" Plugin module
" List of plugins to install/update with :Plug<Install/Update>
" Comment a "Plug <>" line to stop loading of plugin

" {{{ Vim Plug settings

" {{{ Vim Plug Defaults
if has('vim_starting')
  set nocompatible               " Be iMproved
endif

let vimplug_exists=expand('~/.config/nvim/autoload/plug.vim')

let g:vim_bootstrap_langs = "python"
let g:vim_bootstrap_editor = "nvim"				" nvim or vim

if !filereadable(vimplug_exists)
  echo "Installing Vim-Plug..."
  echo ""
  silent !\curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif
" }}}

" Required:
call plug#begin('~/.config/nvim/plugged')
" expand('~/.config/nvim/plugged')


    " {{{ Plug installs
    Plug 'scrooloose/nerdtree'
    Plug 'junegunn/fzf'
    Plug 'nathanaelkane/vim-indent-guides'
    Plug 'scrooloose/syntastic'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'bronson/vim-trailing-whitespace'
    Plug 'Yggdroot/indentline'
    Plug 'sheerun/vim-polyglot'
    Plug 'altercation/vim-colors-solarized'
    Plug 'flazz/vim-colorschemes'
    Plug 'yuttie/comfortable-motion.vim'
    Plug 'vim-scripts/indentpython.vim'
    Plug 'honza/vim-snippets'
    " }}}

    " include user's extra bundle(s)
    if filereadable(expand('~/.config/nvim/local_bundles.vim'))
        source ~/.config/nvim/local_bundles.vim
    endif

call plug#end()
" }}}

"" Plugin configuration
" {{{ NERDTree
"
" Open NERDTree automatically if empty nvim window
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Close nvim if only open window left is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Keybind for opening NERDTree
map <C-b> :NERDTreeToggle<CR>
" }}}

" {{{ syntastic

    let g:syntastic_python_checkers=['python', 'flake8']

" }}}

" {{{ vim-airline

    let g:airline#extensions#virtualenv#enabled = 1

" }}}

" {{{ Comfortable-Motion (smooth/physics-based scrolling
    noremap <silent> <ScrollWheelDown> :call comfortable_motion#flick(40)<CR>
    noremap <silent> <ScrollWheelUp>   :call comfortable_motion#flick(-40)<CR>
" }}}

" {{{ vim-airline
    let g:airline_theme = 'powerlineish'
    let g:airline#extensions#syntastic#enabled = 1
    let g:airline#extensions#branch#enabled = 1
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tagbar#enabled = 1
    let g:airline_skip_empty_sections = 1
" }}}

" {{{ Deoplete
"let g:deoplete#enable_at_startup = 1
" }}}
