" phy1729 shared this on #vim, which he took from tpope
" autocmd for dealing with swapfiles, since you only likely want them for
" modified buffers
autocmd CursorHold,BufWritePost,BufReadPost,BufLeave *
      \ if isdirectory(expand("<amatch>:h")) |
      \ let &swapfile = &modified |
      \ endif
