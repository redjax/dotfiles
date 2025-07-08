"

" Source conf/loadfirst.vim
if filereadable(expand('~/.config/nvim/conf/loadfirst.vim'))
  source ~/.config/nvim/conf/loadfirst.vim
end

" Source Vimplug (plugin manager) conf
if filereadable(expand('~/.config/nvim/conf/vimplug/vimplug-core.vim'))
  source ~/.config/nvim/conf/vimplug/vimplug-core.vim
end

" Source Vimplug - plugin installs
if filereadable(expand('~/.config/nvim/conf/vimplug/vimplug-installs.vim'))
  source ~/.config/nvim/conf/vimplug/vimplug-installs.vim
end

" Source plugin configurations
for plugin_settings in split(glob('~/.config/nvim/conf/plugin-settings/*.vim'), '\n')
    exe 'source' plugin_settings
endfor

" Source conf/environment.vim
if filereadable(expand('~/.config/nvim/conf/environment.vim'))
  source ~/.config/nvim/conf/environment.vim
end

" Source autocmd rules
if filereadable(expand('~/.config/nvim/conf/autocmd-rules.vim'))
  source ~/.config/nvim/conf/autocmd-rules.vim
end

" Source keymaps
if filereadable(expand('~/.config/nvim/conf/keymappings.vim'))
  source ~/.config/nvim/conf/keymappings.vim
end
