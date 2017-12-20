" Author: Antony_ on #vim
" :source at your own risk!

fun! Rainbow(x)
    for [group,i] in map([
        \ 'comment',
        \ 'specialkey',
        \ 'visual',
        \ 'linenr',
        \ 'normal',
        \ 'statusline',
        \ 'statuslinenc'
    \ ], {i,v -> [v,i]})
        exe 'hi ' . group . ' ctermfg=' . ((reltime()[1] - i) % 256)
    endfor
    for [group,i] in map([
        \ 'visual',
        \ 'linenr',
        \ 'normal',
        \ 'statusline',
        \ 'statuslinenc'
    \ ], {i,v -> [v,i]})
        exe 'hi ' . group . ' ctermbg=' . ((reltime()[1] - i) % 256)
    endfor
endfun
let id = timer_start(250, funcref('Rainbow'), {'repeat': -1})
finish
call timer_stop(id)
