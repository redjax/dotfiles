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

" Include user's extra bundle(s)
if filereadable(expand('~/.config/nvim/local_bundles.vim'))
    source ~/.config/nvim/local_bundles.vim
endif

" End Vim plug
call plug#end()
