function! Buffers() abort
  let buffers = map(getbufinfo(), 'v:val.bufnr . "\t" . v:val.name')
  let choice = FZY(buffers)

  execute "buffer" split(choice, '\t')[0]
endfunction

function! CallCommand()
  command
endfunction

function! Commands() abort
  let commands = ''
  redir => commands
  silent call CallCommand()
  redir END
  let choice = FZY(commands)
endfunction

function! Files() abort
  let choice = FZYExternal('fd')

  execute "edit" choice
endfunction

function! Lines() abort
  let choice = FZYExternal('rg --vimgrep --column "^.*$"')

  let [filename, line] = split(choice, ':')[:1]
  
  execute "edit +".line filename
endfunction

function! FZY(input) abort
  try
    let choice = system('fzy', a:input)
  finally
    redraw!
  endtry

  return choice
endfunction

function! FZYExternal(cmd) abort
  try
    let choice = system(a:cmd . ' | fzy')
  finally
    redraw!
  endtry

  return choice
endfunction
