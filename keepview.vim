function! KeepView(command) abort
  let l:view = winsaveview()
  execute a:command
  call winrestview(l:view)
endfunction

command! -nargs=+ -complete=command KeepView call KeepView(<q-args>)
