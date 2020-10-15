" scriptencoding utf-8

function! TabInfo()
	return tabpagenr() . '/' . tabpagenr('$')
endfunction

function! GitHunkSummary()
	let l:hunks = GitGutterGetHunkSummary()
	return (l:hunks[0] ? '+' . l:hunks[0] . ' ' : '') .
		\ (l:hunks[1] ? '~' . l:hunks[1] . ' ' : '') .
		\ (l:hunks[2] ? '-' . l:hunks[2] . ' ' : '')
	return join( l:hunks )
endfunction

function! LightlineIsPlugin(fname, ft, bt)
	return a:fname ==# 'ControlP' ||
				\ a:fname =~# 'NERD_tree\|__vista\|undotree\|diffpanel' ||
				\ a:ft ==# 'nerdtree' ||
				\ a:ft ==# 'undotree' ||
				\ a:ft =~# 'vista' ||
				\ a:ft ==# 'help' ||
				\ a:ft ==# 'fzf' ||
				\ a:bt ==# 'quickfix'
endfunction

function! LightlineModified()
	let l:fname = expand('%:t')
	return &modified && !LightlineIsPlugin(l:fname, &filetype, &buftype) ? '+' :
				\ !&modifiable && !LightlineIsPlugin(l:fname, &filetype, &buftype) ?  '-' : ''
endfunction

function! LightlineTabModified(n)
	let l:winnr = tabpagewinnr(a:n)
	let l:buflist = tabpagebuflist(a:n)
	let l:winnr = tabpagewinnr(a:n)
	let l:fname = expand('#'.l:buflist[l:winnr - 1].':t')
	let l:modified = gettabwinvar(a:n, l:winnr, '&modified')
	let l:modifiable = gettabwinvar(a:n, l:winnr, '&modifiable')
	let l:ft = gettabwinvar(a:n, l:winnr, '&ft')
	let l:bt = gettabwinvar(a:n, l:winnr, '&bt')
	return l:modified && !LightlineIsPlugin(l:fname, l:ft, l:bt) ? '+' :
				\ !l:modifiable && !LightlineIsPlugin(l:fname, l:ft, l:bt) ?  '-' : ''
endfunction

function! LightlineReadonly()
	return !LightlineIsPlugin(expand('%:t'), &filetype, &buftype) && &readonly ? 'RO' : ''
endfunction

function! Filename(fname, ft, bt, showname)
	return a:fname =~# 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? 'CtrlP ' . g:lightline.ctrlp_item :
				\ a:fname =~# 'NERD_tree' || a:ft =~# 'nerdtree' ? a:showname ? 'NERDTree' : '' :
				\ a:fname =~# 'undotree' || a:ft =~# 'undotree' ? a:showname ? 'Undotree ' : '' :
				\ a:fname =~# 'diffpanel' ? a:showname ? 'Diffpanel' : '' :
				\ a:fname =~# '__vista' || a:ft =~# 'vista' ? a:showname ? 'Vista' : '' :
				\ a:ft ==# 'fzf' ? 'FZF' :
				\ a:ft ==# 'coc-explorer' ? 'Explorer' :
				\ a:bt ==# 'quickfix' ? a:showname ? 'Quickfix' : '' :
				\ ('' !=# a:fname ? a:fname : '[No Name]')
				" \ ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
				" \ ('' != a:fname ? a:fname : '[No Name]') .
				" \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! LightlineFilename()
	let l:fname = expand('%:t')
	return Filename(l:fname, &filetype, &buftype, v:false)
endfunction

function! LightlineFullFilename()
	let l:fname = pathshorten(expand('%:~'))
	return Filename(l:fname, &filetype, &buftype, v:false)
endfunction

function! LightlineTabFilename(n)
	let l:buflist = tabpagebuflist(a:n)
	let l:winnr = tabpagewinnr(a:n)
	let l:fname = expand('#'.l:buflist[l:winnr - 1].':t')
	let l:ft = gettabwinvar(a:n, l:winnr, '&ft')
	let l:bt = gettabwinvar(a:n, l:winnr, '&bt')
	return Filename(l:fname, l:ft, l:bt, v:true)
endfunction

function! LightlineTabFullFilename(n)
	let l:buflist = tabpagebuflist(a:n)
	let l:winnr = tabpagewinnr(a:n)
	" let l:fname = expand('#'.l:buflist[l:winnr - 1].':~')
	let l:fname = fnamemodify(expand('#'.l:buflist[l:winnr - 1].'%'), ':~:.')
	let l:ft = gettabwinvar(a:n, l:winnr, '&ft')
	let l:bt = gettabwinvar(a:n, l:winnr, '&bt')
	return Filename(l:fname, l:ft, l:bt, v:true)
endfunction

function! LightlineFugitive()
	try
		if exists('*fugitive#head')
			let l:mark = ' '
			let l:branch = fugitive#head()
			return l:branch !=# '' ? GitHunkSummary() . l:mark . l:branch : ''
		endif
	catch
	endtry
	return ''
endfunction

function! LightlineFileformat()
	return winwidth(0) > 50 ? &fileformat : ''
endfunction

function! LightlineFiletype()
	return winwidth(0) > 50 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
	return winwidth(0) > 50 ? (&fileencoding !=# '' ? &fileencoding : &encoding) : ''
endfunction

function! LightlinePercent()
	return winwidth(0) > 50 ? (100 * line('.')/line('$') . '%') : ''
endfunction

function! LightlineLineInfo()
    return winwidth(0) > 70 ? printf(' %d/%d:%d', line('.'), line('$'), col('.')) : ''
endfunction

function! LightlineMode()
	let l:fname = expand('%:t')
	return l:fname =~# '__Tagbar__' ? 'Tagbar' :
				\ l:fname ==# 'ControlP' ? 'CtrlP' :
				\ l:fname ==# '__Gundo__' ? 'Gundo' :
				\ l:fname ==# '__Gundo_Preview__' ? 'Gundo Preview' :
				\ l:fname =~# 'NERD_tree' ? 'NERDTree' :
				\ l:fname =~# 'diffpanel' ? 'Diffpanel' :
				\ &filetype ==# 'undotree' ? 'Undotree' :
				\ &filetype ==# 'unite' ? 'Unite' :
				\ &filetype ==# 'vimfiler' ? 'VimFiler' :
				\ &filetype ==# 'vimshell' ? 'VimShell' :
				\ &filetype =~# 'vista' ? 'Vista' :
				\ &buftype ==# 'quickfix' ? 'Quickfix' :
				\ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
	if expand('%:t') =~# 'ControlP' && has_key(g:lightline, 'ctrlp_item')
		call lightline#link('iR'[g:lightline.ctrlp_regex])
		return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
					\ , g:lightline.ctrlp_next], 0)
	else
		return ''
	endif
endfunction

let g:ctrlp_status_func = {
			\ 'main': 'CtrlPStatusFunc_1',
			\ 'prog': 'CtrlPStatusFunc_2',
			\ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
	let g:lightline.ctrlp_regex = a:regex
	let g:lightline.ctrlp_prev = a:prev
	let g:lightline.ctrlp_item = a:item
	let g:lightline.ctrlp_next = a:next
	return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
	return lightline#statusline(0)
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
	let g:lightline.fname = a:fname
	return lightline#statusline(0)
endfunction

function! LightlineBufferline()
  call bufferline#refresh_status()
  return [ g:bufferline_status_info.before, g:bufferline_status_info.current, g:bufferline_status_info.after]
endfunction

function! FileTypeSymbol(n)
	let l:bufnr = tabpagebuflist(a:n)[tabpagewinnr(a:n) - 1]
	let l:fname = expand('#' . l:bufnr . ':t')
	return WebDevIconsGetFileTypeSymbol(l:fname, isdirectory(l:fname))
endfunction

let g:lightline = {
	\ 'colorscheme' : 'base16_onedark',
	\ 'tabline' : {
	\   'left': [ [ 'logo', 'tabinfo' ], [ 'tabs' ] ],
	\   'right': [ [ 'fugitive', 'close' ] ],
	\ },
	\ 'tab' : {
	\	'active': [ 'tabnum', 'fullfilename', 'filetypesymbol', 'modified' ],
	\	'inactive': [ 'tabnum', 'filename', 'filetypesymbol', 'modified' ],
	\ },
	\ 'tab_component_function' : {
	\	'filename' : 'LightlineTabFilename',
	\	'fullfilename' : 'LightlineTabFullFilename',
	\	'modified': 'LightlineTabModified',
	\	'filetypesymbol' : 'FileTypeSymbol'
	\ },
	\ 'inactive': {
	\	'left': [ [ 'fullfilename', 'modified' ], ],
	\	'right': [ [ 'lineinfo' ],
	\				[ 'percent' ], ]
	\ },
	\ 'active': {
	\	'left': [ [ 'mode', 'paste' ],
	\				[ 'readonly', 'filename', 'modified' ], ['ctrlpmark'] ],
	\	'right': [ [ 'linter_errors', 'linter_warnings', 'lineinfo' ],
	\				[ 'percent' ],
	\				[ 'fileformat', 'fileencoding', 'filetype' ] ]
	\ },
	\ 'component' : {
	\	'logo' : '',
	\	'tabinfo' : '%{ TabInfo() }',
	\	'separator' : '',
	\ },
	\ 'component_expand' : {
	\	'linter_checking' : 'lightline#ale#checking',
	\	'linter_warnings' : 'lightline#ale#warnings',
	\	'linter_errors' : 'lightline#ale#errors',
	\	'linter_ok' : 'lightline#ale#ok',
	\ },
	\ 'component_function': {
	\	'percent': 'LightlinePercent',
	\	'readonly': 'LightlineReadonly',
	\	'modified': 'LightlineModified',
	\	'lineinfo': 'LightlineLineInfo',
	\	'fugitive': 'LightlineFugitive',
	\	'hunks': 'GitHunkSummary',
	\	'filename': 'LightlineFilename',
	\	'fullfilename': 'LightlineFullFilename',
	\	'fileformat': 'LightlineFileformat',
	\	'filetype': 'LightlineFiletype',
	\	'fileencoding': 'LightlineFileencoding',
	\	'mode': 'LightlineMode',
	\	'ctrlpmark': 'CtrlPMark',
	\ },
	\ 'component_type' : {
	\	'bufferline': 'tabsel',
	\	'linter_checking': 'left',
	\	'linter_warnings': 'warning',
	\	'linter_errors': 'error',
	\	'linter_ok': 'left',
	\ },
\ }

	" \ 'separator' : {
	" \	'left' : '\ue0b8', 'right' : '\ue0be'
	" \ },
	" \ 'subseparator' : {
	" \	'left' : '\ue0b9', 'right' : '\ue0bf'
	" \ }
set showtabline=1