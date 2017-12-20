" Original problem: replace ## with #, but only if within <>
" there can be a variable number of #s within <>

function! RemoveDoubleSharp() abort
  return substitute(submatch(0), '##', '#', 'g')
endfunction
