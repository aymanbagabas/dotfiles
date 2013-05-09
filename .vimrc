" => General
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after "set path
set encoding=utf-8

set history=10000	" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

set nocompatible " Be IMproved
filetype off                   " required!

" => Vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

 " let Vundle manage Vundle
 " required! 
 Bundle 'gmarik/vundle'

 " My Bundles here:
 "
 " original repos on github
 Bundle 'tpope/vim-fugitive'
 Bundle 'Lokaltog/vim-easymotion'
 Bundle 'Lokaltog/vim-powerline'
 Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
 Bundle 'tpope/vim-rails.git'
 Bundle 'tpope/vim-pathogen'
 Bundle 'scrooloose/syntastic'
 Bundle 'scrooloose/nerdtree'
 Bundle 'altercation/vim-colors-solarized'
 "Bundle 'jistr/vim-nerdtree-tabs'
 Bundle 'techlivezheng/vim-plugin-minibufexpl'
 Bundle 'sollidsnake/vterm'
 " vim-scripts repos
 Bundle 'L9'
 Bundle 'FuzzyFinder'
 Bundle 'lua.vim'
 " non github repos
 Bundle 'git://git.wincent.com/command-t.git'
 " ...

 filetype plugin indent on     " required!
 "
 " Brief help
 " :BundleList          - list configured bundles
 " :BundleInstall(!)    - install(update) bundles
 " :BundleSearch(!) foo - search(or refresh cache first) for foo
 " :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
 "
 " see :h vundle for more details or wiki for FAQ
 " NOTE: comments after Bundle command are not allowed..

" => Keys
map Q gq " Don't use Ex mode, use Q for formatting
" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>
" Fix keycodes
map ^[[7~ <Home>
map ^[[8~ <End>
imap ^[[7~ <Home>
imap ^[[8~ <End>

nmap <C-V> "+gP
imap <C-V> <ESC><C-V>i
vmap <C-C> "+y
vmap <C-V> p

map <C-n> :NERDTreeToggle<CR>
map <C-t> :TMiniBufExplorer<CR>  

" => Interface

set t_Co=256 " Explicitly tell Vim that the terminal supports 256 colors

set laststatus=2

syntax enable
set background=dark
if has("gui_running")
    set background=light
endif
colorscheme solarized

set colorcolumn=80
set number
set splitright

" line hightlight
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END
" Tabs
set autoindent " copy indent from previous line
set expandtab " replace tabs with spaces
set shiftwidth=2 " spaces for autoindenting
set smarttab " <BS> removes shiftwidth worth of spaces
set softtabstop=2 " spaces for editing, e.g. <Tab> or <BS>
set tabstop=2 " spaces for <Tab>
" Searche
set ignorecase " Ignore case when searching
set smartcase " When searching try to be smart about cases 
set hlsearch " Highlight search results
set incsearch " Makes search act like search in modern browsers

if v:progname =~? "evim" " When started as "evim", evim.vim will already have done these settings.
  finish
endif

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif

if has('mouse') " In many terminal emulators the mouse works just fine, thus enable it.
  set mouse=a
endif

if &t_Co > 2 || has("gui_running") " Switch syntax highlighting on, when the terminal has colors
  syntax on                        " Also switch on highlighting the last used search pattern.
  set hlsearch
endif

if has("autocmd") " Only do this part when compiled with support for autocommands.

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" => autocmd
autocmd vimenter * if !argc() | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview 

" => Plugins settings
let g:Powerline_symbols = 'fancy'
let g:Powerline_colorscheme = 'solarized256'
call pathogen#infect()
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
let g:miniBufExplUseSingleClick = 1
let NERDTreeChDirMode=2
let NERDTreeQuitOnOpen=1
