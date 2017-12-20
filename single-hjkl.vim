function! AllowSingle(key) abort
  if exists('g:single_' . a:key)
    return '\<nop>'
  else
    execute 'let g:single_' . a:key '= 1'
    return a:key
  endif
endfunction

function! ClearSingle() abort
  for l:key in ['h', 'j', 'k', 'l']
    if exists('g:single_' . l:key)
      execute 'unlet g:single_' . l:key
    endif
  endfor
endfunction

set updatetime=1000
nnoremap <expr> h v:count ? 'h' : AllowSingle('h')
nnoremap <expr> j v:count ? 'j' : AllowSingle('j')
nnoremap <expr> k v:count ? 'k' : AllowSingle('k')
nnoremap <expr> l v:count ? 'l' : AllowSingle('l')

augroup AllowSingle
  autocmd!
  autocmd CursorHold * call ClearSingle()
augroup END
