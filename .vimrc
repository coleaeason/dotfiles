syntax on
set hlsearch
set autoindent
set expandtab
set shiftwidth=4
set smarttab
set tabstop=4
set smartcase
set ignorecase
set linebreak
set wrap
set cursorline
set number
set backspace=indent,eol,start
set paste

if has("autocmd")
    " If the filetype is Makefile then we need to use tabs
    " So do not expand tabs into space.
    autocmd FileType make   set noexpandtab
endif
