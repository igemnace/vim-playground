" Author: romainl on #vim

inoremap (<Space> (<Space><Space>)<Left><Left>
inoremap (; (<CR>);<Esc>O
inoremap (, (<CR>),<Esc>O
inoremap [; [<CR>];<Esc>O
inoremap [, [<CR>],<Esc>O
inoremap {; {<CR>};<Esc>O
inoremap {, {<CR>},<Esc>O

inoremap <expr> ) getline('.')[col('.') - 1] ==# ')' ? "\<Right>" : ")"
