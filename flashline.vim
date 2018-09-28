" Author: markzen on #vim
" FlashLine {{{1
" Flash current line
function! FlashLine() abort
  if !get(g:, 'flashline_hl', 0)
    hi FlashLine ctermfg=221 ctermbg=236 guifg=#ffd75f guibg=#303030
    let g:flashline_hl = 1
  endif
  hi! link CursorLine FlashLine
  hi! link CursorColumn FlashLine
  let [o_cul, o_cuc] = [&cul, &cuc]
  setl cul cuc
  redraw!
  sleep 300m
  hi! link CursorLine NONE
  hi! link CursorColumn NONE
  let [&cul, &cuc] = [o_cul, o_cuc]
  return ''
endfun

                                    " Flash curline
nnoremap  <silent>  q&              @=FlashLine()<cr> 
xnoremap  <silent>  q&              @=FlashLine()<cr> 
