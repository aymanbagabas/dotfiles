" set leader
let g:mapleader = ' '
let g:maplocalleader = ','

" toggle highlighted search
nnoremap <leader>ch :nohls<cr>
" move vertically by visual line
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
" tabs
nnoremap <silent> <M-S-K> :tabnext<CR>
nnoremap <silent> <M-S-J> :tabprevious<CR>
nnoremap <silent><leader>ct :tabclose<CR>
" buffers
nnoremap <silent> <Tab> :bn<CR>
nnoremap <silent> <S-Tab> :bp<CR>
nnoremap <silent> <Del> :bd<CR>
nnoremap <silent><leader>cb :Wipeout<CR>
" diff mode
" nnoremap <silent> <leader>dp V:diffput<cr>
" nnoremap <silent> <leader>dg V:diffget<cr>
" nnoremap <silent> <leader>du :wincmd w<cr>:normal u<cr>:wincmd w<cr>
" save session
nnoremap <leader>sl<cr> :SLoad<cr>
nnoremap <leader>sl<space> :SLoad<space>
nnoremap <leader>ss :SSave<cr>
nnoremap <leader>R :source $MYVIMRC<CR>
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
" nnoremap \ :Rg<space>

" netrw
" nnoremap <leader>f :Vexplore<CR>

" copy to clipboard
vmap <C-c> "+y
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+

" vim-fugitive
nnoremap <leader>gi :G<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gh :Gbrowse<CR>

" vim-gitgutter
nmap ]g <Plug>(GitGutterNextHunk)
nmap [g <Plug>(GitGutterPrevHunk)
nmap <leader>gp <Plug>(GitGutterPreviewHunk)
nmap <leader>gs <Plug>(GitGutterStageHunk)
nmap <leader>gu <Plug>(GitGutterUndoHunk)

" git-messenger
nmap <leader>gm <Plug>(git-messenger)

" vim-ale
nnoremap <leader>f :ALEFix<cr>
nnoremap <leader>e :ALEDetail<cr>
nnoremap ]d :ALENextWrap<CR>     " move to the next ALE warning / error
nnoremap [d :ALEPreviousWrap<CR> " move to the previous ALE warning / error

" coc.nvim
" Make autocompletion behave sanely
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackSpace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Remap keys for gotos
nmap <silent><leader>d <Plug>(coc-definition)
nmap <silent><leader>td <Plug>(coc-type-definition)
nmap <silent><leader>D <Plug>(coc-declaration)
nmap <silent><leader>i <Plug>(coc-implementation)
nmap <silent><leader>r <Plug>(coc-references)
" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>
nnoremap <silent><leader>h :call ShowDocumentation()<CR>
" Remap for rename current word
nmap <silent><leader>n <Plug>(coc-rename)
xmap <silent><leader>A  <Plug>(coc-codeaction-selected)
nmap <silent><leader>A  <Plug>(coc-codeaction-selected)
nmap <silent><leader>a <Plug>(coc-codeaction)
nmap <silent><leader>l <Plug>(coc-codelens-action)
nmap <silent><leader>q  <Plug>(coc-fix-current)
nmap <silent><leader>F <Plug>(coc-format-selected)
xmap <silent><leader>F <Plug>(coc-format-selected)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)
" Show all diagnostics
" nnoremap <silent> <localleader>d  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <leader>ce  :<C-u>CocFzfListExtensions<cr>
" Show commands
nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <leader>/s  :<C-u>CocFzfListOutline<cr>
" Search workspace symbols
nnoremap <silent> <leader>/S  :<C-u>CocFzfListSymbols<cr>
" Do default action for next item.
nnoremap <silent> <leader>cj  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <leader>ck  :<C-u>CocPrev<CR>
" Resume latest coc list
" nnoremap <silent> <leader>p  :<C-u>CocListResume<CR>
nnoremap <silent><localleader>f :Explorer<CR>

" vim kitty nav
if $TERM =~# '.*kitty.*'
    nnoremap <silent> <M-h> :KittyNavigateLeft<cr>
    nnoremap <silent> <M-j> :KittyNavigateDown<cr>
    nnoremap <silent> <M-k> :KittyNavigateUp<cr>
    nnoremap <silent> <M-l> :KittyNavigateRight<cr>
else
    " vim tmux nav
    tnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
    tnoremap <silent> <M-j> :TmuxNavigateDown<cr>
    tnoremap <silent> <M-k> :TmuxNavigateUp<cr>
    tnoremap <silent> <M-l> :TmuxNavigateRight<cr>
    nnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
    nnoremap <silent> <M-j> :TmuxNavigateDown<cr>
    nnoremap <silent> <M-k> :TmuxNavigateUp<cr>
    nnoremap <silent> <M-l> :TmuxNavigateRight<cr>
    nnoremap <silent> <M-\> :TmuxNavigatePrevious<cr>
endif

" undotree
nnoremap <F5> :UndotreeToggle<CR>
nnoremap <leader>u :UndotreeToggle<CR>

" vim-test
nnoremap <leader>Tn :TestNearest<CR>
nnoremap <leader>Tf :TestFile<CR>
nnoremap <leader>Ts :TestSuite<CR>
nnoremap <leader>Tl :TestLast<CR>
nnoremap <leader>Tv :TestVisit<CR>

" vim-easymotion
map <leader>// <Plug>(easymotion-prefix)

" vim-easy-align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" vim-translate
nmap <silent> <Leader>tw <Plug>TranslateW
vmap <silent> <Leader>tw <Plug>TranslateWV

" Vista.vim better tagbar.vim replacement
nmap <silent><leader>o :Vista!!<CR>
nmap <F8> :Vista!!<CR>

    " \ if exists('.git') |
    " \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0) |
    " \ else |
    " \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0) |
    " \ endif
" fzf
nnoremap <silent><leader>/f :Files<CR>
nnoremap <silent><expr> <C-p> exists('.git') ? ':GFiles<CR>' : ':Files<CR>'
nnoremap <leader><Space> :Files ~<CR>
nnoremap <localleader>m :FZFMru<CR>
nnoremap <leader>; :Buffers<CR>
nnoremap <localleader>co :Commits<CR>
nnoremap <localleader>cb :BCommits<CR>
nnoremap <localleader>t :Tags<CR>
nnoremap \ :GGrep<space>
nnoremap \| :Rg<space>
nnoremap <leader>vm :Maps<CR>
nnoremap <leader>vh :Helptags<CR>
nnoremap <leader>vc :Commands<CR>
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" vim-dispatch
nnoremap <localleader>m<CR> :Make<CR>
nnoremap <localleader>m<Space> :Make<Space>