scriptencoding utf-8
" nin_english
" Last Change:	2023 Mar 19
" Maintainer:	Shoichiro Nakanishi <sheepwing@kyudai.jp>
" License:	Mit licence

let s:save_cpo = &cpo
set cpo&vim

if exists('g:loaded_nin_english')
  finish
endif
if !exists('g:nin_english#dict_dir')
  finish
endif
let g:loaded_nin_english = 1


function! EnglishCustomDictList() abort
  for f in readdir(g:nin_english#dict_dir.'/src/')
    if f[0:6] == 'custom-'
      echo f[7:]
    endif
  endfor
endfunction

function! EnglishCustomDictEdit(fname) abort
  exec 'e '.g:nin_english#dict_dir.'/src/custom-'.a:fname
endfunction

function! EnglishCustomDictDelete(fname) abort
  call delete(g:nin_english#dict_dir.'/src/custom-'.a:fname)
endfunction

let s:float_win_exists = 0

function! NinCloseFloat() abort
  if s:float_win_exists == 1
    call nvim_win_close(g:nin_win, v:true)
    augroup nin_win
      autocmd!
    augroup END
    let s:float_win_exists = 0
  endif
endfunction

function! EnglishSearch() abort
  call NinMakeFloat(split(denops#request('ninenglish', 'hover', [g:nin_english#dict_dir]), ';'))
endfunction

function! NinMakeFloat(texts, insertmode=0) abort
  if has('nvim')
    let buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(buf, 0, -1, v:true, a:texts)
    let tmplen = 0
    let width = 0
    let height = 1
    for s in a:texts
      let tmplen = strdisplaywidth(s)
      if tmplen > width
        let width = tmplen
      endif
      let height += 1
    endfor
    let opts = {'relative': 'cursor', 'width': width,
                \'height': height, 'col': 0, 'row': 1,
                \'anchor': 'NW', 'style': 'minimal'} 
    let g:nin_win = nvim_open_win(buf, 0, opts)
    let s:float_win_exists = 1
    augroup nin_win
      autocmd!
      autocmd CursorMoved,CursorMovedI,InsertEnter,MenuPopup <buffer> call NinCloseFloat()
    augroup END
  else
    call popup_atcursor(a:texts, {})
  endif
endfunction

function! InstallEJDict() abort
  exec "!git clone https://github.com/kujirahand/ejdict ".g:nin_english#dict_dir
endfunction


function! NinEnglishHilight () abort
  sy match Number /\d\+/
  sy match Float /\dth/
  sy match Label /\u\+/
  sy match Label /\w*\u\w*/
  sy keyword Comment a the

  sy keyword Number January Jan February Feb March Mar April Apr May May June Jun July Jul
  sy keyword Number Augus Aug September Sep Sept October Oct November Nov December Dec
  sy keyword Number one two three four five six seven eight nine ten eleven twelve thirteen
  sy keyword Number fourteen fifteen sixteen seventeen eighteen nineteen twenty
  sy keyword Number thirty forty fifty sixty seventy eighty ninety hundred thousand
  sy keyword Number mili kilo mega giga

  sy case ignore
  sy match Operator /[\+\-\*]/
  sy match Float /\d*\.\d+/

  sy keyword Operator is are was were will would wish do shall should
  sy keyword Operator can be been have has either nor neither may
  sy match Label /for example\,\?/
  sy keyword Operator on of in to at above by before due goind within over both into under
  sy keyword Function when where while thus whether that if during
  sy keyword Function which with

  sy keyword Keyword too further
  sy match Operator /has been/
  sy keyword Operator but however so yet
  sy keyword Operator for as via about
  sy keyword Operator and or of because not since after
  sy keyword Operator also more less seems
  sy keyword Operator such better worse
  sy keyword Operator between
  sy keyword Operator + - % *
  sy keyword Operator than more less

  sy keyword Special significant significantly

  sy keyword Constant we you I he she they
  sy keyword Constant this it its there those

  sy keyword Comment etal
  sy match Comment /et al/

  sy match Special /\. /
  sy match Special /\,/
  sy match Special /\;/
  sy match Special /\:/
  "sy match Special /\"/
  sy keyword Operator from
  sy region String start=+"+ end=+"+
  sy region String start=+\[+ end=+\]+
  sy region String start=+(+ end=+)+
  sy region String start=+{+ end=+}+

  sy match Typedef /^\u\w*/
  sy match Typedef /\. \+\u\w*/
  sy case match
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
