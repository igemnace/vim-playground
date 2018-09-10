" original problem: highlight TODO in html comments
" place in ~/.vim/after/syntax/html.vim

syn keyword htmlCommentTodo TODO FIXME XXX TBD contained

if exists("html_wrong_comments")
  syn region htmlComment start=+<!--+ end=+--\s*>+ contains=@Spell,htmlCommentTodo
else
  syn region htmlComment start=+<!+ end=+>+ contains=htmlCommentPart,htmlCommentError,@Spell,htmlCommentTodo
  syn region htmlCommentPart  contained start=+--+      end=+--\s*+  contains=@htmlPreProc,@Spell,htmlCommentTodo
endif

hi def link htmlCommentTodo Todo
