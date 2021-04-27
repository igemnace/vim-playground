" Author: Nova Senco
" Last Change: 27 April 2021

let s:atts = ['bold', 'italic', 'reverse', 'inverse', 'standout', 'underline', 'undercurl', 'strikethrough']
let s:colors = ['ctermfg', 'ctermbg', 'guifg', 'guibg']

" echo hl chain (and resolutions) synstack with color
" also, print the attributes for final attribute
function! synstackecho#echo()
  let first = 2
  unsilent echon "\r"
  for id in reverse(synstack(line('.'), col('.')))
    if first > 1
      let first = 1
    else
      unsilent echon ' <- '
    endif
    let syn = synIDattr(id, 'name')
    let transId = synIDtrans(id)
    execute 'echohl' syn
    unsilent echon syn
    if id !=# transId
      unsilent echon ' [' synIDattr(transId, 'name') ']'
    endif
    if first
      let catts = join(filter(map(s:atts[:], { _,att -> synIDattr(transId, att, 'cterm') ? att : '' }), { _,s -> !empty(s) }), ',')
      let gatts = join(filter(map(s:atts[:], { _,att -> synIDattr(transId, att, 'gui') ? att : '' }), { _,s -> !empty(s) }), ',')
      let out = ['cterm='..catts, 'gui='..gatts]
      call extend(out, map(s:colors[:], { _,col -> col..'='..synIDattr(transId, col[-2:], col[:-3]) }))
      " unsilent echon transId out filter(out, { _,att -> att !~ '=$' })
      unsilent echon ' <'..join(filter(out, { _,att -> att !~ '=$' }))..'> '
      let first = 0
    endif
    echohl NONE
  endfor
  echohl NONE
  if first
    unsilent echon 'No syntax groups under cursor'
  endif
endfunction
