" set spell highlight to underline
hi clear SpellRare
hi clear SpellLocal
hi clear SpellCap
hi clear SpellBad
highlight SpellBad cterm=underline
highlight SpellCap cterm=underline
highlight SpellLocal cterm=underline
highlight SpellRare cterm=underline

" signcolumn bg black
" highlight SignColumn ctermbg=0

" change BetterWhitespace color highlights
let g:better_whitespace_ctermcolor = "none"
let g:better_whitespace_guicolor = "none"
highlight ExtraWhitespace ctermbg=none guibg=none cterm=undercurl ctermfg=yellow

" change ALE highlights
highlight ALEErrorSign ctermfg=red ctermbg=18
highlight ALEWarningSign ctermfg=yellow ctermbg=18
highlight ALEInfoSign ctermfg=white ctermbg=18
"highlight clear ALEInfo
highlight ALEInfo ctermbg=none guibg=none cterm=undercurl guisp=#ABB2BF
"highligh clear ALEWarning
highlight ALEWarning ctermbg=none guibg=none cterm=undercurl guisp=#E5C07B
"highligh clear ALEError
"highlight Error ctermbg=none guibg=none
highlight ALEError ctermbg=none guibg=none cterm=undercurl guisp=#E06C75
highlight ALEVirtualTextError cterm=italic ctermfg=red
highlight ALEVirtualTextWarning cterm=italic ctermfg=yellow
highlight ALEVirtualTextInfo cterm=italic ctermfg=grey

" gitgutter highlights
" highlight GitGutterAdd ctermbg=0
" highlight GitGutterChange ctermbg=0
" highlight GitGutterChangeDelete ctermbg=0
" highlight GitGutterDelete ctermbg=0
