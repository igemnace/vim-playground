" Author: markzen on #vim
" Move between helptags
nnoremap <silent><buffer> zl
      \  :call search('<Bar>[^ <Bar>]\+<Bar>\<Bar>''[A-Za-z0-9_-]\{2,}''')<cr>
nnoremap <silent><buffer> zh
      \  :call search('<Bar>[^ <Bar>]\+<Bar>\<Bar>''[A-Za-z0-9_-]\{2,}''', 'b')<cr>

