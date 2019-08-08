function! TabInfo()
	return tabpagenr() . '/' . tabpagenr('$')
endfunction

function! FullFilenameFormat(f)
	if expand('%t') ==# ''
		return '[No Name]'
	else
	    return expand('%:~')
endfunction

function! GitHunkSummary()
	let hunks = GitGutterGetHunkSummary()
	return (hunks[0] ? '+' . hunks[0] . ' ' : '') .
		\ (hunks[1] ? '~' . hunks[1] . ' ' : '') .
		\ (hunks[2] ? '-' . hunks[2] . ' ' : '')
	return join( hunks )
endfunction

function! LightlineIsPlugin()
	let fname = expand('%:t')
	return fname =~ '__Tagbar__' ||
				\ fname == 'ControlP' ||
				\ fname == '__Gundo__' ||
				\ fname == '__Gundo_Preview__' ||
				\ fname =~ 'NERD_tree' ||
				\ &ft == 'unite' ||
				\ &ft == 'vimfiler' ||
				\ &ft == 'vimshell'
endfunction

function! LightlineModified()
	return &modified && !LightlineIsPlugin() ? '+' :
				\ !&modifiable && !LightlineIsPlugin() ?  '-' : ''
endfunction

function! LightlineReadonly()
	return !LightlineIsPlugin() && &readonly ? 'RO' : ''
endfunction

function! LightlineFilename()
	let fname = expand('%:t')
	return fname == 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
				\ fname =~ '__Tagbar__' ? g:lightline.fname :
				\ fname =~ '__Gundo\|NERD_tree' ? '' :
				\ &ft == 'vimfiler' ? vimfiler#get_status_string() :
				\ &ft == 'unite' ? unite#get_status_string() :
				\ &ft == 'vimshell' ? vimshell#get_status_string() :
				\ ('' != fname ? fname : '[No Name]')
				" \ ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
				" \ ('' != fname ? fname : '[No Name]') .
				" \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! LightlineFugitive()
	try
		if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
			let mark = "\ue725 "
			let branch = fugitive#head()
			return branch !=# '' ? GitHunkSummary() . mark.branch : ''
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
	return winwidth(0) > 50 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlinePercent()
	return winwidth(0) > 50 ? (100 * line('.')/line('$') . '%') : ''
endfunction

function! LightlineLineInfo()
    return winwidth(0) > 70 ? printf(' %d:%d/%d', line('.'), col('.'), line('$')) : ''
endfunction

function! LightlineMode()
	let fname = expand('%:t')
	return fname =~ '__Tagbar__' ? 'Tagbar' :
				\ fname == 'ControlP' ? 'CtrlP' :
				\ fname == '__Gundo__' ? 'Gundo' :
				\ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
				\ fname =~ 'NERD_tree' ? 'NERDTree' :
				\ &ft == 'unite' ? 'Unite' :
				\ &ft == 'vimfiler' ? 'VimFiler' :
				\ &ft == 'vimshell' ? 'VimShell' :
				\ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
	if expand('%:t') =~ 'ControlP' && has_key(g:lightline, 'ctrlp_item')
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

let g:lightline = {
	\ 'colorscheme' : 'base16_onedark',
	\ 'tabline' : {
	\   'left': [ [ 'logo', 'tabinfo' ], [ 'tabs' ] ],
	\   'right': [ [ 'fugitive', 'close' ] ],
	\ },
	\ 'tab' : {
	\	'active': [ 'tabnum', 'filename_with_dirs', 'modified' ],
	\	'inactive': [ 'tabnum', 'filename', 'modified' ],
	\ },
	\ 'tab_component_function' : {
	\	'filename_with_dirs' : 'FullFilenameFormat'
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
	\	'logo' : "\ue7c5",
	\	'tabinfo' : "%{ TabInfo() }",
	\	'separator' : '',
	\	'fullfilename' : "%{expand('%:~')}"
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
	\ 'separator' : {
	\	'left' : "\ue0b8", 'right' : "\ue0be"
	\ },
	\ 'subseparator' : {
	\	'left' : "\ue0b9", 'right' : "\ue0bf"
	\ }
\ }

set showtabline=2
