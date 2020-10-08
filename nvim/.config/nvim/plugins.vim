call plug#begin('~/.local/share/nvim/plugged')

" Themes
Plug 'chriskempson/base16-vim'
Plug 'mike-hearn/base16-vim-lightline'

" Status line
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'edkolev/tmuxline.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/git-messenger.vim'
Plug 'tpope/vim-rhubarb'

" Files and buffers
" Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Plug 'Xuyuanp/nerdtree-git-plugin'
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" Plug 'tpope/vim-vinegar'
" Plug 'majutsushi/tagbar'
Plug 'liuchengxu/vista.vim'
" Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf.vim'
Plug 'pbogut/fzf-mru.vim'
" Plug 'mbbill/undotree'

" Movement and keyboard
Plug 'christoomey/vim-tmux-navigator'
" Plug 'knubie/vim-kitty-navigator'
Plug 'tpope/vim-unimpaired'
" Plug 'machakann/vim-highlightedyank'

" Sytnax / Linting / LSP / Autocompletion / Testing
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'fszymanski/deoplete-emoji'
" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }
Plug 'sheerun/vim-polyglot'
Plug 'w0rp/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'antoinemadec/coc-fzf'
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }
" Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'aymanbagabas/gobject-snippets'
" Plug 'ludovicchabant/vim-gutentags'
Plug 'ntpeters/vim-better-whitespace'
" Plug 'rhysd/vim-grammarous'

" Editing
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
" Plug 'reedes/vim-lexical'
" Plug 'reedes/vim-litecorrect'
" Plug 'junegunn/goyo.vim'
" Plug 'pboettch/vim-highlight-cursor-words'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-sleuth'
Plug 'Yggdroot/indentLine'
Plug 'mhinz/vim-startify'
" Plug 'vimwiki/vimwiki'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
" Plug 'easymotion/vim-easymotion'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-endwise'
Plug 'junegunn/vim-peekaboo'
" Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'
Plug 'AndrewRadev/tagalong.vim'
Plug 'mattn/emmet-vim'

" Dict
Plug 'voldikss/vim-translator'

" Docs
" Plug 'keith/investigate.vim'

" Project management
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-dispatch'
" Plug 'janko/vim-test'
Plug 'artnez/vim-wipeout'

" Misc
" Plug 'ncm2/float-preview.nvim'
" Plug 'puremourning/vimspector', { 'do': './install_gadget.py --force-enable-chrome --force-enable-node --enable-bash --enable-c --enable-python' }

" Icons
Plug 'ryanoasis/vim-devicons'

call plug#end()
