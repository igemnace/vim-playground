"  This program is free software; you can redistribute it and/or modify
"  it under the terms of the GNU General Public License as published by
"  the Free Software Foundation; either version 2 of the License, or
"  (at your option) any later version.
"
"  This program is distributed in the hope that it will be useful,
"  but WITHOUT ANY WARRANTY; without even the implied warranty of
"  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
"  GNU Library General Public License for more details.
"
"  You should have received a copy of the GNU General Public License
"  along with this program; if not, write to the Free Software
"  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
"
"  (C) Paul Evans, 2005 -- leonerd@leonerd.org.uk

" This autocommand/function allows extra .vimrc files to be placed on the 
" filesystem, which will be read when new files are created, or files are
" read. The path to the file is traced backward to the root, and any files
" found there are sourced. Files closer to the root are sourced first, so
" that more local files take precidence. 
"
" Compare to webservers using .htaccess files
"
" The searching stops if it encounters the user's home directory.
"
" Any local .vimrc files should typically use setlocal, rather than set, so
" as not to upset global settings.

" As an extra security feature, any files that are found, that aren't inside
" the user's home directory, will not be loaded. This prevents maliscious 
" users from constructing .vimrc files that other users could source, by
" making them view files.

if ( exists("*My_search_additional_rc_file") )
  finish
endif

au BufRead,BufNewFile *		call My_search_additional_rc_file(expand("<afile>:p"))

function My_search_additional_rc_file(filename)
  " Don't do this for netrw because it would suck
  if ( a:filename =~ "^scp:" || a:filename =~ "^http:" || a:filename =~ "^ftp:" )
    return 1
  endif

  call My_search_additional_rc(fnamemodify(a:filename, ":h"))
endf

function My_search_additional_rc(dirname)
  " Don't do this dir. if it's the system root
  if ( a:dirname == "/" || a:dirname == "" ) 
    return 1
  endif
  " Don't do this dir if it's my home
  if ( a:dirname == expand("~") || a:dirname == g:userHomeDir )
    return 1
  endif
  
  " Recurse into parent first, so any files here take precidence over settings
  " placed higher up.
  let parent = fnamemodify(a:dirname, ":h")
  if ! My_search_additional_rc(parent)
    return 0
  endif

  let thisrc = a:dirname . "/.vimrc"
  if ( filereadable( thisrc ) )
    if ( Fileismine( thisrc ) != 1 )
      echo "Not sourcing from " . thisrc . " for security reasons"
      return 0
    endif

    execute "source " . thisrc

    if exists("g:additionalrc_stop")
      return 0
    endif
  endif

  return 1
endfunction

" Only evaluate it once since it's going to be constant
let g:userHomeDir = expand("$HOME")
