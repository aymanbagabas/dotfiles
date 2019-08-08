" UltiSnips
"let g:UltiSnipsJumpForwardTrigger="<c-b>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" c-j c-k for moving in snippet
"let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsExpandTrigger="<Plug>(ultisnips_expand)"
let g:UltiSnipsJumpForwardTrigger	= "<c-j>"
let g:UltiSnipsJumpBackwardTrigger	= "<c-k>"
let g:UltiSnipsRemoveSelectModeMappings = 0


"{{{ airline
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#buffer_idx_mode = 1
" let g:airline_theme='base16_shell'
" let g:airline_powerline_fonts = 1
" let g:airline_left_sep = "\ue0b8"
" let g:airline_left_alt_sep = "\ue0b9"
" let g:airline_right_sep = "\ue0be"
" let g:airline_right_alt_sep = "\ue0b9"
" let g:airline#extensions#whitespace#enabled = 0
" let g:airline#extensions#whitespace#show_message = 0
" let g:airline#extensions#ale#enabled = 1
" let airline#extensions#ale#error_symbol = 'E:'
" let airline#extensions#ale#warning_symbol = 'W:'
" let airline#extensions#ale#show_line_numbers = 0
" let airline#extensions#ale#open_lnum_symbol = '(L'
" let airline#extensions#ale#close_lnum_symbol = ')'
"let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
"let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'
"}}}


" vim-fugitive
nnoremap <leader>gs :G<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gb :Gblame<CR>
command! -nargs=* Ggrph Git! graph <args>
nnoremap <leader>gg :Ggrph<cr>
  
" ALE
let g:ale_linters = {
			\ 'c': ['clangd', 'gcc'],
			\ 'sh': ['language_server'],
			\ 'vim': ['vint'],
			\ 'markdown': ['markdownlint', '-s'],
			\ 'javascript': ['eslint'],
			\ 'html': ['htmlhint'],
			\ }
let g:ale_fixers = {
			\ 'javascript': ['prettier', 'eslint', 'importjs', 'trim_whitespace', 'remove_trailing_lines'],
			\ 'css': ['prettier', 'trim_whitespace', 'remove_trailing_lines'],
			\ 'html': ['prettier', 'trim_whitespace', 'remove_trailing_lines'],
			\ }
let g:ale_javascript_prettier_options = '--semi --trailing-comma es5'
" let g:ale_fix_on_save = 1
let g:ale_set_balloons = 1
let g:ale_set_highlights = 1
let g:ale_completion_enabled = 0
let g:ale_c_build_dir_names = ['build', 'bin', '.']
let g:ale_c_parse_compile_commands = 0
let g:ale_sign_column_always = 1
let g:ale_sign_error = '█'			" •┇
let g:ale_sign_warning = '█'
let g:ale_virtualtext_cursor = 1
nnoremap <leader>af :ALEFix<cr>

" coc.nvim
" Close preview window after completion is done
" autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
" autocmd! InsertLeave * if pumvisible() == 0 | pclose | endif
" Show signature help while editing
autocmd CursorHoldI * silent! call CocAction('showSignatureHelp')
" Make autocompletion behave sanely
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"" Use <c-space> to trigger completion.
inoremap <expr> <c-space> coc#refresh()
" Remap keys for gotos
nmap gd <Plug>(coc-definition)
nmap gt <Plug>(coc-type-definition)
nmap gi <Plug>(coc-implementation)
nmap gr <Plug>(coc-references)
" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction
" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')
" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
"set completeopt+=preview
"autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" autocmd! CursorMoved * if &previewwindow == 1 | pclose | endif
" autocmd! InsertLeave * if pumvisible() == 0 | pclose | endif
" nnoremap <expr><C-f> coc#util#has_float() ? coc#util#float_scroll(1) : "\<C-f>"
" nnoremap <expr><C-b> coc#util#has_float() ? coc#util#float_scroll(0) : "\<C-b>"
let g:coc_global_extensions = [
			\ 'coc-tsserver',
			\ 'coc-json',
			\ 'coc-css',
			\ 'coc-html',
			\ 'coc-java',
			\ 'coc-yaml',
			\ 'coc-python',
			\ 'coc-ultisnips',
			\ 'coc-tag',
			\ 'coc-emoji',
			\ ]

"{{{ YCM
"let g:ycm_seed_identifiers_with_syntax=1
"let g:ycm_collect_identifiers_from_tag_files = 1
"let g:ycm_global_ycm_extra_conf = '~/.config/nvim/ycm_extra_conf.py'
"let g:ycm_confirm_extra_conf = 0
"let g:ycm_error_symbol = '>>'
"let g:ycm_warning_symbol = '--'
"let g:ycm_add_preview_to_completeopt = 1
"let g:ycm_autoclose_preview_window_after_completion = 0
"let g:ycm_autoclose_preview_window_after_insertion = 1
"let g:ycm_key_list_select_completion = ['<C-n>']
"let g:ycm_key_list_previous_completion = ['<C-p>']
"let g:ycm_key_list_stop_completion = ['<C-y>']
"let g:ycm_key_detailed_diagnostics = '<leader>d'

"highlight YcmErrorSign ctermfg=red ctermbg=18
"highlight YcmWarningSign ctermfg=yellow ctermbg=18


" Tagbar
nnoremap <F8> :TagbarToggle<CR>
nnoremap <leader>tb :TagbarToggle<CR>
let g:tagbar_compact = 1

" NERDTree
let g:NERDTreeDirArrowExpandable = "\u00a0"
let g:NERDTreeDirArrowCollapsible = "\u00a0"
let g:NERDTreeNodeDelimiter="\x07"   "non-breaking space
let g:NERDTreeQuitOnOpen = 3
let g:NERDTreeAutoDeleteBuffer=1
nnoremap <F2> :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeToggle<CR>
let g:NERDTreeMinimalUI = 1

" ✗✔︎☒
let g:NERDTreeIndicatorMapCustom = {
			\ "Modified"  : "*",
			\ "Staged"    : "+",
			\ "Untracked" : "¤",
			\ "Renamed"   : "→ ",
			\ "Unmerged"  : "=",
			\ "Deleted"   : "x",
			\ "Dirty"     : " ",
			\ "Clean"     : " ",
			\ 'Ignored'   : " ",
			\ "Unknown"   : " "
			\ }
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name
let g:NERDTreeLimitedSyntax = 1

" devicons
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_conceal_nerdtree_brackets = 1
let g:WebDevIconsUnicodeGlyphDoubleWidth = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1

" vim tmux nav
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

" autopairs
"let g:AutoPairsShortcutToggle = ''

" CtrlP
if executable('rg')
	set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
	command! -nargs=+ -complete=file -bar Rg silent! grep! <args>|cwindow|redraw!
	let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
	let g:ctrlp_use_caching = 0
endif
nnoremap <leader>b :CtrlPBuffer<cr>
nnoremap <leader><space> :CtrlPMixed<cr>
let g:ctrlp_buffer_func = { 'enter': 'MyCtrlPMappings' }

func! MyCtrlPMappings()
    nmap <buffer> <silent> <c-space> <F7>
endfunc

" vim-highlight-cursor-words
let g:HiCursorWords_style='term=bold cterm=bold'

" vim-polyglot
let g:polyglot_disabled = ['python']
let g:python_highlight_all = 1

" gitgutter
let g:gitgutter_sign_added = '┃'
let g:gitgutter_sign_modified = '┃'
let g:gitgutter_sign_removed = '━'
let g:gitgutter_sign_modified_removed = '╋━'
nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk
nmap <silent><leader>hp :let g:__gitgutter_hunk_preview=gitgutter#hunk#in_hunk(line('.'))<cr><Plug>GitGutterPreviewHunk
let g:gitgutter_async=1
let g:gitgutter_grep_command = 'grep -e'

" Tmuxline
let g:tmuxline_separators = {
			\	'left' : "\ue0b8", 'right' : "\ue0be",
			\	'left_alt' : "\ue0b9", 'right_alt' : "\ue0bf",
			\	'space' : ' '}

" gutentags
let g:gutentags_modules = [ 'ctags' ]
let g:gutentags_project_root = ['.root']
let g:gutentags_cache_dir = expand('~/.cache/tags')

" indentLine
let g:indentLine_enabled = 1
let g:indentLine_setConceal = 2
let g:indentLine_setColors = 1
let g:indentLine_char = '│'

" undotree
nnoremap <F5> :UndotreeToggle<CR>
nnoremap <leader>u :UndotreeToggle<CR>
let g:undotree_HelpLine = 0

" vimwiki
let g:vimwiki_global_ext = 0
let g:vimwiki_list = [{'path': '~/vimwiki/',
			\ 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
let g:vimwiki_option_list_margin = 0

" vim-test
let test#strategy = "dispatch"
nnoremap <leader>tn :TestNearest<CR>
nnoremap <leader>tf :TestFile<CR>
nnoremap <leader>ts :TestSuite<CR>
nnoremap <leader>tl :TestLast<CR>
nnoremap <leader>tv :TestVisit<CR>

" vim-easymotion
map <Leader>/ <Plug>(easymotion-prefix)

" vim-closetag
let g:closetag_filetypes = 'html,xhtml,phtml,javascript'

" vim-easy-align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" vim-instant-markdown
"Uncomment to override defaults:
"let g:instant_markdown_slow = 1
"let g:instant_markdown_autostart = 0
"let g:instant_markdown_open_to_the_world = 1
"let g:instant_markdown_allow_unsafe_content = 1
"let g:instant_markdown_allow_external_content = 0
"let g:instant_markdown_mathjax = 1
"let g:instant_markdown_logfile = '/tmp/instant_markdown.log'
"let g:instant_markdown_autoscroll = 0

let g:float_preview#docked = 0
