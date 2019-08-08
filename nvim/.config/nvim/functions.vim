fun! IncFoldCol()
	if &foldcolumn < 12
		set foldcolumn+=1
	endif
endfun
fun! DecFoldCol()
	if &foldcolumn > 0
		set foldcolumn-=1
	endif
endfun
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

