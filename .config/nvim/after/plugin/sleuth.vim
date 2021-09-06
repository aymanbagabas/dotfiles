augroup sleuthcompat
    autocmd!
    autocmd FileType * silent if len(findfile('.editorconfig', '.;')) == 0 | if exists(":Sleuth") | Sleuth | endif | endif
augroup END
