" Author: novum on #vim, aka m1n aka dylnmc

" global usage: use these maps/commands anywhere
"   gf              if <cfile> is a directory, open lsbuffer
"   <leader>ls      opens the lsbuffer (if already open keep pwd the same, otherwise use pwd of current buffer)
"   <leader>lS      opens the lsbuffer and uses pwd of current buffer
"   :LsHidden 1     show dot files
"   :LsHidden 0     hide dot files
"   :LsHidden!      toggle showing dot files
"   :LsHidden       prints out state
"   <leader>lh      same as :LsHidden! for convenience
"   <leader>lc      lcd to %:p:h (directory of buffer); await return so user can append ".." for example
"
" lsbuffer usage: use these mappings inside the lsbuffer buffer
"   gf      enter the directory or open the file
"   <cr>    same as gf
"   l       same as gf
"   <bs>    lcd ..
"   h       same as <bs>
"   -       lcd to previous directory
"
" notes:
"   don't forget you can use <c-w>f to open the file in a split
"   you can :lcd to anywhere in the lsbuffer, and it will re-ls the new directory
nnoremap <silent> <expr> gf isdirectory(expand('<cfile>')) ? 'call <sid>ls(expand(''<cfile>'')<cr>' : 'gf'
nnoremap <silent> <leader>ls :call <sid>ls()<cr>
nnoremap <silent> <leader>lS :call <sid>ls(getcwd())<cr>
command! -bar -bang -nargs=? LsHidden let s:lshidden = (<bang>s:lshidden || strlen(<q-args>) && str2nr(<q-args>)) | unsilent echon (s:lshidden ? 'dot files are SHOWN' : 'dot files are HIDDEN') | if (<bang>0 || ! empty(<q-args>)) | call <sid>ls() | endif
nnoremap <silent> <leader>lh :LsHidden!<cr>
nnoremap <leader>lc :lcd %:p:h/

let s:bufnr = get(s:, 'bufnr', -1)
let s:lshidden = get(s:, 'lshidden', 0)
if ! exists('s:linenrs')
	let s:linenrs = {}
endif
if ! exists('s:prevdir')
	let s:prevdir = ''
endif
if ! exists('s:dirnochange')
	let s:dirnochange = 0
endif

function! DebugLsLinenrs()
	echo s:linenrs
endfunction

function! s:savelinenr(pwd, ...)
	if s:bufnr ==# -1
		return
	endif
	let s:linenrs[a:pwd] = a:0 ==# 0 ? getbufinfo(s:bufnr)[0].lnum : a:1
endfunction
function! s:cdprev()
	if empty(s:prevdir)
		return
	endif
	call <sid>ls(s:prevdir)
endfunction
function! s:ls(...)
	let s:prevdir = getcwd()
	if s:bufnr >= 0
		if ! (expand('%') ==# 'lsbuffer' && &filetype ==# 'lsbuffer')
			let l:nr = -1
			for l:n in range(1, winnr('$'))
				if bufname(winbufnr(l:n)) ==# 'lsbuffer' && getwinvar(l:n, '&filetype') ==# 'lsbuffer'
					let l:nr = l:n
					break
				endif
			endfor
			if l:nr >= 0
				execute l:nr.'wincmd w'
			else
				sbuffer lsbuffer
			endif
		endif
	else
		new
		setlocal buftype=nofile nobuflisted filetype=lsbuffer
		file lsbuffer
		let s:bufnr = bufnr('')
		nnoremap <silent> <expr> <buffer> gf isdirectory(expand('<cfile>')) ? ':call <sid>savelinenr(getcwd(), line(''.''))<bar>call <sid>ls(expand(''<cfile>''))<cr>' : 'gf'
		nmap <silent> <buffer> <cr> gf
		nmap <silent> <buffer> l gf
		nmap <silent> <buffer> <bs> :call <sid>savelinenr(getcwd(), line('.'))<bar>call <sid>ls('..')<cr>
		nmap <silent> <buffer> h <bs>
		nnoremap <silent> <buffer> - :call <sid>savelinenr(getcwd(), line('.'))<bar>call <sid>cdprev()<cr>
		augroup LsBuffer
			autocmd! * <buffer>
			autocmd CursorMoved <buffer> call <sid>savelinenr(getcwd(), line('.'))
			autocmd DirChanged <buffer> if s:dirnochange | let s:dirnochange = 0 | else | call <sid>ls() | endif
		augroup end
	endif
	setlocal noreadonly modifiable
	if a:0 > 0 && isdirectory(a:1)
		let s:dirnochange = 1
		execute 'lcd '.a:1
	endif
	silent %delete
	call append(0, map(sort(extend(split(glob('*'), "\n"), s:lshidden ? split(glob('.*'), "\n") : ['.', '..'])), { _,fn -> isdirectory(fn) ? fn.'/' : fn }))
	delete
	let l:pwd = getcwd()
	if ! (empty(s:prevdir) || search('\m^\V'.escape(fnamemodify(s:prevdir, ':t'), '\/').'\m\/\?$'))
		execute get(s:linenrs, l:pwd, 3)
	endif
	call <sid>savelinenr(l:pwd)
	setl readonly nomodifiable
	let s:bufnr = bufnr('')
endfunction
