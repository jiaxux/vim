" Disable compatibility with vi which can cause unexpected issues
set nocompatible

" Disable swap files
set noswapfile

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
if has('terminal')
  tnoremap <Esc> <C-\><C-n>
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

" Speedup ctrlp
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/vendor/*,*/\.git/*

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
nnoremap <c-P> :Files<CR>
nnoremap <c-s-B> :Buffers<CR>
nnoremap <c-f> :Rg<CR>
nnoremap <C-A-f> :Ag<CR>

Plug 'joshdick/onedark.vim'

" Declare the list of plugins (Vim-compatible).
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
" Only install vim-isort if Python3 support is available
if has('python3')
  Plug 'fisadev/vim-isort'
endif
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'Yggdroot/indentLine'
Plug 'easymotion/vim-easymotion'

" Vim-specific alternatives to Neovim plugins
if !has('nvim')
  Plug 'ctrlpvim/ctrlp.vim'
  " Alternative to nvim-tmux-navigator for regular Vim
  Plug 'christoomey/vim-tmux-navigator'
endif

call plug#end()

" NERDTree configuration
nnoremap <C-n> :NERDTreeToggle<CR>
" Close vim if NERDTree is the only window remaining
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" EasyMotion configuration (flash.nvim alternative)
let g:EasyMotion_do_mapping = 0 " Disable default mappings
" Flash-like mappings for EasyMotion
nmap s <Plug>(easymotion-overwin-f2)
nmap S <Plug>(easymotion-overwin-t2)
" Jump to line
map <Leader><Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader><Leader>L <Plug>(easymotion-overwin-line)
" Jump to word
map  <Leader><Leader>w <Plug>(easymotion-bd-w)
nmap <Leader><Leader>w <Plug>(easymotion-overwin-w)
" Enhanced search
map  <Leader>/ <Plug>(easymotion-sn)
omap <Leader>/ <Plug>(easymotion-tn)
" map  n <Plug>(easymotion-next)
" map  N <Plug>(easymotion-prev)
" EasyMotion f and F integration
map f <Plug>(easymotion-fl)
map F <Plug>(easymotion-Fl)
map t <Plug>(easymotion-tl)
map T <Plug>(easymotion-Tl)
" Bidirectional f and F (search in both directions)
map <Leader>f <Plug>(easymotion-bd-f)
map <Leader>F <Plug>(easymotion-bd-F)
map <Leader>t <Plug>(easymotion-bd-t)
map <Leader>T <Plug>(easymotion-bd-T)
" Case insensitive and smart case
let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_smartsign_us = 1
" Enable prompt for single character search
let g:EasyMotion_enter_jump_first = 0
let g:EasyMotion_space_jump_first = 1

" CtrlP configuration (for non-Neovim)
if !has('nvim')
  let g:ctrlp_map = '<c-p>'
  let g:ctrlp_cmd = 'CtrlP'
  let g:ctrlp_working_path_mode = 'ra'
endif

" IndentLine configuration
let g:indentLine_enabled = 1
let g:indentLine_char = '│'


" Set colorscheme
colorscheme onedark

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

" Status line (if airline is not loaded)
if !exists('g:loaded_airline')
  set laststatus=2
  set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
endif
