" Original problem: highlighted text inserted during Insert mode

function! s:AddHighlight() abort
  let [_, lnum, col; rest] = getpos('.')
  let w:insert_hl = matchadd('Error', '\%'.col.'c\%'.lnum.'l\_.*\%#')
endfunction

function! s:DeleteHighlight() abort
  if exists('w:insert_hl')
      call matchdelete(w:insert_hl)
  endif
endfunction

augroup InsertHL
  autocmd!
  autocmd InsertEnter * call s:AddHighlight()
  autocmd InsertLeave * call s:DeleteHighlight()
augroup END
