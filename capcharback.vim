" original problem: someone in #vim asked for a way to quickly make a previous
" char caps, in the use case where he forgot to press shift when typing in
" insert mode
function! CapCharBack()
  let char = nr2char(getchar())
  echom char
  let save_pos = getpos('.')
  execute 'normal! F' . char . '~'
  call setpos('.', save_pos)
endfunction

nnoremap <Plug>CapCharBack :call CapCharBack()<CR>

" map whatever you want to <Plug>CapCharBack
nmap <silent> <leader>c <Plug>CapCharBack
