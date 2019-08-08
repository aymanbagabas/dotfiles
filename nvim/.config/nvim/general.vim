" Base16 theme
if filereadable(expand("~/.vimrc_background"))
    let base16colorspace=256
    source ~/.vimrc_background
endif

" Basics
set nocompatible
set hidden
" set syntax=ON
syntax enable

set incsearch				" serach as characters are entered
set hlsearch				" enable search highlight
set ignorecase				" ignore search case
set smartcase				" smart search

" Encoding
set encoding=utf-8

" reasonable backups
set backup
set backupdir=/tmp,~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,
set backupskip=/tmp/*
set directory=/tmp,~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,
set writebackup

" Enable mouse
set mouse=a

set cursorline				" enable vertical cursor indicator
set updatetime=300			" quicker update time

" don't give |ins-completion-menu| messages.
" set shortmess+=c

set signcolumn=auto:1			" always show signcolumns

" set tab options to use 4 spaces instead of tabs
"set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set tabstop=4 softtabstop=0 noexpandtab shiftwidth=4 smarttab
"set shiftwidth=4 noexpandtab smarttab		" tab appear as 4 width with mixture of tabs and spaces
"let &softtabstop = &shiftwidth

" Shift to the next round tab stop.
set shiftround

" set nolist					" Don't show invisible characters
"set showbreak=↪\                       " Line breaks for wrap option
" set listchars+=tab:→\ ,nbsp:␣,trail:·,extends:⟩,precedes:⟨,eol:↵
set list lcs=tab:\│\ 		" show tab guidelines

set number					" ruler
set relativenumber			" relative number

set wildignore+=.git,.svn,CVS,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.pyc,tags,*.tags,node_modules
" set wildignore+=*/.git/*,*/tmp/*,*.swp

" right margin
"set textwidth=80
"let &colorcolumn='+'.join(range(1,256), ',+')
let &colorcolumn='81,'.join(range(120,256), ',') " highlight one column after textwidth and columns 120,256

" whichwrap
set whichwrap+=<,>,[,]		" allows cursor to move prev/next line

" complete options
set completeopt+=longest,menuone,noinsert,noselect

" backspace
set backspace+=indent,eol,start			" allow backspacing to join lines

" set autoindent smartindent 		" vim autoindent
filetype plugin indent on

" indent wrapped line
set breakindent

" spelling
set spell spelllang=en_us

" dict
set dictionary+=/usr/share/dict/words

" folding
"set foldmethod=marker
set foldenable					" enable folding
set foldmethod=syntax			" based on syntax
set foldlevelstart=10			" auto fold if level >= 10
set foldcolumn=0				" disable foldcolumn

" configuration group
augroup configgroup
	autocmd!
	autocmd InsertEnter * set norelativenumber number nocursorline
	autocmd InsertLeave,WinEnter,BufEnter * set relativenumber number cursorline
	" use NERDTRee when opening a dir
	autocmd StdinReadPre * let s:std_in=1
	autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") |
		\ exe 'NERDTree' argv()[0] | wincmd p | ene | endif
	" " close vim if NERDTRee is the only one open
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
	" use litecorrect with markdown
	autocmd FileType markdown,mkd call litecorrect#init()
	" strip whitespaces on save
	autocmd BufWritePre *.c,*.cpp,*.cc,*.h,*.py,*.md
		\ :StripWhitespace
	" jump to the last position
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
	" vimwiki conflicts with indentLine conceal level
	autocmd Filetype vimwiki,markdown let g:indentLine_setConceal = 0
	autocmd Filetype vimwiki,javascript,typescript set expandtab tabstop=2 shiftwidth=2
	autocmd Filetype qt setlocal nospell
	" auto close gitgutter preview window and update it when next line is a
	" hunk.
	" autocmd CursorMoved * if exists('g:__gitgutter_hunk_preview') && g:__gitgutter_hunk_preview |
      " \   if gitgutter#hunk#in_hunk(line('.')) |
	"   \     call gitgutter#hunk#preview() |
	"   \   else |
	"   \     silent! wincmd P |
	"   \     if &previewwindow | pclose | silent! wincmd p | endif |
	"   \     let g:__gitgutter_hunk_preview=0 |
      " \   endif |
      " \ endif
augroup END

" copy to clipboard
set clipboard+=unnamed

" diff mode settings
set diffopt+=foldcolumn:0

" netrw
" let g:netrw_banner = 0
" let g:netrw_liststyle = 3
" let g:netrw_browse_split = 4
" let g:netrw_altv = 1
" let g:netrw_winsize = 25
" let g:netrw_fastbrowse = 0
