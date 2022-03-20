" Author: romainl on #vim
" return a representation of the selected text
" suitable for use as a search pattern
function! custom#visual#GetSelection(escape)
    let old_reg = getreg("v")
    normal! gv"vy
    let raw_search = getreg("v")
    call setreg("v", old_reg)
    if a:escape
        return substitute(escape(raw_search, '\/.*$^~[]'), "\n", '\\n', "g")
    endif
    return raw_search
endfunction
