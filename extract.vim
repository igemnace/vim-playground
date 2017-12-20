" original problem: clean up my colorscheme
" not all hi statements have complete cterm, ctermfg, etc. keys
" I want to resolve that without losing the already-existing keys

" solution: put cursor on hi statement, call CreateHiString(ExtractHiInfo())
" this will generate the highlight definition with complete keys
"
" for example, to mass replace, use
" :{range}s/hi \w\+ \zs.*/\=CreateHiString(ExtractHiInfo())/

function! Extract(pattern) abort
  if getline('.') =~? a:pattern . '='
    normal! 0
    call search(a:pattern . '=', 'c', '.')
    normal! "ayE
    let extracted = @a
  else
    let extracted = a:pattern . '=NONE'
  endif

  return extracted
endfunction

function! ExtractHiInfo() abort
  let hi_info = {}
  for hi_key in ['cterm', 'ctermfg', 'ctermbg', 'gui', 'guifg', 'guibg', 'guisp']
    let hi_info[hi_key] = Extract(hi_key)
  endfor
  return hi_info
endfunction

function! CreateHiString(hi_info) abort
  let l:str = ''
  for hi_key in ['cterm', 'ctermfg', 'ctermbg', 'gui', 'guifg', 'guibg', 'guisp']
    let l:str .= ' ' . a:hi_info[hi_key]
  endfor
  return strcharpart(l:str, 1)
endfunction
