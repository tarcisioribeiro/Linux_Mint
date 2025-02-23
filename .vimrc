if v:version < 802
    packadd! dracula
endif

colorscheme dracula

syntax enable
set number
set cursorline
set hlsearch
set ruler
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set wrap
set t_Co=256
set undofile
set undodir=~/.vim/undo
set completeopt=menuone,noinsert,noselect
set list
set listchars=tab:»·,trail:·,eol:¬
set scrolloff=8
set incsearch
set termguicolors
