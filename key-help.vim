" original problem: mimic emacs' C-h k where you press a key
" to look it up in :help

command! NHelpKey execute 'help' nr2char(getchar())
command! VHelpKey execute 'help v_' . nr2char(getchar())
command! IHelpKey execute 'help i_' . nr2char(getchar())
command! CHelpKey execute 'help c_' . nr2char(getchar())

nnoremap <silent> <F1> :NHelpKey<CR>
xnoremap <silent> <F1> :<C-u>VHelpKey<CR>
inoremap <silent> <F1> <C-o>:IHelpKey<CR>
cnoremap <silent> <F1> <C-u>CHelpKey<CR>
