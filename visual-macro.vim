" now part of vim-config repo

function! s:VisualMacro() abort
  if mode() ==# 'V'
    let l:register = nr2char(getchar())
    return ':normal! @' . l:register . "\<CR>"
  else
    return '@'
  endif
endfunction

xnoremap <expr> @ s:VisualMacro()
