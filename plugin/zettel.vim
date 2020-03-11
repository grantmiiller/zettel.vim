
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
    execute "normal! i# " . a:1
  endif
endfunction

function! s:ZettelFindFiles(query)
  " The base of our command
  let l:cmd = 'zettel find "' . a:query . '"'
  let l:files = system(l:cmd)
  return split(l:files, '\n')
endfunction

function! ZettelFindFile(...)
  if len(a:000) > 0
    let l:id = a:1
  else
    let l:id = expand("<cword>") 
  endif

  let l:files = s:ZettelFindFiles(l:id)
  if len(l:files) == 0
    echom "Zettel: Could not find files matching the search."
  else
    let l:note_loc = substitute(l:files[0], '\n', '', 'g')
    execute "e " . l:note_loc
  endif

endfunction


