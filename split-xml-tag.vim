function! SplitXmlTag() abort
  keeppatterns s/\s\+\|\/\@<!\ze>/\r/g
endfunction
command! SplitXmlTag call SplitXmlTag()
