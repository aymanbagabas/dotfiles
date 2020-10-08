" Base16 theme
if filereadable(expand("~/.vimrc_background"))
    let base16colorspace=256
    source ~/.vimrc_background
endif

" enable true colors
if (has("termguicolors"))
  set termguicolors
endif

" set spell highlight to underline
hi clear SpellRare
hi clear SpellLocal
hi clear SpellCap
hi clear SpellBad
highlight SpellBad cterm=underline gui=underline
highlight SpellCap cterm=underline gui=underline
highlight SpellLocal cterm=underline gui=underline
highlight SpellRare cterm=underline gui=underline

" signcolumn bg black
" highlight SignColumn ctermbg=0

" change BetterWhitespace color highlights
" let g:better_whitespace_ctermcolor = "red"
" let g:better_whitespace_guicolor = "#E06C75"
highlight ExtraWhitespace ctermbg=none guibg=none cterm=undercurl gui=undercurl guisp=#E5C07B ctermfg=yellow
augroup ExtraWhitespaceTheme
  autocmd!
  autocmd FileType gitcommit highlight ExtraWhitespace ctermbg=red guibg=#E06C75 cterm=none gui=none guisp=none ctermfg=none
augroup END

" change ALE highlights
highlight ALEErrorSign ctermfg=red ctermbg=18 guibg=#353b45 guifg=#E06C75
highlight ALEWarningSign ctermfg=yellow ctermbg=18 guibg=#353b45 guifg=#E5C07B
highlight ALEInfoSign ctermfg=white ctermbg=18 guibg=#353b45 guifg=#ABB2BF
"highlight clear ALEInfo
highlight ALEInfo ctermbg=none guibg=none cterm=undercurl guisp=#ABB2BF gui=undercurl
"highligh clear ALEWarning
highlight ALEWarning ctermbg=none guibg=none cterm=undercurl guisp=#E5C07B gui=undercurl
"highligh clear ALEError
"highlight Error ctermbg=none guibg=none
highlight ALEError ctermbg=none guibg=none cterm=undercurl gui=undercurl guisp=#E06C75
highlight ALEVirtualTextError cterm=italic ctermfg=red gui=italic guifg=#E06C75
highlight ALEVirtualTextWarning cterm=italic ctermfg=yellow gui=italic guifg=#E5C07B
highlight ALEVirtualTextInfo cterm=italic ctermfg=grey gui=italic guifg=#ABB2BF

" gitgutter highlights
" highlight GitGutterAddLine ctermbg=none
" highlight GitGutterChangeLine ctermbg=none
" highlight GitGutterDeleteLine ctermbg=none
" highlight GitGutterChangeDeleteLine ctermbg=none
highlight DiffAdded ctermbg=none
highlight DiffRemoved ctermbg=none
" highlight GitGutterAdd ctermbg=0
" highlight GitGutterChange ctermbg=0
" highlight GitGutterChangeDelete ctermbg=0
" highlight GitGutterDelete ctermbg=0
