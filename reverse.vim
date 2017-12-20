function! Reverse(str) abort
  return join(reverse(split(a:str, '\zs')), '')
endfunction

function! ReverseLine() abort
  s/^.*$/\=Reverse(submatch(0))
endfunction

function! ReverseWords() abort
  s/\<\w\+\>/\=Reverse(submatch(0))/g
endfunction

function! ReverseSelected() abort
  s/\%V.*\%V./\=Reverse(submatch(0))/g
endfunction

command! -range ReverseLine <line1>,<line2>call ReverseLine()
command! -range ReverseWords <line1>,<line2>call ReverseWords()
command! -range ReverseSelected <line1>,<line2>call ReverseSelected()
