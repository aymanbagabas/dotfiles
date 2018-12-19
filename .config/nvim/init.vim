call plug#begin('~/.local/share/nvim/plugged')

Plug 'chriskempson/base16-vim'

Plug 'junegunn/vim-easy-align'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } | Plug 'Xuyuanp/nerdtree-git-plugin' " | Plug 'jistr/vim-nerdtree-tabs'
Plug 'scrooloose/nerdcommenter'
Plug 'sheerun/vim-polyglot'
Plug 'christoomey/vim-tmux-navigator'
Plug 'majutsushi/tagbar'
Plug 'brooth/far.vim'
Plug 'vim-ctrlspace/vim-ctrlspace'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"Plug 'ncm2/ncm2'
"Plug 'ncm2/ncm2-ultisnips'
"Plug 'roxma/nvim-yarp'
"Plug 'ncm2/ncm2-bufword'
""Plug 'ncm2/ncm2-tmux'
"Plug 'ncm2/ncm2-path'
"Plug 'ncm2/ncm2-jedi'
"Plug 'ncm2/ncm2-pyclang'
"Plug 'jsfaint/ncm2-vim' | Plug 'Shougo/neoinclude.vim'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-fugitive'

Plug 'jiangmiao/auto-pairs'
Plug 'thaerkh/vim-workspace'

Plug 'reedes/vim-pencil'
Plug 'reedes/vim-lexical'
Plug 'reedes/vim-litecorrect'
Plug 'junegunn/goyo.vim'

Plug 'Valloric/YouCompleteMe', { 'do': 'python3 install.py --clang-completer' }
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}

Plug 'w0rp/ale'
Plug 'wbthomason/buildit.nvim'

call plug#end()

" {{{ Base16
    if filereadable(expand("~/.vimrc_background"))
        let base16colorspace=256
        source ~/.vimrc_background
    endif
"}}}

filetype plugin indent on

" Basics
set nocompatible
set hidden

" Encoding
set encoding=utf-8

" Enable mouse
set mouse=a

" set cursor
set cursorline

" set tab options to use 4 spaces instead of tabs
"set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set tabstop=4 softtabstop=0 noexpandtab shiftwidth=4 smarttab

" show newline with list
set listchars+=eol:↵

" set number and relativenumber
set number "relativenumber
"augroup numbertoggle
    "autocmd!
    "autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    "autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
"augroup END

" jump to the last position
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" complete options NOTE: noinsert is required for ncm2
set completeopt+=preview,longest,menuone,menu,noinsert

" spelling
set spell
hi clear SpellRare
hi clear SpellLocal
hi clear SpellCap
hi clear SpellBad
highlight SpellBad cterm=underline

" auto save view options
"augroup AutoSaveView
"    autocmd!
"    autocmd BufWinLeave * mkview
"    autocmd BufWinEnter * silent loadview
"augroup END

" show fold column
set foldmethod=marker
set foldcolumn=2

" copy to clipboard
set clipboard+=unnamedplus

" set leader
let mapleader = ','

" toggle search
let hlstate=0
nnoremap <silent> <leader>h :if (hlstate%2 == 0) \| nohlsearch \| else \| set hlsearch \| endif \| let hlstate=hlstate+1<CR>

" {{{ ncm2
    " suppress the annoying 'match x of y', 'The only match' and 'Pattern not
    " found' messages
    "set shortmess+=c

    " CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
    "inoremap <c-c> <ESC>

    " When the <Enter> key is pressed while the popup menu is visible, it only
    " hides the menu. Use this mapping to close the menu and also start a new
    " line.
    "inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<CR>" : "\<CR>")

    " Use <TAB> to select the popup menu:
    "inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    "inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

    " wrap existing omnifunc
    " Note that omnifunc does not run in background and may probably block the
    " editor. If you don't want to be blocked by omnifunc too often, you could
    " add 180ms delay before the omni wrapper:
    "  'on_complete': ['ncm2#on_complete#delay', 180,
    "               \ 'ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
    "au User Ncm2Plugin call ncm2#register_source({
            "\ 'name' : 'css',
            "\ 'priority': 9, 
            "\ 'subscope_enable': 1,
            "\ 'scope': ['css','scss'],
            "\ 'mark': 'css',
            "\ 'word_pattern': '[\w\-]+',
            "\ 'complete_pattern': ':\s*',
            "\ 'on_complete': ['ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
            "\ })

    "autocmd BufEnter  *  call ncm2#enable_for_buffer()

" }}}

" {{{ ncm2 pyclang
" path to directory where libclang.so can be found
"let g:ncm2_pyclang#library_path = '/usr/lib64/libclang.so'

" a list of relative paths for compile_commands.json
"let g:ncm2_pyclang#database_path = [
            "\ 'compile_commands.json',
            "\ 'build/compile_commands.json'
            "\ ]
" a list of relative paths looking for .clang_complete
"let g:ncm2_pyclang#args_file_path = ['.clang_complete']

" Goto declaration
"autocmd FileType c,cpp nnoremap <buffer> gd :<c-u>call ncm2_pyclang#goto_declaration()<cr>
" }}}

" {{{ UltiSnips
" Press enter key to trigger snippet expansion
" The parameters are the same as `:help feedkeys()`
"inoremap <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')

" c-j c-k for moving in snippet
" let g:UltiSnipsExpandTrigger		= "<Plug>(ultisnips_expand)"
let g:UltiSnipsJumpForwardTrigger	= "<c-j>"
let g:UltiSnipsJumpBackwardTrigger	= "<c-k>"
let g:UltiSnipsRemoveSelectModeMappings = 0
" }}}
    
"{{{ airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline_theme='base16_shell'
let g:airline_powerline_fonts = 1
let g:airline_left_sep = ""
let g:airline_left_alt_sep = ""
let g:airline_right_sep = ""
let g:airline_right_alt_sep = ""
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#whitespace#enabled = 1
"}}}

" {{{ ALE
    highlight ALEErrorSign ctermfg=red ctermbg=18
    highlight ALEWarningSign ctermfg=yellow ctermbg=18
    highligh clear ALEWarning
    highlight ALEWarning ctermbg=none cterm=undercurl
    highligh clear ALEError
    highlight ALEError ctermbg=none cterm=undercurl

    "let g:ale_linters = 'all'
    "let g:ale_linters = {'c': ['clang', 'gcc']}

    "let g:ale_set_highlights = 0
    "let g:ale_completion_enabled = 1
    "let g:ale_c_build_dir_names = ['build', 'bin', '.']
    "let g:ale_c_parse_compile_commands = 1
" }}}

" {{{ YCM
    let g:ycm_seed_identifiers_with_syntax=1
    let g:ycm_collect_identifiers_from_tag_files = 1
    let g:ycm_global_ycm_extra_conf = '~/.config/nvim/ycm_extra_conf.py'
    let g:ycm_confirm_extra_conf = 0
    let g:ycm_error_symbol = '>>'
    let g:ycm_warning_symbol = '--'
    let g:ycm_add_preview_to_completeopt = 1
    let g:ycm_autoclose_preview_window_after_completion = 0
    let g:ycm_autoclose_preview_window_after_insertion = 1

    highlight YcmErrorSign ctermfg=red ctermbg=18
    highlight YcmWarningSign ctermfg=yellow ctermbg=18
" }}}

" {{{ Tagbar
nmap <M-4> :TagbarToggle<CR>
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0
let g:tagbar_type_typescript = {                                                  
  \ 'ctagsbin' : 'tstags',                                                        
  \ 'ctagsargs' : '-f-',                                                           
  \ 'kinds': [                                                                     
    \ 'e:enums:0:1',                                                               
    \ 'f:function:0:1',                                                            
    \ 't:typealias:0:1',                                                           
    \ 'M:Module:0:1',                                                              
    \ 'I:import:0:1',                                                              
    \ 'i:interface:0:1',                                                           
    \ 'C:class:0:1',                                                               
    \ 'm:method:0:1',                                                              
    \ 'p:property:0:1',                                                            
    \ 'v:variable:0:1',                                                            
    \ 'c:const:0:1',                                                              
  \ ],                                                                            
  \ 'sort' : 0                                                                    
\ } 
" }}}

" {{{ NERDTree
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
" nerdtree when opening a dir
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" close vim if nerdtree is the only one open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <M-1> :NERDTreeToggle<CR>

let g:NERDTreeIndicatorMapCustom = {
            \ "Modified"  : "✹",
            \ "Staged"    : "✚",
            \ "Untracked" : "✭",
            \ "Renamed"   : "➜",
            \ "Unmerged"  : "═",
            \ "Deleted"   : "✖",
            \ "Dirty"     : "✗",
            \ "Clean"     : "✔︎",
            \ 'Ignored'   : '☒',
            \ "Unknown"   : "?"
            \ }
" }}}

" {{{ NERDCommenter
nmap <silent><C-_> <leader>c<space>
vmap <silent><C-_> <leader>c<space>
" }}}

" {{{ vim tmux nav
let g:tmux_navigator_no_mappings = 1
tnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
tnoremap <silent> <M-j> :TmuxNavigateDown<cr>
tnoremap <silent> <M-k> :TmuxNavigateUp<cr>
tnoremap <silent> <M-l> :TmuxNavigateRight<cr>
nnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <M-j> :TmuxNavigateDown<cr>
nnoremap <silent> <M-k> :TmuxNavigateUp<cr>
nnoremap <silent> <M-l> :TmuxNavigateRight<cr>
nnoremap <silent> <M-\> :TmuxNavigatePrevious<cr>
" }}}

" {{{ vim-easy-align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
"}}}

" {{{ vim-workspace
nnoremap <leader>s :ToggleWorkspace<CR>
" }}}

" {{{ Colorizer
let g:colorizer_auto_filetype='css,html,js'
" }}}

"{{{ autopairs
let g:AutoPairsShortcutToggle = ''
"}}}

"{{{ CtrlSpace
let g:CtrlSpaceLoadLastWorkspaceOnStart = 1
let g:CtrlSpaceSaveWorkspaceOnSwitch = 1
let g:CtrlSpaceSaveWorkspaceOnExit = 1
let g:CtrlSpaceSymbols = { "File": "◯", "CTab": "▣", "Tabs": "▢" }
nnoremap <silent><C-p> :CtrlSpace<CR>
"}}}

" {{{ Keys
" map ESC to clear serch
nnoremap <silent> <esc> :noh<cr><esc>
nmap <C-a> ggVG
" save
map <C-s> <ESC>:w<CR>
imap <C-s> <ESC>:w<CR>
vmap <C-s> <ESC>:w<CR>
nmap <C-s> <ESC>:w<CR>
" tabs
nmap <Tab> gt<CR>
nmap <S-Tab> gT<CR>
" buffers
imap <M-o> <Esc>:bp<CR>
imap <M-o> <Esc>:bp<CR>
vmap <M-p> <Esc>:bn<CR>
vmap <M-p> <Esc>:bn<CR>
nmap <M-o> <Esc>:bp<CR>
nmap <M-p> <Esc>:bn<CR>
"inoremap <expr> <CR> AutoPairsReturn()
nnoremap <silent> <M-2> :call LoclistToggle()<cr>
nnoremap <silent> <M-3> :call QuickfixToggle()<cr>
let g:loclist_is_open = 0
function! LoclistToggle()
    if g:loclist_is_open
        lclose
        let g:loclist_is_open = 0
    else
        lopen
        let g:loclist_is_open = 1
    endif
endfunction
let g:quickfix_is_open = 0
function! QuickfixToggle()
    if g:quickfix_is_open
        cclose
        let g:quickfix_is_open = 0
    else
        copen
        let g:quickfix_is_open = 1
    endif
endfunction
" }}}

