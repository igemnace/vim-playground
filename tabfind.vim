" Author: novasenco on #vim
" Usage:
"   :TabF! bar  - go to first tab w buffer named bar
"               - prefer buffer named only 'bar'
"               - secondarily find *unique* buffer partially matching 'bar'
"
"   :TabF bar   - same as above except if multiple tabs match, ask user which tab

" To change filter function, use let g:tabfind_filter = 'TabFindFilter'
"   (but change 'TabFindFilter' to your function, obviously)
" then return a number (the desired tabpage number) from your function
" the function takes two arguments: the name passed and the list of tab pages
" return 0 to abort

" default filter function
function! TabFindFilter(name, tabs) abort
    echohl Question
    let n = str2nr(input('Select tab for  '.a:name.'  '.join(a:tabs, ", ").' -> '))
    echohl NONE
    if index(a:tabs, n) == -1
        return 0
    endif
    return n
endfunction

" function that goes to tabpage with buffer `name`
function! TabFind(name, first) abort
    let tabs = []
    let partabs = []
    let _name = bufname(a:name)
    for tn in range(1, tabpagenr('$'))
        for bn in tabpagebuflist(tn)
            let cname = bufname(bn)
            " since :TabFind has buffer name completion, let's use ==
            " but let's use a:name and _name just in case partial name passed
            if cname == a:name
                call add(tabs, tn)
            elseif cname == _name
                call add(partabs, tn)
            endif
        endfor
    endfor
    let tabs += partabs
    if empty(tabs)
        echohl ErrorMsg
        unsilent echom 'TabFind: No buffers named' a:name
        echohl NONE
        return
    endif
    if a:first || len(tabs) == 1
        execute tabs[0] 'tabnext'
        return
    endif
    let tf = get(g:, 'tabfind_filter')
    if tf is 0
        let tf = 'TabFindFilter'
    endif
    let tn = funcref(tf)(a:name, tabs)
    if tn isnot 0
        execute tn 'tabnext'
    endif
endfunction

command! -bang -nargs=1 -complete=buffer TabFind call TabFind(<q-args>, <bang>0)
