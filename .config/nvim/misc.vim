" deoplete
" let g:deoplete#enable_at_startup = 1

" git-messenger
let g:git_messenger_no_default_mappings = v:true

" UltiSnips
"let g:UltiSnipsJumpForwardTrigger="<c-b>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" c-j c-k for moving in snippet
"let g:UltiSnipsExpandTrigger="<c-j>"
" let g:UltiSnipsExpandTrigger="<Plug>(ultisnips_expand)"
" let g:UltiSnipsJumpForwardTrigger	= "<c-j>"
" let g:UltiSnipsJumpBackwardTrigger	= "<c-k>"
" let g:UltiSnipsRemoveSelectModeMappings = 0


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

" ALE
let g:ale_linters = {
      \ 'c': ['ccls', 'clang', 'gcc'],
      \ 'cpp': ['ccls', 'clang', 'gcc'],
      \ 'javascript': ['eslint'],
      \ 'sh': ['bash-language-server'],
      \ 'markdown': ['languagetool', 'markdownlint'],
      \ 'vim': ['vint'],
      \ 'html': ['htmlhint'],
      \ 'gitcommit': ['languagetool'],
      \ 'conf': ['languagetool'],
      \ 'python': ['flake8'],
      \ }
let g:ale_linter_aliases = {
      \ 'typescriptreact': 'typescript',
      \ }
let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'c': ['clang-format'],
      \ 'cpp': ['clang-format'],
      \ 'javascript': ['eslint', 'importjs'],
      \ 'javascriptreact': ['eslint', 'importjs'],
      \ 'typescript': ['eslint', 'importjs'],
      \ 'typescriptreact': ['eslint', 'importjs'],
      \ 'json': ['prettier'],
      \ 'css': [],
      \ 'scss': [],
      \ 'html': ['prettier'],
      \ 'markdown': ['prettier'],
      \ 'python': ['black', 'add_blank_lines_for_python_control_statements'],
      \ 'swift': ['swiftformat'],
      \ 'xml': ['xmllint']
      \ }
" let g:ale_javascript_prettier_options = '--semi --trailing-comma es5'
let g:ale_languagetool_executable = 'LanguageTool-cli'
let g:ale_python_auto_pipenv = 1
" let g:ale_fix_on_save = 1
let g:ale_set_balloons = 1
let g:ale_set_highlights = 1
let g:ale_completion_enabled = 0
let g:ale_c_build_dir_names = ['build', 'bin', '.']
let g:ale_c_parse_compile_commands = 0
let g:ale_sign_column_always = 1
let g:ale_sign_error = 'X'			" •┇█╼━
let g:ale_sign_warning = '!'
let g:ale_virtualtext_cursor = 1
let g:ale_fix_on_save = 0

" coc.nvim
" Close preview window after completion is done
" autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
" autocmd! InsertLeave * if pumvisible() == 0 | pclose | endif
" Show signature help while editing
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

augroup cocnvim
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

			" \ 'coc-ultisnips',
			" \ 'coc-tabnine',
			" \ 'coc-omnisharp',
let g:coc_global_extensions = [
			\ 'coc-explorer',
			\ 'coc-tsserver',
			\ 'coc-json',
			\ 'coc-css',
			\ 'coc-html',
			\ 'coc-java',
			\ 'coc-yaml',
			\ 'coc-python',
			\ 'coc-tag',
			\ 'coc-emoji',
			\ 'coc-snippets',
			\ 'https://github.com/xabikos/vscode-react',
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
" nnoremap <F8> :TagbarToggle<CR>
" nnoremap <leader>tb :TagbarToggle<CR>
" let g:tagbar_compact = 1

" NERDTree
" let g:NERDTreeDirArrowExpandable = "\u00a0"
" let g:NERDTreeDirArrowCollapsible = "\u00a0"
" let g:NERDTreeNodeDelimiter="\x07"   "non-breaking space
" let g:NERDTreeQuitOnOpen = 0
" let g:NERDTreeAutoDeleteBuffer=1
" nnoremap <F2> :NERDTreeToggle<CR>
" nnoremap <leader>f :NERDTreeToggle<CR>
" let g:NERDTreeMinimalUI = 1

" ✗✔︎☒
" let g:NERDTreeIndicatorMapCustom = {
" 			\ 'Modified'  : '*',
" 			\ 'Staged'    : '+',
" 			\ 'Untracked' : '¤',
" 			\ 'Renamed'   : '→ ',
" 			\ 'Unmerged'  : '=',
" 			\ 'Deleted'   : 'x',
" 			\ 'Dirty'     : ' ',
" 			\ 'Clean'     : ' ',
" 			\ 'Ignored'   : ' ',
" 			\ 'Unknown'   : ' '
" 			\ }
" let g:NERDTreeFileExtensionHighlightFullName = 1
" let g:NERDTreeExactMatchHighlightFullName = 1
" let g:NERDTreePatternMatchHighlightFullName = 1
" let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
" let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name
" let g:NERDTreeLimitedSyntax = 1

" devicons
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_conceal_nerdtree_brackets = 1
let g:WebDevIconsUnicodeGlyphDoubleWidth = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1

" autopairs
let g:AutoPairsShortcutToggle = ''

" CtrlP
" if executable('rg')
" 	set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
" 	command! -nargs=+ -complete=file -bar Rg silent! grep! <args>|cwindow|redraw!
" 	let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
" 	let g:ctrlp_use_caching = 0
" endif
" nnoremap <leader>b :CtrlPBuffer<cr>
" nnoremap <leader><space> :CtrlPMixed<cr>
" let g:ctrlp_buffer_func = { 'enter': 'MyCtrlPMappings' }

" func! MyCtrlPMappings()
"     nmap <buffer> <silent> <c-space> <F7>
" endfunc

" vim-highlight-cursor-words
let g:HiCursorWords_style='term=bold cterm=bold'

" vim-polyglot
" let g:polyglot_disabled = ['python']
" let g:python_highlight_all = 1
" let g:vim_json_warnings = 0

" gitgutter
let g:gitgutter_map_keys = 0
let g:gitgutter_sign_added = '┃'
let g:gitgutter_sign_modified = '┃'
let g:gitgutter_sign_removed = '━'
let g:gitgutter_sign_modified_removed = '╋━'
let g:gitgutter_async=1
let g:gitgutter_grep_command = 'grep -e'
let g:gitgutter_preview_win_floating = 1

" Tmuxline
let g:tmuxline_separators = {
			\	'left' : "\ue0b8", 'right' : "\ue0be",
			\	'left_alt' : "\ue0b9", 'right_alt' : "\ue0bf",
			\	'space' : ' '}

" gutentags
let g:gutentags_modules = [ 'ctags' ]
let g:gutentags_project_root = ['.root', '.git']
let g:gutentags_cache_dir = expand('~/.cache/tags')

" indentLine
let g:indentLine_enabled = 1
let g:indentLine_setConceal = 2
let g:indentLine_setColors = 1
let g:indentLine_char = '│'
let g:indentLine_fileTypeExclude = ['vimwiki', 'markdown']
let g:indentLine_concealcursor = ""

" undotree
let g:undotree_HelpLine = 0

" vimwiki
let g:vimwiki_global_ext = 0
let g:vimwiki_list = [{'path': '~/vimwiki/',
			\ 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
let g:vimwiki_option_list_margin = 0

" vim-test
let g:test#strategy = 'dispatch'

" vim-dispatch

" vim-closetag
" These are the file extensions where this plugin is enabled.
let g:closetag_filetypes = 'html,xhtml,phtml,javascript,javascriptreact,typescript,typescriptreact'
let g:closetag_xhtml_filetypes = 'xhtml'
let g:closetag_regions = {
    \ 'typescript': 'jsxRegion,tsxRegion',
    \ 'javascript': 'jsxRegion',
    \ 'typescriptreact': 'jsxRegion,tsxRegion',
    \ 'javascriptreact': 'jsxRegion',
    \ }
let g:closetag_shortcut = '>'

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

" vim-translate
let g:translator_source_lang = 'auto'
let g:translator_target_lang = 'ar'
let g:translator_debug_mode = v:true
let g:translator_default_engines = ['trans', 'google']
let g:translator_translate_shell_options = ['-no-ansi', '-no-theme', '-no-bidi', '-show-original y', '-show-original-phonetics y', '-show-translation y', '-show-translation-phonetics y', '-show-prompt-message y', '-show-languages y', '-show-original-dictionary y', '-show-dictionary y', '-show-alternatives y']

" Vista.vim better tagbar.vim replacement
let g:vista_executive_for = {
	\ 'javascript': 'coc',
	\ 'markdown': 'toc'
\ }

" fzf
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noruler
  \| autocmd BufLeave <buffer> set laststatus=2 ruler
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }
" let g:fzf_layout = { 'window': { 'width': '0.9', 'height': '0.6' } }
let g:fzf_history_dir = '~/.local/share/fzf-history'
let g:fzf_tags_command = 'ctags -R'
let g:fzf_commits_log_options = '--graph --color=always
  \ --format="%C(yellow)%h%C(red)%d%C(reset)
  \ - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"'
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
let g:fzf_buffers_jump = 1
" preview
command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always --smart-case --no-ignore-vcs --hidden '.shellescape(<q-args>), 1,
    \   fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=* GGrep
    \ call fzf#vim#grep(
    \   'git grep -i --color=always --line-number '.shellescape(<q-args>), 0,
    \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=? -complete=dir GFiles
    \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0) |

" vim-hexokinase
let g:Hexokinase_optInPatterns = [
\     'full_hex',
\     'triple_hex',
\     'rgb',
\     'rgba',
\     'hsl',
\     'hsla',
\     'colour_names'
\ ]
let g:Hexokinase_alpha_bg = '#ffffff'
let g:Hexokinase_highlighters = ['virtual']

" vim-startify
let g:startify_change_to_dir = 0

" vim-dispatch
let g:dispatch_terminal_exec = 'gnome-terminal'

" vim-prettier
let g:prettier#autoformat = 0
let g:prettier#exec_cmd_async = 1
let g:prettier#quickfix_enabled = 1
let g:prettier#quickfix_auto_focus = 0
let g:prettier#config#tab_width = 2
let g:prettier#config#use_tabs = 'false'
let g:prettier#config#semi = 'true'
let g:prettier#config#single_quote = 'false'
let g:prettier#config#trailing_comma = 'es5'

" vim-betterwhitespaces
let g:better_whitespace_enabled = 1
let g:strip_whitespace_on_save = 1
let g:better_whitespace_operator = ''
let g:strip_whitespace_confirm = 0
let g:better_whitespace_filetypes_blacklist = ['diff', 'unite', 'qf', 'help']

" investigate.vim
let g:investigate_command_for_all = '/usr/bin/devhelp -s ^s'

" markdown-preview.nvim
" let g:mkdp_markdown_css = '/tmp/styles.css'

" let g:LanguageClient_autoStart = 1
" let g:LanguageClient_serverCommands = {
"     \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
"     \ 'javascript': ['javascript-typescript-stdio'],
"     \ 'typescript': ['javascript-typescript-stdio'],
"     \ 'python': ['/usr/local/bin/pyls'],
"     \ 'ruby': ['~/.rbenv/shims/solargraph', 'stdio'],
"     \ }
" let g:LanguageClient_rootMarkers = {
"     \ 'javascript': ['jsconfig.json', '.git'],
"     \ 'typescript': ['tsconfig.json', '.git'],
"     \ }

" nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
" nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
" nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

" let g:deoplete#enable_at_startup = 1
" call deoplete#custom#source('LanguageClient',
"             \ 'min_pattern_length',
"             \ 2)

let g:vimspector_enable_mappings = 'HUMAN'
" packadd! vimspector

" vim-tmux-navigator
let g:tmux_navigator_no_mappings = 1

" vim-kitty-navigator
let g:kitty_navigator_no_mappings = 1
let g:kitty_navigator_listening_on_address = '\@kitty'

" vim-tagalong
let g:tagalong_additional_filetypes = ['javascript']

" emmet.vim
let g:user_emmet_mode='a'    "enable all function in all mode.
let g:user_emmet_leader_key=','
let g:user_emmet_install_global = 0
autocmd FileType html,css,javascript*,typescript* EmmetInstall