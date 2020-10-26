if exists('g:loaded_fin_quickfix')
  finish
endif
let g:loaded_fin_quickfix = 1

function! s:quickfix() abort
  enew
  nnoremap <buffer><nowait><silent> <CR> :<C-u>call <SID>quickfix_jump()<CR>
  augroup my_fin_quickfix
    autocmd! * <buffer>
    autocmd BufReadCmd <buffer> call s:quickfix_cmd()
  augroup END
  setlocal buftype=nofile bufhidden=wipe
  file quickfix://
  edit
endfunction

function! s:quickfix_cmd() abort
  let b:items = getqflist()
  let lines = map(
        \ copy(b:items),
        \ { _, v -> empty(v.text) ? bufname(v.bufnr) : v.text },
        \)
  call map(lines, 'fnamemodify(simplify(v:val), ":~:.")')
  call setline(1, lines)
endfunction

function! s:quickfix_jump() abort
  let item = b:items[line('.') - 1]
  execute printf('%dbuffer', item.bufnr)
  call cursor([item.lnum, item.col, 0])
endfunction

command! FinQf botright call s:quickfix() | Fin -after=\<CR> -cancel=\<C-o>
