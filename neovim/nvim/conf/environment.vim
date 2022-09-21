" Colorscheme

" To change your colorscheme, check that it exists in
" ~/.config/nvim/colors/<themename>.vim. Change the name in the filereadable()
" line below, then set colorscheme to the name of the color file, minus '.vim'
if filereadable(expand('~/.config/nvim/colors/hybrid.vim'))
  colorscheme hybrid
else
  set background=dark
endif
