set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin(expand('~/.config/nvim/plugged'))

Plug 'scrooloose/nerdtree'
Plug 'iCyMind/NeoSolarized'
Plug 'arcticicestudio/nord-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
if isdirectory('/usr/local/opt/fzf')
  Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
else
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
endif
Plug 'derekwyatt/vim-scala'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neomake/neomake'
Plug 'tpope/vim-commentary'
"Plug 'scrooloose/syntastic' " replace with ale
Plug 'tpope/vim-fugitive'
Plug 'jiangmiao/auto-pairs'

Plug 'ntpeters/vim-better-whitespace'
Plug 'Yggdroot/indentLine'

call plug#end()

let g:python_host_prog = '/usr/local/bin/python2'
let g:python3_host_prog = '/usr/local/bin/python3'

map <F2> :NERDTreeToggle<CR>

syntax enable
set termguicolors
colorscheme nord
"Invisible character colors
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
let g:NERDTreeShowBookmarks=1

set number
set ruler
set wildchar=<Tab> wildmenu wildmode=full

set tabstop=2        " Sets the tab size to 4
                     " (tabs are usually 8 spaces)
set expandtab        " Tab key inserts spaces instead of tabs
set shiftwidth=2     " Sets spaces used for (auto)indent
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

set autowrite

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
nnoremap <silent> <leader>t :Tags<CR>

"commentary
map <C-/> :Commentary<CR>

"vim-airline
let g:airline_theme='nord'
let g:airline#extensions#virtualenv#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#neomake#enabled = 1

" fzf.vim
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__,node_modules
let g:fzf_tags_command = 'ctags -R --exclude=@.gitignore'
let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'project/target/**' -prune -o -path 'target/**' -prune -o -path 'project/project/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"

command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

" close preview window on leaving the insert mode
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
" vim-scala
au BufRead,BufNewFile *.sbt set filetype=scala

" coc config
source ~/.coc-mappings.vim

" function! CocExtensionStatus() abort
"   return get(g:, 'coc_status', '')
" endfunction
" let g:airline_section_c = '%f%{CocExtensionStatus()}'

" neomake
"Linting with neomake
" call neomake#configure#automake('nw', 750)

let g:neomake_sbt_maker = {
      \ 'exe': 'sbt',
      \ 'args': ['-Dsbt.log.noformat=true', 'compile'],
      \ 'append_file': 0,
      \ 'auto_enabled': 1,
      \ 'output_stream': 'stdout',
      \ 'errorformat':
          \ '%E[%trror]\ %f:%l:\ %m,' .
            \ '%-Z[error]\ %p^,' .
            \ '%-C%.%#,' .
            \ '%-G%.%#'
     \ }
let g:neomake_enabled_makers = ['sbt']
let g:neomake_verbose=3
" Neomake on text change
"autocmd InsertLeave,TextChanged *.scala update | Neomake! sbt

let g:neomake_serialize = 1
let g:neomake_serialize_abort_on_error = 1
let g:neomake_open_list = 2

let g:neomake_warning_sign = {
  \ 'text': 'W',
  \ 'texthl': 'WarningMsg',
  \ }
let g:neomake_error_sign = {
  \ 'text': 'E',
  \ 'texthl': 'ErrorMsg',
  \ }
