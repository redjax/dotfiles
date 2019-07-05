" path to config folder
let nvimconf='~/.config/nvim/conf'
" system details
let uname=system("uname -s")

" loop over conf path and source each .vim file
for fpath in split(globpath(nvimconf, '\*.vim'), '\n')
    exe 'source' fpath
endfor

