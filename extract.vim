" original problem: clean up my colorscheme
" not all hi statements have complete cterm, ctermfg, etc. keys
" I want to resolve that without losing the already-existing keys

" solution: put cursor on hi statement, call CreateHiString(ExtractHiInfo())
" this will generate the highlight definition with complete keys
"
" for example, to mass replace, use
" :{range}s/hi \w\+ \zs.*/\=CreateHiString(ExtractHiInfo())/

let g:guicolorlist = [
      \ '#2d2d2d',
      \ '#f2777a',
      \ '#99cc99',
      \ '#ffcc66',
      \ '#6699cc',
      \ '#cc99cc',
      \ '#66cccc',
      \ '#d3d0c8',
      \ '#747369',
      \ '#f2777a',
      \ '#99cc99',
      \ '#ffcc66',
      \ '#6699cc',
      \ '#cc99cc',
      \ '#66cccc',
      \ '#d3d0c8',
      \ ]

function! GetGuiColor(term_color) abort
  if a:term_color == 237
    return '#303030'
  endif

  if a:term_color ==# 'NONE'
    return 'NONE'
  endif

  return get(g:guicolorlist, a:term_color, 'UNKNOWN')
endfunction

function! ExtractColorNo(extracted) abort
  return split(a:extracted, '=')[1]
endfunction

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

function! InferGuiString(hi_info) abort
  let l:str = ''
  for hi_key in ['cterm', 'ctermfg', 'ctermbg']
    let l:str .= ' ' . a:hi_info[hi_key]
  endfor
  let gui = ExtractColorNo(a:hi_info['cterm'])
  let l:str .= ' gui=' . gui
  for suffix in ['fg', 'bg']
    let cterm_key = 'cterm' . suffix
    let gui_color = GetGuiColor(ExtractColorNo(a:hi_info[cterm_key]))
    let gui_key = 'gui' . suffix
    let l:str .= ' ' . gui_key . '=' . gui_color
  endfor
  let l:str .= ' guisp=NONE'
  return strcharpart(l:str, 1)
endfunction

command! -range InferGuiString <line1>,<line2>s/highlight\s\+\w\+\s\+\zs.*/\=InferGuiString(ExtractHiInfo())/ | <line1>,<line2>!column -t -o ' '
