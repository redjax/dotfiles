" vim-python
augroup vimrc-python
autocmd!
autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8 colorcolumn=79
  \ formatoptions+=croq softtabstop=4
  \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
augroup END

" PEP8 Indentation
au BufNewFile,BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

" Match and remove extra white space
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

"Syntastic/vim-flake8 Syntax Settings
let python_highlight_all=1
syntax on

" Show matching parentheses/brackets/braces (may be redundant)
set showmatch

