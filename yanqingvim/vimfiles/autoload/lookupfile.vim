let s:save_cpo = &cpo
set cpo&vim
if !exists('s:myBufNum')
  let s:windowName = '[Lookup File]'
  let s:myBufNum = -1
  let s:popupIsHidden = 0
endif
let g:lookupfile#lastPattern = ""
let g:lookupfile#lastResults = []
let g:lookupfile#lastStatsMsg = []
let g:lookupfile#recentFiles = []
function! lookupfile#OpenWindow(bang, initPat)
  let origWinnr = winnr()
  let _isf = &isfname
  let _splitbelow = &splitbelow
  set nosplitbelow
  try
    if s:myBufNum == -1
      set isfname-=\
      set isfname-=[
      if exists('+shellslash')
        call genutils#OpenWinNoEa("1sp \\\\". escape(s:windowName, ' '))
      else
        call genutils#OpenWinNoEa("1sp \\". escape(s:windowName, ' '))
      endif
      let s:myBufNum = bufnr('%')
    else
      let winnr = bufwinnr(s:myBufNum)
      if winnr == -1
        call genutils#OpenWinNoEa('1sb '. s:myBufNum)
      else
        let wasVisible = 1
        exec winnr 'wincmd w'
      endif
    endif
  finally
    let &isfname = _isf
    let &splitbelow = _splitbelow
  endtry
  call s:SetupBuf()
  let initPat = ''
  if a:bang != ''
    let initPat = ''
  elseif a:initPat != ''
    let initPat = a:initPat
  elseif g:lookupfile#lastPattern != '' && g:LookupFile_PreserveLastPattern
    let initPat = g:lookupfile#lastPattern
  endif
  $
  if getline('.') !=# initPat
    silent! put=''
    call setline('.', initPat)
  endif
  startinsert!
  if !g:LookupFile_OnCursorMovedI
    aug LookupFileCursorHoldImm
      au!
      au CursorMovedI <buffer> nested exec 'doautocmd LookupFile CursorHoldI' |
            \ au! LookupFileCursorHoldImm
    aug END
  endif
  call s:LookupFileSet()
  aug LookupFileReset
    au!
    au CursorMovedI <buffer> call <SID>LookupFileSet()
    au CursorMoved <buffer> call <SID>LookupFileSet()
    au WinEnter <buffer> call <SID>LookupFileSet()
    au TabEnter <buffer> call <SID>LookupFileSet()
    au WinEnter * call <SID>LookupFileReset(0)
    au TabEnter * call <SID>LookupFileReset(0)
    au CursorMoved * call <SID>LookupFileReset(0)
    au BufHidden <buffer> call <SID>LookupFileReset(1)
  aug END
endfunction
function! lookupfile#CloseWindow()
  if bufnr('%') != s:myBufNum
    return
  endif
  call s:LookupFileReset(1)
  close
endfunction
function! lookupfile#ClearCache()
  let g:lookupfile#lastPattern = ""
  let g:lookupfile#lastResults = []
endfunction
function! s:LookupFileSet()
  if bufnr('%') != s:myBufNum || exists('s:_backspace')
    return
  endif
  let s:_backspace = &backspace
  set backspace=start
  let s:_completeopt = &completeopt
  set completeopt+=menuone
  let s:_updatetime = &updatetime
  let &updatetime = g:LookupFile_UpdateTime
endfunction
function! s:LookupFileReset(force)
  if a:force
    aug LookupFileReset
      au!
    aug END
  endif
  if exists('s:_backspace') && (a:force || (bufnr('%') != s:myBufNum))
    let &backspace = s:_backspace
    let &completeopt = s:_completeopt
    let &updatetime = s:_updatetime
    unlet s:_backspace s:_completeopt s:_updatetime
  endif
endfunction
function! s:HidePopup()
  let s:popupIsHidden = 1
  return "\<C-E>"
endfunction
function! lookupfile#IsPopupHidden()
  return s:popupIsHidden
endfunction
function! s:SetupBuf()
  call genutils#SetupScratchBuffer()
  resize 1
  setlocal wrap
  setlocal bufhidden=hide
  setlocal winfixheight
  setlocal wrapmargin=0
  setlocal textwidth=0
  setlocal completefunc=lookupfile#Complete
  syn clear
  set ft=lookupfile
  inoremap <silent> <buffer> <expr> <C-E> <SID>HidePopup()
  inoremap <silent> <buffer> <expr> <CR> <SID>AcceptFile(0, "\<CR>")
  inoremap <silent> <buffer> <expr> <C-O> <SID>AcceptFile(1, "\<C-O>")
  inoremap <buffer> <expr> <BS>       pumvisible()?"\<C-E>\<BS>":"\<BS>"
  inoremap <buffer> <expr> <S-BS>       pumvisible()?"\<C-E>\<BS>":"\<BS>"
  imap     <buffer> <C-Y>      <CR>
  if g:LookupFile_EscCancelsPopup
    inoremap <buffer> <expr> <Esc>      pumvisible()?"\<C-E>\<C-C>":"\<Esc>"
  endif
  inoremap <buffer> <expr> <silent> <Down> <SID>GetCommand(1, 1, "\<C-N>",
        \ "\"\\<Lt>C-N>\"")
  inoremap <buffer> <expr> <silent> <Up> <SID>GetCommand(1, 1, "\<C-P>",
        \ "\"\\<Lt>C-P>\"")
  inoremap <buffer> <expr> <silent> <PageDown> <SID>GetCommand(1, 0,
        \ "\<PageDown>", '')
  inoremap <buffer> <expr> <silent> <PageUp> <SID>GetCommand(1, 0,
        \ "\<PageUp>", '')
  nnoremap <silent> <buffer> o :OpenFile<CR>
  nnoremap <silent> <buffer> O :OpenFile!<CR>
  command! -buffer -nargs=0 -bang OpenFile
        \ :call <SID>OpenCurFile('<bang>' != '')
  command! -buffer -nargs=0 -bang AddPattern :call <SID>AddPattern()
  nnoremap <buffer> <silent> <Plug>LookupFile :call lookupfile#CloseWindow()<CR>
  inoremap <buffer> <silent> <Plug>LookupFile <C-E><C-C>:call lookupfile#CloseWindow()<CR>
  aug LookupFile
    au!
    if g:LookupFile_ShowFiller
      exec 'au' (g:LookupFile_OnCursorMovedI ? 'CursorMovedI' : 'CursorHoldI')
            \ '<buffer> call <SID>ShowFiller()'
    endif
    exec 'au' (g:LookupFile_OnCursorMovedI ? 'CursorMovedI' : 'CursorHoldI')
          \ '<buffer> call lookupfile#LookupFile(0)'
  aug END
endfunction
function! s:GetCommand(withPopupTrigger, withSkipPat, actCmd, innerCmd)
  let cmd = ''
  if a:withPopupTrigger && !pumvisible()
    let cmd .= "\<C-X>\<C-U>"
  endif
  let cmd .= a:actCmd. "\<C-R>=(getline('.') == lookupfile#lastPattern) ? ".
        \ a:innerCmd." : ''\<CR>"
  return cmd
endfunction
function! s:AddPattern()
  if g:LookupFile_PreservePatternHistory
    silent! put! =g:lookupfile#lastPattern
    $
  endif
endfunction
function! s:AcceptFile(splitWin, key)
  if s:popupIsHidden
    return a:key
  endif
  if !pumvisible()
    call lookupfile#LookupFile(0, 1)
  endif
  let acceptCmd = ''
  if type(g:LookupFile_LookupAcceptFunc) == 2 ||
        \ (type(g:LookupFile_LookupAcceptFunc) == 1 &&
        \  substitute(g:LookupFile_LookupAcceptFunc, '\s', '', 'g') != '')
    let acceptCmd = call(g:LookupFile_LookupAcceptFunc, [a:splitWin, a:key])
  else
    let acceptCmd = lookupfile#AcceptFile(a:splitWin, a:key)
  endif
  return (!pumvisible() ? "\<C-X>\<C-U>" : '').acceptCmd
endfunction
function! s:IsValid(fileName)
  if bufnr('%') != s:myBufNum || a:fileName == ''
    return 0
  endif
  if !filereadable(a:fileName) && !isdirectory(a:fileName)
    if g:LookupFile_AllowNewFiles
      let parent = fnamemodify(a:fileName, ':h')
      if parent == '' || (parent != '' && !isdirectory(parent))
        return 1
      endif
    endif
    return 0
  endif
  return 1
endfunction
function! lookupfile#AcceptFile(splitWin, key)
  if len(g:lookupfile#lastResults) == 0 && !s:IsValid(getline('.'))
    return "\<C-O>:echohl ErrorMsg | echo 'No such file or directory' | echohl NONE\<CR>"
  endif
  let nextCmd = "\<C-N>\<C-R>=(getline('.') == lookupfile#lastPattern)?\"\\<C-N>\":''\<CR>"
  let acceptCmd = "\<C-Y>\<Esc>:AddPattern\<CR>:OpenFile".(a:splitWin?'!':'').
        \ "\<CR>"
  if getline('.') ==# g:lookupfile#lastPattern
    if len(g:lookupfile#lastResults) == 0
      let acceptCmd = acceptCmd
    elseif len(g:lookupfile#lastResults) == 1 || g:LookupFile_AlwaysAcceptFirst
      let acceptCmd = nextCmd.acceptCmd
    else
      let acceptCmd = nextCmd
    endif
  endif
  return acceptCmd
endfunction
function! s:OpenCurFile(splitWin)
  let fileName = getline('.')
  if fileName =~ '^\s*$'
    return
  endif
  if !s:IsValid(fileName)
    echohl ErrorMsg | echo 'No such file or directory' | echohl NONE
  endif
  if type(g:LookupFile_LookupNotifyFunc) == 2 ||
        \ (type(g:LookupFile_LookupNotifyFunc) == 1 &&
        \  substitute(g:LookupFile_LookupNotifyFunc, '\s', '', 'g') != '')
    call call(g:LookupFile_LookupNotifyFunc, [])
  endif
  call lookupfile#CloseWindow()
  if g:LookupFile_RecentFileListSize > 0
    let curPos = index(g:lookupfile#recentFiles, fileName)
    call add(g:lookupfile#recentFiles, fileName)
    if curPos != -1
      call remove(g:lookupfile#recentFiles, curPos)
    elseif len(g:lookupfile#recentFiles) > g:LookupFile_RecentFileListSize
      let g:lookupfile#recentFiles = g:lookupfile#recentFiles[
            \ -g:LookupFile_RecentFileListSize :]
    endif
  endif
  let bufnr = genutils#FindBufferForName(fileName)
  let winnr = bufwinnr(bufnr)
  if winnr == -1 && g:LookupFile_SearchForBufsInTabs
      for i in range(tabpagenr('$'))
        if index(tabpagebuflist(i+1), bufnr) != -1
          exec 'tabnext' (i+1)
          let winnr = bufwinnr(bufnr)
        endif
    endfor
  endif
  if winnr != -1
    exec winnr.'wincmd w'
  else
    let splitOpen = 0
    if &switchbuf ==# 'split' || a:splitWin
      let splitOpen = 1
    endif
    try
      if bufnr == -1
        throw ''
      endif
      exec (splitOpen?'s':'').'buffer' bufnr
    catch /^Vim\%((\a\+)\)\=:E325/
    catch
      try
        exec (splitOpen?'split':'edit') fileName
      catch /^Vim\%((\a\+)\)\=:E325/
      endtry
    endtry
  endif
endfunction
function! s:ShowFiller()
  return lookupfile#LookupFile(1)
endfunction
function! lookupfile#Complete(findstart, base)
  if a:findstart
    return 0
  else
    call lookupfile#LookupFile(0, 1, a:base)
    return g:lookupfile#lastStatsMsg+g:lookupfile#lastResults
  endif
endfunction
function! lookupfile#LookupFile(showingFiller, ...)
  let generateMode = (a:0 == 0 ? 0 : a:1)
  if generateMode
    let pattern = (a:0 > 1) ? a:2 : getline('.')
  else
    let pattern = getline('.')
    if col('.') == 1 || (col('.') != col('$'))
      return ''
    endif
  endif
  if pattern == '' || (pattern ==# g:lookupfile#lastPattern && pumvisible())
    return ''
  endif
  if s:popupIsHidden && g:lookupfile#lastPattern ==# pattern
    return ''
  endif
  let s:popupIsHidden = 0
  let statusMsg = ''
  if pattern == ' '
    if len(g:lookupfile#recentFiles) == 0
      let statusMsg = '<<< No recent files >>>'
      let files = []
    else
      let statusMsg = '<<< Showing '.len(g:lookupfile#recentFiles).' recent files >>>'
      let files = reverse(copy(g:lookupfile#recentFiles))
    endif
  elseif strlen(pattern) < g:LookupFile_MinPatLength
    let statusMsg = '<<< Type at least '.g:LookupFile_MinPatLength.
          \ ' characters >>>'
    let files = []
  elseif g:lookupfile#lastPattern ==# pattern
    let files = g:lookupfile#lastResults
  elseif a:showingFiller
    let statusMsg = '<<< Looking up files... hit ^C to break >>>'
    let files = []
  else
    if type(g:LookupFile_LookupFunc) == 2 ||
          \ (type(g:LookupFile_LookupFunc) == 1 &&
          \  substitute(g:LookupFile_LookupFunc, '\s', '', 'g') != '')
      let files = call(g:LookupFile_LookupFunc, [pattern])
    else
      let _tags = &tags
      try
        let &tags = eval(g:LookupFile_TagExpr)
        let taglist = taglist(g:LookupFile_TagsExpandCamelCase ?
              \ lookupfile#ExpandCamelCase(pattern) : pattern)
      catch
        echohl ErrorMsg | echo "Exception: " . v:exception | echohl NONE
        return ''
      finally
        let &tags = _tags
      endtry
      if g:LookupFile_UsingSpecializedTags
        let files = map(taglist, '{'.
              \ '"word": fnamemodify(v:val["filename"], ":p"), '.
              \ '"abbr": v:val["name"], '.
              \ '"menu": fnamemodify(v:val["filename"], ":h"), '.
              \ '"dup": 1, '.
              \ '}')
      else
        let files = map(taglist, 'fnamemodify(v:val["filename"], ":p")')
      endif
    endif
    let pat = g:LookupFile_FileFilter
    if pat != ''
      call filter(files, '(type(v:val) == 4) ? v:val["word"] !~ pat : v:val !~ pat')
    endif
    if g:LookupFile_SortMethod ==# 'alpha'
      if type(get(files, 0)) == 4
        call sort(files, "s:CmpByName")
      else
        call sort(files)
      endif
    endif
    let g:lookupfile#lastPattern = pattern
    let g:lookupfile#lastResults = files
  endif
  if statusMsg == ''
    if len(files) > 0
      let statusMsg = '<<< '.len(files).' Matching >>>'
    else
      let statusMsg = '<<< None Matching >>>'
    endif
  endif
  let msgLine = [{'word': pattern, 'abbr': statusMsg, 'menu': pattern}]
  let g:lookupfile#lastStatsMsg = msgLine
  if !generateMode
    call complete(1, msgLine+files)
  endif
  return ''
endfunction
function! lookupfile#ExpandCamelCase(str)
  let pat = a:str
  if match(a:str, '\u\u') != -1
    let pat = '\C'.substitute(a:str, '\u\+',
          \ '\=substitute(submatch(0), ".", '."'".'&\\U*'."'".', "g")', 'g')
    let @*=pat
  endif
  return pat
endfunction
function! s:CmpByName(i1, i2)
  let ileft = a:i1["abbr"]
  let iright = a:i2["abbr"]
  return ileft == iright ? 0 : ileft > iright ? 1 : -1
endfunc
let &cpo = s:save_cpo
unlet s:save_cpo
