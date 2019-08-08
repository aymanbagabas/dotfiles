call plug#begin('~/.local/share/nvim/plugged')

" Themes
Plug 'chriskempson/base16-vim'
Plug 'mike-hearn/base16-vim-lightline'

" Status line
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'

" Files and buffers
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" Plug 'tpope/vim-vinegar'
Plug 'majutsushi/tagbar'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mbbill/undotree'

" Movement and keyboard
Plug 'christoomey/vim-tmux-navigator'
Plug 'edkolev/tmuxline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'

" Sytnax / Linting / LSP / Autocompletion / Testing
Plug 'sheerun/vim-polyglot'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'w0rp/ale'
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': './install.sh'}
Plug 'ludovicchabant/vim-gutentags'
Plug 'tpope/vim-dispatch'
Plug 'janko/vim-test'
Plug 'ntpeters/vim-better-whitespace'

" Editing
Plug 'reedes/vim-lexical'
Plug 'reedes/vim-litecorrect'
Plug 'junegunn/goyo.vim'
Plug 'pboettch/vim-highlight-cursor-words'
Plug 'editorconfig/editorconfig-vim'
Plug 'Yggdroot/indentLine'
Plug 'mhinz/vim-startify'
Plug 'vimwiki/vimwiki'
Plug 'suan/vim-instant-markdown', { 'for': 'markdown' }
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/vim-easy-align'

" Git
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/git-messenger.vim'
Plug 'tpope/vim-fugitive'

" Icons
Plug 'ryanoasis/vim-devicons'
call plug#end()
