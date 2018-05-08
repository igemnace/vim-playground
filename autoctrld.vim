" Author: Antony_ from #vim
" autoctrld.vim -- Automatically <C-D> as you type in the command line.

" Source this file, then try out the command line. Not bullet-proof by
" any means, just for fun. Vim isn't designed for this sort of
" thing, so don't blame me if Vim hangs or your mappings get messed up.

" * It only maps : in the current buffer for safer playing around.
" * There's a fun directory  browser with `:e<space>` then tab
"   completion, ^W, and arrow keys.
" * Sorry about all the redraws and flicker.

fun! s:getSNR()
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_')
endfun
let s:SID = "\<SNR>" . s:getSNR() . '_'

fun! s:doautoctrld(type)
    if getcmdtype() != ':' || getcmdline() =~ '^\s*$' || wildmenumode()
        call s:start()
        return
    endif
    let c = getcmdline()[-1:]
    redraw
    silent call feedkeys("\<c-r>=execute('set nomore')\<cr>" .
            \ "\<c-d>" .
            \ "\<c-r>=getcmdline()[-1:]==\"\<c-d>\"?'\<c-v>\<c-h>':''\<cr>" .
            \ "\<c-r>=execute('call " . s:SID . "start()')\<cr>", 'n')
endfun

fun! s:start()
    set more
    au! cmdlinechanged <buffer>
        \ au! cmdlinechanged <buffer> | call s:doautoctrld(expand('<afile>'))
    return ''
endfun

" So noremappings using : are protected.
" nmaps are not :-(
" I should probably handle a count.
au! cmdlineleave <buffer> au! cmdlinechanged <buffer>
nno <buffer> : :<c-u><c-r>=<SID>start()<CR>
