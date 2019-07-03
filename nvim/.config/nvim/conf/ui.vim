"" General Editor Settings
" UI options
set laststatus=2 " always display status bar
set ruler " always show cursor position
set wildmenu " display cli tab complete options as menu
set cursorline " highlight line under cursor
set noerrorbells " disable error beeps
set mouse=a " enable mouse for scrolling/resizing
set title " change window title to current file being edited
set background=dark

syntax on
set ruler

" {{{ Visual settings
let no_buffers_menu=1
if !exists('g:not_finish_vimplug')

    " allows cursor change in tmux mode
    if exists('$TMUX')
        let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
        let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
    else
        let &t_SI = "\<Esc>]50;CursorShape=1\x7"
        let &t_EI = "\<Esc>]50;CursorShape=0\x7"
    endif
endif
" }}}
