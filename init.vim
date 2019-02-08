set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin(expand('~/.config/nvim/plugged'))

Plug 'scrooloose/nerdtree'
Plug 'iCyMind/NeoSolarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
if isdirectory('/usr/local/opt/fzf')
      Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
  else
        Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
        Plug 'junegunn/fzf.vim'
      endif
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'zchee/deoplete-jedi'
Plug 'scrooloose/syntastic' " replace with ale
Plug 'tpope/vim-fugitive'
Plug 'mattn/emmet-vim'

Plug 'ntpeters/vim-better-whitespace'
Plug 'Yggdroot/indentLine'

call plug#end()

let g:python_host_prog = '/Users/pbandurski/.pyenv/versions/2.7.12/bin/python2'
let g:python3_host_prog = '/Users/pbandurski/.pyenv/versions/3.6.5/bin/python3'

map <F2> :NERDTreeToggle<CR>

syntax enable
set termguicolors
set background=dark
colorscheme NeoSolarized
"Invisible character colors
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
let g:NERDTreeShowBookmarks=1

set number
set ruler
set wildchar=<Tab> wildmenu wildmode=full

set tabstop=4        " Sets the tab size to 4
                     " (tabs are usually 8 spaces)
set expandtab        " Tab key inserts spaces instead of tabs
set shiftwidth=4     " Sets spaces used for (auto)indent
set shiftround       " Indent to nearest tabstop
set autoindent       " Carries over previous indent to the next line
set smarttab

set autoread
set cmdheight=2
set hlsearch
set incsearch
set showmatch

"" Directories for swp files
set nobackup
set noswapfile

"show eol and tab
set list listchars=tab:>\ ,trail:-,eol:¬

let g:indentLine_char = '¦'
let g:better_whitespace_enabled=0
let g:strip_whitespace_on_save=1

" Map leader to ,
let mapleader=','

inoremap <C-Space> <C-n>
inoremap <C-S-Space> <C-p>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" fzf remaps
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>e :FZF -m<CR>

"vim-airline
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'
let g:airline#extensions#virtualenv#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#branch#enabled = 1

" fzf.vim
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"


"deoplete.vim
let g:deoplete#enable_at_startup = 1
" close preview window on leaving the insert mode
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" syntastic
 let g:syntastic_always_populate_loc_list=1
 let g:syntastic_error_symbol='✗'
 let g:syntastic_warning_symbol='⚠'
 let g:syntastic_style_error_symbol = '✗'
 let g:syntastic_style_warning_symbol = '⚠'
 let g:syntastic_auto_loc_list=1
 let g:syntastic_aggregate_errors = 1
 let g:syntastic_python_checkers=['python', 'pylint']

" kite
let g:kite_tab_complete=1
set statusline=%<%f\ %h%m%r%{kite#statusline()}%=%-14.(%l,%c%V%)\ %P
set laststatus=2  " always display the status line<Paste>

 " emmet
 "let g:user_emmet_leader_key='<C-Z>'
 "
