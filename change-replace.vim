" Author: markzen on #vim
" - Erase & Overwrite {{{3
"--------------------------
nnoremap  <silent>  cD              :set opfunc=EraseAndOverwrite<cr>g@
nmap      <silent>  cd              cDE
xnoremap  <silent>  <Leader>cd      :<C-u>call EraseAndOverwrite(
                                    \ visualmode(), 1)<cr>

" Erase & Replace {{{3
function! EraseAndOverwrite(type, ...) abort
  let reg_save = @@
  if a:0  " Invoked from Visual mode, use gv command.
    silent exe "norm! gvr\<Space>"
  elseif a:type == 'line'
    silent exe "norm! `[V`]r\<Space>"
  else
    silent exe "norm! `[v`]r\<Space>"
  endif
  startreplace
  let @@ = reg_save
endfun
