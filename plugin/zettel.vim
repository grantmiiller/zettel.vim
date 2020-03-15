let s:id_len = 14

" Gets the Zettel ID of current file
function! ZettelGetId(...)
  " If we have a passed arg, use it
  if len(a:000) > 0
    let l:filename = a:1
  else
    " Expand the name of the current file
    let l:filename = expand("%")
  endif

  " This runs the zettel command, and removes the newlines, which
  " become null bytes for vim
  let l:cmd = 'zettel id ' . l:filename
  let l:id = substitute(system(l:cmd), '\n', '', 'g')

  " Set the `a` register with the id
  let @a = l:id
endfunction

" Creates a new Zettel note
function! ZettelNew(...)
  " The base of our command
  let l:cmd = 'zettel -f new'
  " If we have any passed parameters, add them to the command
  if len(a:000) > 0
    let l:cmd = l:cmd . ' ' . a:1
  endif
  " This runs the zettel command, and removes the newlines, which
  " become null bytes for vim
  let l:note_loc = substitute(system(l:cmd), '\n', '', 'g')

  call ZettelGetId(note_loc)

  " Open the new note in a new buffer
  execute "e " . l:note_loc

  if len(a:000) > 0
    " insert the title, then escape to normal mode and go to next line and
    " into insert mode
    execute "normal! i# " . a:1 . "\<esc>oi"
  else
    execute "normal! i"
  endif
endfunction

" Helper function to find files
function! s:ZettelFindFiles(query)
  " The base of our command
  let l:cmd = 'zettel find "' . a:query . '"'
  let l:files = system(l:cmd)
  return split(l:files, '\n')
endfunction

" Opens the first file it finds either using the <cword> under the cursor or
" passed argument
function! ZettelFindFile(...)
  if len(a:000) > 0
    let l:id = a:1
  else
    let l:id = expand("<cword>") 
  endif

  let l:files = s:ZettelFindFiles(l:id)
  if len(l:files) == 0
    echom "WARNING: Zettel: Could not find files matching the search."
  else
    let l:note_loc = substitute(l:files[0], '\n', '', 'g')
    execute "e " . l:note_loc
  endif

endfunction

" Pastes a link to another Zettel note using the passed parameter or what is
" the `a` register
function! ZettelPasteLink(...)
  if len(a:000) > 0
    let l:id = a:1
  else
    let l:id = @a
  end

  if strlen(l:id) != s:id_len
    echom "WARNING: Incorrect value in buffer `a`"
    return -1
  endif

  let l:files = s:ZettelFindFiles(l:id)

  if len(l:files) == 0
    echom "WARNING: Zettel: Could not find files matching the search."
  else
    let l:note_loc = substitute(l:files[0], '\n', '', 'g')
    let l:note_list = split(l:note_loc, '/')
    let l:name = l:note_list[len(l:note_list) - 1]
    if strlen(l:name) == 17
      execute "normal! i[[" . l:id . "]]"
    else
      " Tog rab the name, we need to grab only part of the string, which is
      " the id plus a space (15) and not including the file extension .md(3)
      let l:end = strlen(l:name) - (s:id_len + 1) - 3
      let l:note_name = strpart(l:name, s:id_len + 1, l:end)
      execute "normal! i[[" . @a . "]] " . l:note_name
    endif
  endif
endfunction
