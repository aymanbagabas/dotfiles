" Basics
set nocompatible
set hidden
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

set signcolumn=auto:2			" always show signcolumns

" disable auto file cd
set noautochdir

" set tab options to use 4 spaces instead of tabs
"set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
" Shift to the next round tab stop.
set shiftround
"set shiftwidth=4 noexpandtab smarttab		" tab appear as 4 width with mixture of tabs and spaces
"let &softtabstop = &shiftwidth

" set nolist					" Don't show invisible characters
"set showbreak=↪\                       " Line breaks for wrap option
" set listchars+=tab:→\ ,nbsp:␣,trail:·,extends:⟩,precedes:⟨,eol:↵
" show invisible chars
set list
" show tab guidelines
set list listchars=tab:\│\ 	" note the space

set number					" ruler
set relativenumber			" relative number

set wildignore+=.git,.svn,CVS,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.pyc,tags,*.tags,node_modules
" set wildignore+=*/.git/*,*/tmp/*,*.swp

" right margin
"set textwidth=80
"let &colorcolumn='+'.join(range(1,256), ',+')
" let &colorcolumn='81,'.join(range(120,256), ',') " highlight one column after textwidth and columns 120,256
set colorcolumn=81

" whichwrap
set whichwrap+=<,>,[,]		" allows cursor to move prev/next line

" complete options
set completeopt+=menuone,noinsert

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

" thesaurus
set thesaurus+=$HOME/.local/nvim/thesaurus/words.txt

" folding
"set foldmethod=marker
set foldenable					" enable folding
set foldmethod=syntax			" based on syntax
set foldlevelstart=10			" auto fold if level >= 10
set foldcolumn=0				" disable foldcolumn

" sane spliting
" set splitbelow
set splitright

" menu on command mode
set wildmenu

command! -nargs=? Explorer :CocCommand explorer
	    \ --toggle
	    \ --sources=file+
	    \ <args>

" configuration group
augroup configgroup
    autocmd!
    autocmd InsertEnter * set norelativenumber nocursorline
    autocmd InsertLeave * set relativenumber cursorline
    " use NERDTRee when opening a dir
    " autocmd StdinReadPre * let s:std_in=1
    " autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") |
		" \ exe 'Explorer' argv()[0] | wincmd p | ene | endif
    " " close vim if NERDTRee is the only one open
    " autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    " use litecorrect with markdown
    autocmd FileType markdown,mkd call litecorrect#init()
    " jump to the last position
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    " tab settings
    autocmd Filetype vimwiki,javascript*,typescript*,css,scss,json setlocal expandtab tabstop=2 shiftwidth=2
    " disable spell check in quickfix buffers
    autocmd BufWinEnter * if &bt == 'quickfix' | setlocal nospell | endif
    " formatters
    autocmd FileType javascript,typescript*,html,markdown,json,css,scss setlocal formatprg=prettier\ --stdin\ --stdin-filepath\ \"%\"
    autocmd FileType javascript*,typescript* let b:AutoPairs = AutoPairsDefine({'<>' : '</>'}) | let b:ale_fix_on_save = 1
    autocmd FileType spec setlocal commentstring=#\ %s
    autocmd Filetype python set foldmethod=indent foldnestmax=2
augroup END

" copy to clipboard
"set clipboard+=unnamed

" diff mode settings
set diffopt+=foldcolumn:0

" netrw until netrw in stable and not buggy use Nerdtree
" let g:netrw_banner = 0
" let g:netrw_liststyle = 3
" let g:netrw_browse_split = 4
" let g:netrw_altv = 1
" let g:netrw_winsize = 25
" let g:netrw_fastbrowse = 0

" enable per project .vimrc .nvimrc .exrc
set exrc
set secure

" live substitution
set inccommand=nosplit

set noshowmode " lightline give us mode
