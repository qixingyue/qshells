" Version:     1.13.2, for Vim 6.3+
if exists("loaded_matchit") || &cp
  finish
endif
let loaded_matchit = 1
let s:last_mps = ""
let s:last_words = ":"
let s:save_cpo = &cpo
set cpo&vim
nnoremap <silent> %  :<C-U>call <SID>Match_wrapper('',1,'n') <CR>
nnoremap <silent> g% :<C-U>call <SID>Match_wrapper('',0,'n') <CR>
vnoremap <silent> %  :<C-U>call <SID>Match_wrapper('',1,'v') <CR>m'gv``
vnoremap <silent> g% :<C-U>call <SID>Match_wrapper('',0,'v') <CR>m'gv``
onoremap <silent> %  v:<C-U>call <SID>Match_wrapper('',1,'o') <CR>
onoremap <silent> g% v:<C-U>call <SID>Match_wrapper('',0,'o') <CR>
nnoremap <silent> [% :<C-U>call <SID>MultiMatch("bW", "n") <CR>
nnoremap <silent> ]% :<C-U>call <SID>MultiMatch("W",  "n") <CR>
vmap [% <Esc>[%m'gv``
vmap ]% <Esc>]%m'gv``
onoremap <silent> [% v:<C-U>call <SID>MultiMatch("bW", "o") <CR>
onoremap <silent> ]% v:<C-U>call <SID>MultiMatch("W",  "o") <CR>
vmap a% <Esc>[%v]%
let s:notslash = '\\\@<!\%(\\\\\)*'
function! s:Match_wrapper(word, forward, mode) range
  let restore_options = (&ic ? " " : " no") . "ignorecase"
  if exists("b:match_ignorecase")
    let &ignorecase = b:match_ignorecase
  endif
  let restore_options = " ve=" . &ve . restore_options
  set ve=
  if a:mode == "v"
    execute "normal! gv\<Esc>"
  endif
  let startline = line(".")
  let startcol = col(".")
  if v:count
    exe "normal! " . v:count . "%"
    return s:CleanUp(restore_options, a:mode, startline, startcol)
  end
  if !exists("b:match_words") || b:match_words == ""
    let match_words = ""
  elseif b:match_words =~ ":"
    let match_words = b:match_words
  else
    execute "let match_words =" b:match_words
  endif
  if (match_words != s:last_words) || (&mps != s:last_mps) ||
    \ exists("b:match_debug")
    let s:last_words = match_words
    let s:last_mps = &mps
    let default = escape(&mps, '[$^.*~\\/?]') . (strlen(&mps) ? "," : "") .
      \ '\/\*:\*\/,#if\%(def\)\=:#else\>:#elif\>:#endif\>'
    let match_words = match_words . (strlen(match_words) ? "," : "") . default
    if match_words !~ s:notslash . '\\\d'
      let s:do_BR = 0
      let s:pat = match_words
    else
      let s:do_BR = 1
      let s:pat = s:ParseWords(match_words)
    endif
    let s:all = substitute(s:pat, s:notslash . '\zs[,:]\+', '\\|', 'g')
    let s:all = '\%(' . s:all . '\)'
    if exists("b:match_debug")
      let b:match_pat = s:pat
    endif
  endif
  let matchline = getline(startline)
  if a:word != ''
    if a:word !~ s:all
      echohl WarningMsg|echo 'Missing rule for word:"'.a:word.'"'|echohl NONE
      return s:CleanUp(restore_options, a:mode, startline, startcol)
    endif
    let matchline = a:word
    let curcol = 0
    let prefix = '^\%('
    let suffix = '\)$'
  else	" Find the match that ends on or after the cursor and set curcol.
    let regexp = s:Wholematch(matchline, s:all, startcol-1)
    let curcol = match(matchline, regexp)
    if curcol == -1
      return s:CleanUp(restore_options, a:mode, startline, startcol)
    endif
    let endcol = matchend(matchline, regexp)
    let suf = strlen(matchline) - endcol
    let prefix = (curcol ? '^.*\%'  . (curcol + 1) . 'c\%(' : '^\%(')
    let suffix = (suf ? '\)\%' . (endcol + 1) . 'c.*$'  : '\)$')
  endif
  if exists("b:match_debug")
    let b:match_match = matchstr(matchline, regexp)
    let b:match_col = curcol+1
  endif
  let patBR = substitute(match_words.',',
    \ s:notslash.'\zs[,:]*,[,:]*', ',', 'g')
  let patBR = substitute(patBR, s:notslash.'\zs:\{2,}', ':', 'g')
  let group = s:Choose(s:pat, matchline, ",", ":", prefix, suffix, patBR)
  let i = matchend(group, s:notslash . ",")
  let groupBR = strpart(group, i)
  let group = strpart(group, 0, i-1)
  if s:do_BR " Do the hard part:  resolve those backrefs!
    let group = s:InsertRefs(groupBR, prefix, group, suffix, matchline)
  endif
  if exists("b:match_debug")
    let b:match_wholeBR = groupBR
    let i = matchend(groupBR, s:notslash . ":")
    let b:match_iniBR = strpart(groupBR, 0, i-1)
  endif
  let i = matchend(group, s:notslash . ":")
  let j = matchend(group, '.*' . s:notslash . ":")
  let ini = strpart(group, 0, i-1)
  let mid = substitute(strpart(group, i,j-i-1), s:notslash.'\zs:', '\\|', 'g')
  let fin = strpart(group, j)
  let ini = substitute(ini, s:notslash . '\zs\\\(:\|,\)', '\1', 'g')
  let mid = substitute(mid, s:notslash . '\zs\\\(:\|,\)', '\1', 'g')
  let fin = substitute(fin, s:notslash . '\zs\\\(:\|,\)', '\1', 'g')
  let ini = substitute(ini, s:notslash . '\zs\\(', '\\%(', 'g')
  let mid = substitute(mid, s:notslash . '\zs\\(', '\\%(', 'g')
  let fin = substitute(fin, s:notslash . '\zs\\(', '\\%(', 'g')
  if a:forward && matchline =~ prefix . fin . suffix
    \ || !a:forward && matchline =~ prefix . ini . suffix
    let mid = ""
  endif
  if a:forward && matchline =~ prefix . fin . suffix
    \ || !a:forward && matchline !~ prefix . ini . suffix
    let flag = "bW"
  else
    let flag = "W"
  endif
  if exists("b:match_skip")
    let skip = b:match_skip
  elseif exists("b:match_comment") " backwards compatibility and testing!
    let skip = "r:" . b:match_comment
  else
    let skip = 's:comment\|string'
  endif
  let skip = s:ParseSkip(skip)
  if exists("b:match_debug")
    let b:match_ini = ini
    let b:match_tail = (strlen(mid) ? mid.'\|' : '') . fin
  endif
  let restore_cursor = virtcol(".") . "|"
  normal! g0
  let restore_cursor = line(".") . "G" .  virtcol(".") . "|zs" . restore_cursor
  normal! H
  let restore_cursor = "normal!" . line(".") . "Gzt" . restore_cursor
  execute restore_cursor
  call cursor(0, curcol + 1)
  if skip =~ 'synID' && !(has("syntax") && exists("g:syntax_on"))
    let skip = "0"
  else
    execute "if " . skip . "| let skip = '0' | endif"
  endif
  let sp_return = searchpair(ini, mid, fin, flag, skip)
  let final_position = "call cursor(" . line(".") . "," . col(".") . ")"
  execute restore_cursor
  normal! m'
  if sp_return > 0
    execute final_position
  endif
  return s:CleanUp(restore_options, a:mode, startline, startcol, mid.'\|'.fin)
endfun
fun! s:CleanUp(options, mode, startline, startcol, ...)
  execute "set" a:options
  if a:mode != "o"
    if &foldopen =~ "percent"
      normal! zv
    endif
  elseif (a:startline < line(".")) ||
	\ (a:startline == line(".") && a:startcol < col("."))
    if a:0
      let matchline = getline(".")
      let currcol = col(".")
      let regexp = s:Wholematch(matchline, a:1, currcol-1)
      let endcol = matchend(matchline, regexp)
      if endcol > currcol  " This is NOT off by one!
	execute "normal!" . (endcol - currcol) . "l"
      endif
    endif " a:0
  endif " a:mode != "o" && etc.
  return 0
endfun
fun! s:InsertRefs(groupBR, prefix, group, suffix, matchline)
  if a:matchline !~ a:prefix .
    \ substitute(a:group, s:notslash . '\zs:', '\\|', 'g') . a:suffix
    return a:group
  endif
  let i = matchend(a:groupBR, s:notslash . ':')
  let ini = strpart(a:groupBR, 0, i-1)
  let tailBR = strpart(a:groupBR, i)
  let word = s:Choose(a:group, a:matchline, ":", "", a:prefix, a:suffix,
    \ a:groupBR)
  let i = matchend(word, s:notslash . ":")
  let wordBR = strpart(word, i)
  let word = strpart(word, 0, i-1)
  if wordBR != ini
    let table = s:Resolve(ini, wordBR, "table")
  else
    let table = ""
    let d = 0
    while d < 10
      if tailBR =~ s:notslash . '\\' . d
	let table = table . d
      else
	let table = table . "-"
      endif
      let d = d + 1
    endwhile
  endif
  let d = 9
  while d
    if table[d] != "-"
      let backref = substitute(a:matchline, a:prefix.word.a:suffix,
	\ '\'.table[d], "")
      let backref = escape(backref, '*,:')
      execute s:Ref(ini, d, "start", "len")
      let ini = strpart(ini, 0, start) . backref . strpart(ini, start+len)
      let tailBR = substitute(tailBR, s:notslash . '\zs\\' . d,
	\ escape(backref, '\\'), 'g')
    endif
    let d = d-1
  endwhile
  if exists("b:match_debug")
    if s:do_BR
      let b:match_table = table
      let b:match_word = word
    else
      let b:match_table = ""
      let b:match_word = ""
    endif
  endif
  return ini . ":" . tailBR
endfun
fun! s:ParseWords(groups)
  let groups = substitute(a:groups.",", s:notslash.'\zs[,:]*,[,:]*', ',', 'g')
  let groups = substitute(groups, s:notslash . '\zs:\{2,}', ':', 'g')
  let parsed = ""
  while groups =~ '[^,:]'
    let i = matchend(groups, s:notslash . ':')
    let j = matchend(groups, s:notslash . ',')
    let ini = strpart(groups, 0, i-1)
    let tail = strpart(groups, i, j-i-1) . ":"
    let groups = strpart(groups, j)
    let parsed = parsed . ini
    let i = matchend(tail, s:notslash . ':')
    while i != -1
      let word = strpart(tail, 0, i-1)
      let tail = strpart(tail, i)
      let i = matchend(tail, s:notslash . ':')
      let parsed = parsed . ":" . s:Resolve(ini, word, "word")
    endwhile " Now, tail has been used up.
    let parsed = parsed . ","
  endwhile " groups =~ '[^,:]'
  let parsed = substitute(parsed, ',$', '', '')
  return parsed
endfun
fun! s:Wholematch(string, pat, start)
  let group = '\%(' . a:pat . '\)'
  let prefix = (a:start ? '\(^.*\%<' . (a:start + 2) . 'c\)\zs' : '^')
  let len = strlen(a:string)
  let suffix = (a:start+1 < len ? '\(\%>'.(a:start+1).'c.*$\)\@=' : '$')
  if a:string !~ prefix . group . suffix
    let prefix = ''
  endif
  return prefix . group . suffix
endfun
fun! s:Ref(string, d, ...)
  let len = strlen(a:string)
  if a:d == 0
    let start = 0
  else
    let cnt = a:d
    let match = a:string
    while cnt
      let cnt = cnt - 1
      let index = matchend(match, s:notslash . '\\(')
      if index == -1
	return ""
      endif
      let match = strpart(match, index)
    endwhile
    let start = len - strlen(match)
    if a:0 == 1 && a:1 == "start"
      return start - 2
    endif
    let cnt = 1
    while cnt
      let index = matchend(match, s:notslash . '\\(\|\\)') - 1
      if index == -2
	return ""
      endif
      let cnt = cnt + (match[index]=="(" ? 1 : -1)  " ')'
      let match = strpart(match, index+1)
    endwhile
    let start = start - 2
    let len = len - start - strlen(match)
  endif
  if a:0 == 1
    return len
  elseif a:0 == 2
    return "let " . a:1 . "=" . start . "| let " . a:2 . "=" . len
  else
    return strpart(a:string, start, len)
  endif
endfun
fun! s:Count(string, pattern, ...)
  let pat = escape(a:pattern, '\\')
  if a:0 > 1
    let foo = substitute(a:string, '[^'.a:pattern.']', "a:1", "g")
    let foo = substitute(a:string, pat, a:2, "g")
    let foo = substitute(foo, '[^' . a:2 . ']', "", "g")
    return strlen(foo)
  endif
  let result = 0
  let foo = a:string
  let index = matchend(foo, pat)
  while index != -1
    let result = result + 1
    let foo = strpart(foo, index)
    let index = matchend(foo, pat)
  endwhile
  return result
endfun
fun! s:Resolve(source, target, output)
  let word = a:target
  let i = matchend(word, s:notslash . '\\\d') - 1
  let table = "----------"
  while i != -2 " There are back references to be replaced.
    let d = word[i]
    let backref = s:Ref(a:source, d)
    let w = s:Count(
    \ substitute(strpart(word, 0, i-1), '\\\\', '', 'g'), '\(', '1')
    let b = 1 " number of the current '\(' in backref
    let s = d " number of the current '\(' in a:source
    while b <= s:Count(substitute(backref, '\\\\', '', 'g'), '\(', '1')
    \ && s < 10
      if table[s] == "-"
	if w + b < 10
	  let table = strpart(table, 0, s) . (w+b) . strpart(table, s+1)
	endif
	let b = b + 1
	let s = s + 1
      else
	execute s:Ref(backref, b, "start", "len")
	let ref = strpart(backref, start, len)
	let backref = strpart(backref, 0, start) . ":". table[s]
	\ . strpart(backref, start+len)
	let s = s + s:Count(substitute(ref, '\\\\', '', 'g'), '\(', '1')
      endif
    endwhile
    let word = strpart(word, 0, i-1) . backref . strpart(word, i+1)
    let i = matchend(word, s:notslash . '\\\d') - 1
  endwhile
  let word = substitute(word, s:notslash . '\zs:', '\\', 'g')
  if a:output == "table"
    return table
  elseif a:output == "word"
    return word
  else
    return table . word
  endif
endfun
fun! s:Choose(patterns, string, comma, branch, prefix, suffix, ...)
  let tail = (a:patterns =~ a:comma."$" ? a:patterns : a:patterns . a:comma)
  let i = matchend(tail, s:notslash . a:comma)
  if a:0
    let alttail = (a:1 =~ a:comma."$" ? a:1 : a:1 . a:comma)
    let j = matchend(alttail, s:notslash . a:comma)
  endif
  let current = strpart(tail, 0, i-1)
  if a:branch == ""
    let currpat = current
  else
    let currpat = substitute(current, s:notslash . a:branch, '\\|', 'g')
  endif
  while a:string !~ a:prefix . currpat . a:suffix
    let tail = strpart(tail, i)
    let i = matchend(tail, s:notslash . a:comma)
    if i == -1
      return -1
    endif
    let current = strpart(tail, 0, i-1)
    if a:branch == ""
      let currpat = current
    else
      let currpat = substitute(current, s:notslash . a:branch, '\\|', 'g')
    endif
    if a:0
      let alttail = strpart(alttail, j)
      let j = matchend(alttail, s:notslash . a:comma)
    endif
  endwhile
  if a:0
    let current = current . a:comma . strpart(alttail, 0, j-1)
  endif
  return current
endfun
if !exists(":MatchDebug")
  command! -nargs=0 MatchDebug call s:Match_debug()
endif
fun! s:Match_debug()
  let b:match_debug = 1	" Save debugging information.
  amenu &Matchit.&pat	:echo b:match_pat<CR>
  amenu &Matchit.&match	:echo b:match_match<CR>
  amenu &Matchit.&curcol	:echo b:match_col<CR>
  amenu &Matchit.wh&oleBR	:echo b:match_wholeBR<CR>
  amenu &Matchit.ini&BR	:echo b:match_iniBR<CR>
  amenu &Matchit.&ini	:echo b:match_ini<CR>
  amenu &Matchit.&tail	:echo b:match_tail<CR>
  amenu &Matchit.&word	:echo b:match_word<CR>
  amenu &Matchit.t&able	:echo '0:' . b:match_table . ':9'<CR>
endfun
fun! s:MultiMatch(spflag, mode)
  if !exists("b:match_words") || b:match_words == ""
    return ""
  end
  let restore_options = (&ic ? "" : "no") . "ignorecase"
  if exists("b:match_ignorecase")
    let &ignorecase = b:match_ignorecase
  endif
  let startline = line(".")
  let startcol = col(".")
  let default = escape(&mps, '[$^.*~\\/?]') . (strlen(&mps) ? "," : "") .
    \ '\/\*:\*\/,#if\%(def\)\=:#else\>:#elif\>:#endif\>'
  if b:match_words =~ ":"
    let match_words = b:match_words
  else
    execute "let match_words =" b:match_words
  endif
  if (match_words != s:last_words) || (&mps != s:last_mps) ||
    \ exists("b:match_debug")
    let s:last_words = match_words
    let s:last_mps = &mps
    if match_words !~ s:notslash . '\\\d'
      let s:do_BR = 0
      let s:pat = match_words
    else
      let s:do_BR = 1
      let s:pat = s:ParseWords(match_words)
    endif
    let s:all = '\%(' . substitute(s:pat . (strlen(s:pat)?",":"") . default,
      \	'[,:]\+','\\|','g') . '\)'
    if exists("b:match_debug")
      let b:match_pat = s:pat
    endif
  endif
  let cdefault = (s:pat =~ '[^,]$' ? "," : "") . default
  let open =  substitute(s:pat . cdefault,
	\ s:notslash . '\zs:.\{-}' . s:notslash . ',', '\\),\\(', 'g')
  let open =  '\(' . substitute(open, s:notslash . '\zs:.*$', '\\)', '')
  let close = substitute(s:pat . cdefault,
	\ s:notslash . '\zs,.\{-}' . s:notslash . ':', '\\),\\(', 'g')
  let close = substitute(close, '^.\{-}' . s:notslash . ':', '\\(', '') . '\)'
  if exists("b:match_skip")
    let skip = b:match_skip
  elseif exists("b:match_comment") " backwards compatibility and testing!
    let skip = "r:" . b:match_comment
  else
    let skip = 's:comment\|string'
  endif
  let skip = s:ParseSkip(skip)
  let restore_cursor = virtcol(".") . "|"
  normal! g0
  let restore_cursor = line(".") . "G" .  virtcol(".") . "|zs" . restore_cursor
  normal! H
  let restore_cursor = "normal!" . line(".") . "Gzt" . restore_cursor
  execute restore_cursor
  let openpat =  substitute(open, '\(\\\@<!\(\\\\\)*\)\@<=\\(', '\\%(', 'g')
  let openpat = substitute(openpat, ',', '\\|', 'g')
  let closepat = substitute(close, '\(\\\@<!\(\\\\\)*\)\@<=\\(', '\\%(', 'g')
  let closepat = substitute(closepat, ',', '\\|', 'g')
  if skip =~ 'synID' && !(has("syntax") && exists("g:syntax_on"))
    let skip = '0'
  else
    execute "if " . skip . "| let skip = '0' | endif"
  endif
  mark '
  let level = v:count1
  while level
    if searchpair(openpat, '', closepat, a:spflag, skip) < 1
      call s:CleanUp(restore_options, a:mode, startline, startcol)
      return ""
    endif
    let level = level - 1
  endwhile
  call s:CleanUp(restore_options, a:mode, startline, startcol)
  return restore_cursor
endfun
fun! s:ParseSkip(str)
  let skip = a:str
  if skip[1] == ":"
    if skip[0] == "s"
      let skip = "synIDattr(synID(line('.'),col('.'),1),'name') =~? '" .
	\ strpart(skip,2) . "'"
    elseif skip[0] == "S"
      let skip = "synIDattr(synID(line('.'),col('.'),1),'name') !~? '" .
	\ strpart(skip,2) . "'"
    elseif skip[0] == "r"
      let skip = "strpart(getline('.'),0,col('.'))=~'" . strpart(skip,2). "'"
    elseif skip[0] == "R"
      let skip = "strpart(getline('.'),0,col('.'))!~'" . strpart(skip,2). "'"
    endif
  endif
  return skip
endfun
let &cpo = s:save_cpo
