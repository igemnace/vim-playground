" plugin/synstack.vim

" Show syntax highlighting groups for word under cursor

" check for synstack function capability
if !exists('*synstack')
	finish
endif

" expose <plug>(SynStack)
nnoremap <plug>(SynStack) :call <sid>SynStack()<cr>

" the simplified SynStack function for word under cursor
function! <sid>SynStack()
	echo join(reverse(map(synstack(line('.'), col('.')),
				\'synIDattr(v:val, "name")')), ', ')
endfunction

" map to <c-p> if <c-p> not already mapped
" don't map if g:synstack_map is 0
if get(g:, 'synstack_map', 1) != 0 && empty(maparg('<c-p>'))
	nmap <c-p> <plug>(SynStack)
endif
