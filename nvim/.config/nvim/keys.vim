" set leader
let mapleader = ' '

" toggle highlighted search
nnoremap <leader>hl :nohls<cr>
" move vertically by visual line
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
" tabs
nnoremap <silent> <M-S-K> :tabnext<CR>
nnoremap <silent> <M-S-J> :tabprevious<CR>
" buffers
nnoremap <silent> <Tab> :bn<CR>
nnoremap <silent> <S-Tab> :bp<CR>
nnoremap <silent> <Del> :bd<CR>
" diff mode
nnoremap <silent> <leader>dp V:diffput<cr>
nnoremap <silent> <leader>dg V:diffget<cr>
nnoremap <silent> <leader>du :wincmd w<cr>:normal u<cr>:wincmd w<cr>
" save session
nnoremap <leader>s :SSave!<cr>
nnoremap <leader>S :mksession<cr>
" quick save/quit
nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>
nnoremap <leader>z :wq<cr>
nnoremap <leader>r :source $MYVIMRC<CR>
" unimpaired preview window
nnoremap ]op :pclose<cr>
nnoremap [op :ppop<cr>

" increase/decrease foldcolumn
nnoremap Zr :call IncFoldCol()<CR>
nnoremap Zm :call DecFoldCol()<CR>

" toggle loc/quick list
nnoremap <silent> <F3> :call LoclistToggle()<cr>
nnoremap <silent> <F4> :call QuickfixToggle()<cr>

" remap \ to ripgrep
nnoremap \ :Rg<space>

" netrw
" nnoremap <leader>f :Vexplore<CR>

" copy to clipboard
vmap <C-c> "+y
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+
