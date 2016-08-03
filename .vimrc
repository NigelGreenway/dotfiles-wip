syntax on
set number
set nowrap
set tabstop=4
set expandtab
set autoindent
set noswapfile

set cursorline
hi CursorLine cterm=NONE ctermbg=black

set rtp+=~/.fzf

autocmd BufNewFile,BufRead *.json set ft=javascript
