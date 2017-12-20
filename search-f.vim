" original problem: make f find chars even on multiple lines

function! SearchF(pattern, ...) abort
  let g:f_char = a:pattern
  let g:f_direction = get(a:, 1, '')

  call search('\V'.g:f_char, g:f_direction)
endfunction

function! SearchRepeat(...) abort
  if !exists('g:f_char') || !exists('g:f_direction')
    return
  endif

  if a:0 > 0 && a:1 =~? 'b'
    let l:direction = g:f_direction =~? 'b' ? '' : 'b'
  else
    let l:direction = g:f_direction
  endif

  call search('\V'.g:f_char, l:direction)
endfunction

" bonus: using nr2char(getchar()).nr2char(getchar()) gives you a ghetto sneak!
nnoremap <silent> f :call SearchF(nr2char(getchar()))<CR>
nnoremap <silent> F :call SearchF(nr2char(getchar()), 'b')<CR>
nnoremap <silent> ; :call SearchRepeat()<CR>
nnoremap <silent> , :call SearchRepeat('b')<CR>
