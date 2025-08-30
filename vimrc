 " Disable compatibility with vi which can cause unexpected issues
set nocompatible

" Disable swap files
set noswapfile

" Change Leader to ,
let mapleader = ","

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

" Set the leader key to a comma.
let mapleader = ","


" Do not save backup files.
set nobackup

" Cursor line
:autocmd InsertEnter,InsertLeave * set cul!

" Vim commentary for cpp file
:autocmd FileType cpp setlocal commentstring=//\ %s
:autocmd FileType hpp setlocal commentstring=//\ %s

"Show buffer in airline
set showtabline=2

"Shift arrow remappings
set keymodel=startsel

" Sort imports for python (only if Python3 support is available)
if has('python3')
  let g:vim_isort_python_version = 'python3'
  let g:vim_isort_map = '<C-i>'
endif

" Map scroll commands
nnoremap <c-b> <c-u>
nnoremap <c-f> <c-d>

" Simple window navigation (without tmux integration)
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

set noshowmode
" Smart indent
set smartindent

" Key remappings
command WQ wq
command Wq wq
command W w
command Q q
command Nt NERDTreeToggle
nnoremap gr gT
if has('python3')
  nnoremap <C-A-o> :Isort<CR>
else
  " Alternative: Manual import sorting command for Python files
  nnoremap <C-A-o> :call SortPythonImports()<CR>
endif

" Foldable setup (simplified for Vim)
set foldmethod=indent
set nofoldenable                     " Disable folding at startup.

" Ignore capital letters during search.
set ignorecase

" PEP8 ruler
set colorcolumn=80

" UTF-8 Support
set encoding=utf-8

" Set the line number
set number
if exists("+relativenumber")
  set relativenumber
endif

" Use system clipboard (if available)
if has('clipboard')
  set clipboard=unnamed
  if has('unnamedplus')
    set clipboard+=unnamedplus
  endif
endif

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')


" Custom functions
" diff two files in new vertical split
function! DiffClipboard()
  let ft=&ft
  vertical new
  setlocal bufhidden=wipe buftype=nofile nobuflisted noswapfile
  :1put
  silent 0d_
  diffthis
  setlocal nomodifiable
  execute "set ft=" . ft
  wincmd p
  diffthis
endfunction
command! DiffClipboard call DiffClipboard()

" Simple Python import sorting function (fallback when vim-isort not available)
function! SortPythonImports()
  if &filetype !=# 'python'
    echo "Not a Python file"
    return
  endif
  " Find import section
  let import_start = search('^import\|^from', 'nw')
  if import_start == 0
    echo "No imports found"
    return
  endif

  " Find end of imports
  let save_cursor = getpos('.')
  call cursor(import_start, 1)
  let import_end = import_start
  while getline(import_end + 1) =~ '^\(import\|from\|\s*$\|#\)'
    let import_end += 1
  endwhile

  " Sort the import lines
  execute import_start . ',' . import_end . 'sort'
  call setpos('.', save_cursor)
  echo "Python imports sorted"
endfunction

" Vimtex setup
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

" FZF setup
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" FZF key bindings - add Ctrl-C and Ctrl-G as quit keys
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-c': 'exit',
  \ 'ctrl-g': 'exit' }

" Reduce ESC timeout for faster FZF exit
set timeoutlen=1000
set ttimeoutlen=0

nnoremap <c-P> :Files<CR>
nnoremap <c-s-B> :Buffers<CR>
nnoremap <c-f> :Rg<CR>
nnoremap <C-A-f> :Ag<CR>

Plug 'catppuccin/vim', { 'as': 'catppuccin' }

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'
Plug 'Yggdroot/indentLine'
Plug 'christoomey/vim-tmux-navigator'
Plug 'embark-theme/vim', { 'as': 'embark', 'branch': 'main' }
Plug 'menisadi/kanagawa.vim'

call plug#end()

" NERDTree configuration
nnoremap <C-n> :NERDTreeToggle<CR>
" Close vim if NERDTree is the only window remaining
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif



" IndentLine configuration
let g:indentLine_enabled = 1
let g:indentLine_char = '│'


" Clear search highlighting
nnoremap <Leader>l :noh<CR>

" Window resizing
nnoremap <A-h> :vertical resize -3<CR>
nnoremap <A-j> :resize -3<CR>
nnoremap <A-k> :resize +3<CR>
nnoremap <A-l> :vertical resize +3<CR>

" Better split navigation
set splitbelow
set splitright

if !exists('g:loaded_airline')
  set laststatus=2
  set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
endif

" Cursor shape configuration
let &t_SI = "\e[6 q"    " Use thin cursor in insert mode
let &t_EI = "\e[2 q"    " Use block cursor in normal mode
let &t_SR = "\e[4 q"    " Use underline cursor in replace mode

" Color scheme
set termguicolors
let g:airline_theme = "onedark"
colorscheme kanagawa
