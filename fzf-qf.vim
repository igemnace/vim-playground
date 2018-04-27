" original problem: use FZF to go through quickfix and filter items
function! FilterQf() abort
  let source = map(getqflist(), {idx, val -> idx . ':'
    \ . bufname(val.bufnr) . ': ' . val.text})

  let opts = {'source': source, 'options': '--multi'}
  function! opts.sink(lines)
    let qflist = getqflist()
    let newlist = []
    for line in a:lines
      let [idx; rest] = split(line, ':')
      call add(newlist, qflist[idx])
    endfor
    call setqflist(newlist)
  endfunction
  let opts['sink*'] = remove(opts, 'sink')

  call fzf#run(fzf#wrap('qflist', opts))
endfunction

" Author: markzen on #vim
" original problem: use FZF to open a quickfix entry
command! FZFQFiles call fzf#run({
      \  'source':  uniq(map(getqflist(), {k, v -> bufname(v.bufnr)})),
      \  'sink':    'e',
      \  'options': '-m -x +s',
      \  'down':    '40%'})
