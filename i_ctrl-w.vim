" Author: hauleth on #vim
" original problem: make <C-w> delete only until _
" e.g. some_word_here<C-w> should make it some_word_
" instead of deleting the whole word

func! s:smart_delete_word() abort
    let l:iskeyword = &iskeyword

    try
        set iskeyword&vim
        set iskeyword-=_

        if col('.') + 1 == col('$')
            normal! dvb
        else
            normal! db
        endif
    finally
        let &iskeyword = l:iskeyword
    endtry
endfunc

inoremap <silent> <plug>(smart-delete-word) <C-o>:<C-u>call <SID>smart_delete_word()<CR>

imap <C-w> <plug>(smart-delete-word)
