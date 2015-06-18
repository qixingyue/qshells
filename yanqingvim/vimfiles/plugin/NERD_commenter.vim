" Version:     2.3.0
if exists("loaded_nerd_comments")
    finish
endif
if v:version < 700
    echoerr "NERDCommenter: this plugin requires vim >= 7. DOWNLOAD IT! You'll thank me later!"
    finish
endif
let loaded_nerd_comments = 1
function s:InitVariable(var, value)
    if !exists(a:var)
        exec 'let ' . a:var . ' = ' . "'" . a:value . "'"
        return 1
    endif
    return 0
endfunction
let s:spaceStr = ' '
let s:lenSpaceStr = strlen(s:spaceStr)
call s:InitVariable("g:NERDAllowAnyVisualDelims", 1)
call s:InitVariable("g:NERDBlockComIgnoreEmpty", 0)
call s:InitVariable("g:NERDCommentWholeLinesInVMode", 0)
call s:InitVariable("g:NERDCompactSexyComs", 0)
call s:InitVariable("g:NERDCreateDefaultMappings", 1)
call s:InitVariable("g:NERDDefaultNesting", 1)
call s:InitVariable("g:NERDMenuMode", 3)
call s:InitVariable("g:NERDLPlace", "[>")
call s:InitVariable("g:NERDUsePlaceHolders", 1)
call s:InitVariable("g:NERDRemoveAltComs", 1)
call s:InitVariable("g:NERDRemoveExtraSpaces", 1)
call s:InitVariable("g:NERDRPlace", "<]")
call s:InitVariable("g:NERDSpaceDelims", 0)
call s:InitVariable("g:NERDDelimiterRequests", 1)
let s:NERDFileNameEscape="[]#*$%'\" ?`!&();<>\\"
let s:delimiterMap = {
    \ 'aap': { 'left': '#' },
    \ 'abc': { 'left': '%' },
    \ 'acedb': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'actionscript': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'ada': { 'left': '--', 'leftAlt': '--  ' },
    \ 'ahdl': { 'left': '--' },
    \ 'ahk': { 'left': ';', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'amiga': { 'left': ';' },
    \ 'aml': { 'left': '/*' },
    \ 'ampl': { 'left': '#' },
    \ 'apache': { 'left': '#' },
    \ 'apachestyle': { 'left': '#' },
    \ 'asciidoc': { 'left': '//' },
    \ 'applescript': { 'left': '--', 'leftAlt': '(*', 'rightAlt': '*)' },
    \ 'asm68k': { 'left': ';' },
    \ 'asm': { 'left': ';', 'leftAlt': '#' },
    \ 'asn': { 'left': '--' },
    \ 'aspvbs': { 'left': '''' },
    \ 'asterisk': { 'left': ';' },
    \ 'asy': { 'left': '//' },
    \ 'atlas': { 'left': 'C', 'right': '$' },
    \ 'autohotkey': { 'left': ';' },
    \ 'autoit': { 'left': ';' },
    \ 'ave': { 'left': "'" },
    \ 'awk': { 'left': '#' },
    \ 'basic': { 'left': "'", 'leftAlt': 'REM ' },
    \ 'bbx': { 'left': '%' },
    \ 'bc': { 'left': '#' },
    \ 'bib': { 'left': '%' },
    \ 'bindzone': { 'left': ';' },
    \ 'bst': { 'left': '%' },
    \ 'btm': { 'left': '::' },
    \ 'caos': { 'left': '*' },
    \ 'calibre': { 'left': '//' },
    \ 'catalog': { 'left': '--', 'right': '--' },
    \ 'c': { 'left': '/*','right': '*/', 'leftAlt': '//' },
    \ 'cfg': { 'left': '#' },
    \ 'cg': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'ch': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'cl': { 'left': '#' },
    \ 'clean': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'clipper': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'clojure': { 'left': ';' },
    \ 'cmake': { 'left': '#' },
    \ 'conkyrc': { 'left': '#' },
    \ 'cpp': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'crontab': { 'left': '#' },
    \ 'cs': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'csp': { 'left': '--' },
    \ 'cterm': { 'left': '*' },
    \ 'cucumber': { 'left': '#' },
    \ 'cvs': { 'left': 'CVS:' },
    \ 'd': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'dcl': { 'left': '$!' },
    \ 'dakota': { 'left': '#' },
    \ 'debcontrol': { 'left': '#' },
    \ 'debsources': { 'left': '#' },
    \ 'def': { 'left': ';' },
    \ 'desktop': { 'left': '#' },
    \ 'dhcpd': { 'left': '#' },
    \ 'diff': { 'left': '#' },
    \ 'django': { 'left': '<!--','right': '-->', 'leftAlt': '{#', 'rightAlt': '#}' },
    \ 'docbk': { 'left': '<!--', 'right': '-->' },
    \ 'dns': { 'left': ';' },
    \ 'dosbatch': { 'left': 'REM ', 'leftAlt': '::' },
    \ 'dosini': { 'left': ';' },
    \ 'dot': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'dracula': { 'left': ';' },
    \ 'dsl': { 'left': ';' },
    \ 'dtml': { 'left': '<dtml-comment>', 'right': '</dtml-comment>' },
    \ 'dylan': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'ebuild': { 'left': '#' },
    \ 'ecd': { 'left': '#' },
    \ 'eclass': { 'left': '#' },
    \ 'eiffel': { 'left': '--' },
    \ 'elf': { 'left': "'" },
    \ 'elmfilt': { 'left': '#' },
    \ 'erlang': { 'left': '%' },
    \ 'eruby': { 'left': '<%#', 'right': '%>', 'leftAlt': '<!--', 'rightAlt': '-->' },
    \ 'expect': { 'left': '#' },
    \ 'exports': { 'left': '#' },
    \ 'factor': { 'left': '! ', 'leftAlt': '!# ' },
    \ 'fgl': { 'left': '#' },
    \ 'focexec': { 'left': '-*' },
    \ 'form': { 'left': '*' },
    \ 'foxpro': { 'left': '*' },
    \ 'fstab': { 'left': '#' },
    \ 'fvwm': { 'left': '#' },
    \ 'fx': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'gams': { 'left': '*' },
    \ 'gdb': { 'left': '#' },
    \ 'gdmo': { 'left': '--' },
    \ 'geek': { 'left': 'GEEK_COMMENT:' },
    \ 'genshi': { 'left': '<!--','right': '-->', 'leftAlt': '{#', 'rightAlt': '#}' },
    \ 'gentoo-conf-d': { 'left': '#' },
    \ 'gentoo-env-d': { 'left': '#' },
    \ 'gentoo-init-d': { 'left': '#' },
    \ 'gentoo-make-conf': { 'left': '#' },
    \ 'gentoo-package-keywords': { 'left': '#' },
    \ 'gentoo-package-mask': { 'left': '#' },
    \ 'gentoo-package-use': { 'left': '#' },
    \ 'gitcommit': { 'left': '#' },
    \ 'gitconfig': { 'left': ';' },
    \ 'gitrebase': { 'left': '#' },
    \ 'gnuplot': { 'left': '#' },
    \ 'groovy': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'gsp': { 'left': '<%--', 'right': '--%>' },
    \ 'gtkrc': { 'left': '#' },
    \ 'haskell': { 'left': '{-','right': '-}', 'leftAlt': '--' },
    \ 'hb': { 'left': '#' },
    \ 'h': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'haml': { 'left': '-#', 'leftAlt': '/' },
    \ 'hercules': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'hog': { 'left': '#' },
    \ 'hostsaccess': { 'left': '#' },
    \ 'htmlcheetah': { 'left': '##' },
    \ 'htmldjango': { 'left': '<!--','right': '-->', 'leftAlt': '{#', 'rightAlt': '#}' },
    \ 'htmlos': { 'left': '#', 'right': '/#' },
    \ 'ia64': { 'left': '#' },
    \ 'icon': { 'left': '#' },
    \ 'idlang': { 'left': ';' },
    \ 'idl': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'inform': { 'left': '!' },
    \ 'inittab': { 'left': '#' },
    \ 'ishd': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'iss': { 'left': ';' },
    \ 'ist': { 'left': '%' },
    \ 'java': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'javacc': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'javascript': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'javascript.jquery': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'jess': { 'left': ';' },
    \ 'jgraph': { 'left': '(*', 'right': '*)' },
    \ 'jproperties': { 'left': '#' },
    \ 'jsp': { 'left': '<%--', 'right': '--%>' },
    \ 'kix': { 'left': ';' },
    \ 'kscript': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'lace': { 'left': '--' },
    \ 'ldif': { 'left': '#' },
    \ 'lilo': { 'left': '#' },
    \ 'lilypond': { 'left': '%' },
    \ 'liquid': { 'left': '{%', 'right': '%}' },
    \ 'lisp': { 'left': ';', 'leftAlt': '#|', 'rightAlt': '|#' },
    \ 'llvm': { 'left': ';' },
    \ 'lotos': { 'left': '(*', 'right': '*)' },
    \ 'lout': { 'left': '#' },
    \ 'lprolog': { 'left': '%' },
    \ 'lscript': { 'left': "'" },
    \ 'lss': { 'left': '#' },
    \ 'lua': { 'left': '--', 'leftAlt': '--[[', 'rightAlt': ']]' },
    \ 'lynx': { 'left': '#' },
    \ 'lytex': { 'left': '%' },
    \ 'mail': { 'left': '> ' },
    \ 'mako': { 'left': '##' },
    \ 'man': { 'left': '."' },
    \ 'map': { 'left': '%' },
    \ 'maple': { 'left': '#' },
    \ 'markdown': { 'left': '<!--', 'right': '-->' },
    \ 'masm': { 'left': ';' },
    \ 'mason': { 'left': '<% #', 'right': '%>' },
    \ 'master': { 'left': '$' },
    \ 'matlab': { 'left': '%' },
    \ 'mel': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'mib': { 'left': '--' },
    \ 'mkd': { 'left': '>' },
    \ 'mma': { 'left': '(*', 'right': '*)' },
    \ 'model': { 'left': '$', 'right': '$' },
    \ 'moduala.': { 'left': '(*', 'right': '*)' },
    \ 'modula2': { 'left': '(*', 'right': '*)' },
    \ 'modula3': { 'left': '(*', 'right': '*)' },
    \ 'monk': { 'left': ';' },
    \ 'mush': { 'left': '#' },
    \ 'named': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'nasm': { 'left': ';' },
    \ 'nastran': { 'left': '$' },
    \ 'natural': { 'left': '/*' },
    \ 'ncf': { 'left': ';' },
    \ 'newlisp': { 'left': ';' },
    \ 'nroff': { 'left': '\"' },
    \ 'nsis': { 'left': '#' },
    \ 'ntp': { 'left': '#' },
    \ 'objc': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'objcpp': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'objj': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'ocaml': { 'left': '(*', 'right': '*)' },
    \ 'occam': { 'left': '--' },
    \ 'omlet': { 'left': '(*', 'right': '*)' },
    \ 'omnimark': { 'left': ';' },
    \ 'openroad': { 'left': '//' },
    \ 'opl': { 'left': "REM" },
    \ 'ora': { 'left': '#' },
    \ 'ox': { 'left': '//' },
    \ 'pascal': { 'left': '{','right': '}', 'leftAlt': '(*', 'rightAlt': '*)' },
    \ 'patran': { 'left': '$', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'pcap': { 'left': '#' },
    \ 'pccts': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'pdf': { 'left': '%' },
    \ 'pfmain': { 'left': '//' },
    \ 'php': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'pic': { 'left': ';' },
    \ 'pike': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'pilrc': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'pine': { 'left': '#' },
    \ 'plm': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'plsql': { 'left': '--', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'po': { 'left': '#' },
    \ 'postscr': { 'left': '%' },
    \ 'pov': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'povini': { 'left': ';' },
    \ 'ppd': { 'left': '%' },
    \ 'ppwiz': { 'left': ';;' },
    \ 'processing': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'prolog': { 'left': '%', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'ps1': { 'left': '#' },
    \ 'psf': { 'left': '#' },
    \ 'ptcap': { 'left': '#' },
    \ 'python': { 'left': '#' },
    \ 'radiance': { 'left': '#' },
    \ 'ratpoison': { 'left': '#' },
    \ 'r': { 'left': '#' },
    \ 'rc': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'rebol': { 'left': ';' },
    \ 'registry': { 'left': ';' },
    \ 'remind': { 'left': '#' },
    \ 'resolv': { 'left': '#' },
    \ 'rgb': { 'left': '!' },
    \ 'rib': { 'left': '#' },
    \ 'robots': { 'left': '#' },
    \ 'sa': { 'left': '--' },
    \ 'samba': { 'left': ';', 'leftAlt': '#' },
    \ 'sass': { 'left': '//', 'leftAlt': '/*' },
    \ 'sather': { 'left': '--' },
    \ 'scala': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'scilab': { 'left': '//' },
    \ 'scsh': { 'left': ';' },
    \ 'sed': { 'left': '#' },
    \ 'sgmldecl': { 'left': '--', 'right': '--' },
    \ 'sgmllnx': { 'left': '<!--', 'right': '-->' },
    \ 'sicad': { 'left': '*' },
    \ 'simula': { 'left': '%', 'leftAlt': '--' },
    \ 'sinda': { 'left': '$' },
    \ 'skill': { 'left': ';' },
    \ 'slang': { 'left': '%' },
    \ 'slice': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'slrnrc': { 'left': '%' },
    \ 'sm': { 'left': '#' },
    \ 'smarty': { 'left': '{*', 'right': '*}' },
    \ 'smil': { 'left': '<!', 'right': '>' },
    \ 'smith': { 'left': ';' },
    \ 'sml': { 'left': '(*', 'right': '*)' },
    \ 'snnsnet': { 'left': '#' },
    \ 'snnspat': { 'left': '#' },
    \ 'snnsres': { 'left': '#' },
    \ 'snobol4': { 'left': '*' },
    \ 'spec': { 'left': '#' },
    \ 'specman': { 'left': '//' },
    \ 'spectre': { 'left': '//', 'leftAlt': '*' },
    \ 'spice': { 'left': '$' },
    \ 'sql': { 'left': '--' },
    \ 'sqlforms': { 'left': '--' },
    \ 'sqlj': { 'left': '--' },
    \ 'sqr': { 'left': '!' },
    \ 'squid': { 'left': '#' },
    \ 'st': { 'left': '"' },
    \ 'stp': { 'left': '--' },
    \ 'systemverilog': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'tads': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'tags': { 'left': ';' },
    \ 'tak': { 'left': '$' },
    \ 'tasm': { 'left': ';' },
    \ 'tcl': { 'left': '#' },
    \ 'texinfo': { 'left': "@c " },
    \ 'texmf': { 'left': '%' },
    \ 'tf': { 'left': ';' },
    \ 'tidy': { 'left': '#' },
    \ 'tli': { 'left': '#' },
    \ 'tmux': { 'left': '#' },
    \ 'trasys': { 'left': "$" },
    \ 'tsalt': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'tsscl': { 'left': '#' },
    \ 'tssgm': { 'left': "comment = '", 'right': "'" },
    \ 'txt2tags': { 'left': '%' },
    \ 'uc': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'uil': { 'left': '!' },
    \ 'vb': { 'left': "'" },
    \ 'velocity': { 'left': "##", 'right': "", 'leftAlt': '#*', 'rightAlt': '*#' },
    \ 'vera': { 'left': '/*','right': '*/', 'leftAlt': '//' },
    \ 'verilog': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'verilog_systemverilog': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'vgrindefs': { 'left': '#' },
    \ 'vhdl': { 'left': '--' },
    \ 'vimperator': { 'left': '"' },
    \ 'virata': { 'left': '%' },
    \ 'vrml': { 'left': '#' },
    \ 'vsejcl': { 'left': '/*' },
    \ 'webmacro': { 'left': '##' },
    \ 'wget': { 'left': '#' },
    \ 'Wikipedia': { 'left': '<!--', 'right': '-->' },
    \ 'winbatch': { 'left': ';' },
    \ 'wml': { 'left': '#' },
    \ 'wvdial': { 'left': ';' },
    \ 'xdefaults': { 'left': '!' },
    \ 'xkb': { 'left': '//' },
    \ 'xmath': { 'left': '#' },
    \ 'xpm2': { 'left': '!' },
    \ 'xquery': { 'left': '(:', 'right': ':)' },
    \ 'z8a': { 'left': ';' }
    \ }
augroup commentEnablers
    "if the user enters a buffer or reads a buffer then we gotta set up
    "the comment delimiters for that new filetype
    autocmd BufEnter,BufRead * :call s:SetUpForNewFiletype(&filetype, 0)
    "if the filetype of a buffer changes, force the script to reset the
    "delims for the buffer
    autocmd Filetype * :call s:SetUpForNewFiletype(&filetype, 1)
augroup END
function s:SetUpForNewFiletype(filetype, forceReset)
    let b:NERDSexyComMarker = ''
    if has_key(s:delimiterMap, a:filetype)
        let b:NERDCommenterDelims = s:delimiterMap[a:filetype]
        for i in ['left', 'leftAlt', 'right', 'rightAlt']
            if !has_key(b:NERDCommenterDelims, i)
                let b:NERDCommenterDelims[i] = ''
            endif
        endfor
    else
        let b:NERDCommenterDelims = s:CreateDelimMapFromCms()
    endif
endfunction
function s:CreateDelimMapFromCms()
    return {
        \ 'left': substitute(&commentstring, '\([^ \t]*\)\s*%s.*', '\1', ''),
        \ 'right': substitute(&commentstring, '.*%s\s*\(.*\)', '\1', 'g'),
        \ 'leftAlt': '',
        \ 'rightAlt': '' }
endfunction
function s:SwitchToAlternativeDelimiters(printMsgs)
    "if both of the alternative delimiters are empty then there is no
    "alternative comment style so bail out
    if b:NERDCommenterDelims['leftAlt'] == '' && b:NERDCommenterDelims['rightAlt'] == ''
        if a:printMsgs
            call s:NerdEcho("Cannot use alternative delimiters, none are specified", 0)
        endif
        return 0
    endif
    "save the current delimiters
    let tempLeft = s:Left()
    let tempRight = s:Right()
    "swap current delimiters for alternative
    let b:NERDCommenterDelims['left'] = b:NERDCommenterDelims['leftAlt']
    let b:NERDCommenterDelims['right'] = b:NERDCommenterDelims['rightAlt']
    "set the previously current delimiters to be the new alternative ones
    let b:NERDCommenterDelims['leftAlt'] = tempLeft
    let b:NERDCommenterDelims['rightAlt'] = tempRight
    "tell the user what comment delimiters they are now using
    if a:printMsgs
        call s:NerdEcho("Now using " . s:Left() . " " . s:Right() . " to delimit comments", 1)
    endif
    return 1
endfunction
function s:AppendCommentToLine()
    let left = s:Left({'space': 1})
    let right = s:Right({'space': 1})
    " get the len of the right delim
    let lenRight = strlen(right)
    let isLineEmpty = strlen(getline(".")) == 0
    let insOrApp = (isLineEmpty==1 ? 'i' : 'A')
    "stick the delimiters down at the end of the line. We have to format the
    "comment with spaces as appropriate
    execute ":normal! " . insOrApp . (isLineEmpty ? '' : ' ') . left . right . " "
    " if there is a right delimiter then we gotta move the cursor left
    " by the len of the right delimiter so we insert between the delimiters
    if lenRight > 0
        let leftMoveAmount = lenRight
        execute ":normal! " . leftMoveAmount . "h"
    endif
    startinsert
endfunction
function s:CommentBlock(top, bottom, lSide, rSide, forceNested )
    " we need to create local copies of these arguments so we can modify them
    let top = a:top
    let bottom = a:bottom
    let lSide = a:lSide
    let rSide = a:rSide
    "if the top or bottom line starts with tabs we have to adjust the left and
    "right boundaries so that they are set as though the tabs were spaces
    let topline = getline(top)
    let bottomline = getline(bottom)
    if s:HasLeadingTabs(topline, bottomline)
        "find out how many tabs are in the top line and adjust the left
        "boundary accordingly
        let numTabs = s:NumberOfLeadingTabs(topline)
        if lSide < numTabs
            let lSide = &ts * lSide
        else
            let lSide = (lSide - numTabs) + (&ts * numTabs)
        endif
        "find out how many tabs are in the bottom line and adjust the right
        "boundary accordingly
        let numTabs = s:NumberOfLeadingTabs(bottomline)
        let rSide = (rSide - numTabs) + (&ts * numTabs)
    endif
    "we must check that bottom IS actually below top, if it is not then we
    "swap top and bottom. Similarly for left and right.
    if bottom < top
        let temp = top
        let top = bottom
        let bottom = top
    endif
    if rSide < lSide
        let temp = lSide
        let lSide = rSide
        let rSide = temp
    endif
    "if the current delimiters arent multipart then we will switch to the
    "alternative delims (if THEY are) as the comment will be better and more
    "accurate with multipart delims
    let switchedDelims = 0
    if !s:Multipart() && g:NERDAllowAnyVisualDelims && s:AltMultipart()
        let switchedDelims = 1
        call s:SwitchToAlternativeDelimiters(0)
    endif
    "start the commenting from the top and keep commenting till we reach the
    "bottom
    let currentLine=top
    while currentLine <= bottom
        "check if we are allowed to comment this line
        if s:CanCommentLine(a:forceNested, currentLine)
            "convert the leading tabs into spaces
            let theLine = getline(currentLine)
            let lineHasLeadTabs = s:HasLeadingTabs(theLine)
            if lineHasLeadTabs
                let theLine = s:ConvertLeadingTabsToSpaces(theLine)
            endif
            "dont comment lines that begin after the right boundary of the
            "block unless the user has specified to do so
            if theLine !~ '^ \{' . rSide . '\}' || !g:NERDBlockComIgnoreEmpty
                "attempt to place the cursor in on the left of the boundary box,
                "then check if we were successful, if not then we cant comment this
                "line
                call setline(currentLine, theLine)
                if s:CanPlaceCursor(currentLine, lSide)
                    let leftSpaced = s:Left({'space': 1})
                    let rightSpaced = s:Right({'space': 1})
                    "stick the left delimiter down
                    let theLine = strpart(theLine, 0, lSide-1) . leftSpaced . strpart(theLine, lSide-1)
                    if s:Multipart()
                        "stick the right delimiter down
                        let theLine = strpart(theLine, 0, rSide+strlen(leftSpaced)) . rightSpaced . strpart(theLine, rSide+strlen(leftSpaced))
                        let firstLeftDelim = s:FindDelimiterIndex(s:Left(), theLine)
                        let lastRightDelim = s:LastIndexOfDelim(s:Right(), theLine)
                        if firstLeftDelim != -1 && lastRightDelim != -1
                            let searchStr = strpart(theLine, 0, lastRightDelim)
                            let searchStr = strpart(searchStr, firstLeftDelim+strlen(s:Left()))
                            "replace the outter most delims in searchStr with
                            "place-holders
                            let theLineWithPlaceHolders = s:ReplaceDelims(s:Left(), s:Right(), g:NERDLPlace, g:NERDRPlace, searchStr)
                            "add the right delimiter onto the line
                            let theLine = strpart(theLine, 0, firstLeftDelim+strlen(s:Left())) . theLineWithPlaceHolders . strpart(theLine, lastRightDelim)
                        endif
                    endif
                endif
            endif
            "restore tabs if needed
            if lineHasLeadTabs
                let theLine = s:ConvertLeadingSpacesToTabs(theLine)
            endif
            call setline(currentLine, theLine)
        endif
        let currentLine = currentLine + 1
    endwhile
    "if we switched delims then we gotta go back to what they were before
    if switchedDelims == 1
        call s:SwitchToAlternativeDelimiters(0)
    endif
endfunction
function s:CommentLines(forceNested, align, firstLine, lastLine)
    " we need to get the left and right indexes of the leftmost char in the
    " block of of lines and the right most char so that we can do alignment of
    " the delimiters if the user has specified
    let leftAlignIndx = s:LeftMostIndx(a:forceNested, 0, a:firstLine, a:lastLine)
    let rightAlignIndx = s:RightMostIndx(a:forceNested, 0, a:firstLine, a:lastLine)
    " gotta add the length of the left delimiter onto the rightAlignIndx cos
    " we'll be adding a left delim to the line
    let rightAlignIndx = rightAlignIndx + strlen(s:Left({'space': 1}))
    " now we actually comment the lines. Do it line by line
    let currentLine = a:firstLine
    while currentLine <= a:lastLine
        " get the next line, check commentability and convert spaces to tabs
        let theLine = getline(currentLine)
        let lineHasLeadingTabs = s:HasLeadingTabs(theLine)
        let theLine = s:ConvertLeadingTabsToSpaces(theLine)
        if s:CanCommentLine(a:forceNested, currentLine)
            "if the user has specified forceNesting then we check to see if we
            "need to switch delimiters for place-holders
            if a:forceNested && g:NERDUsePlaceHolders
                let theLine = s:SwapOutterMultiPartDelimsForPlaceHolders(theLine)
            endif
            " find out if the line is commented using normal delims and/or
            " alternate ones
            let isCommented = s:IsCommented(s:Left(), s:Right(), theLine) || s:IsCommented(s:Left({'alt': 1}), s:Right({'alt': 1}), theLine)
            " check if we can comment this line
            if !isCommented || g:NERDUsePlaceHolders || s:Multipart()
                if a:align == "left" || a:align == "both"
                    let theLine = s:AddLeftDelimAligned(s:Left({'space': 1}), theLine, leftAlignIndx)
                else
                    let theLine = s:AddLeftDelim(s:Left({'space': 1}), theLine)
                endif
                if a:align == "both"
                    let theLine = s:AddRightDelimAligned(s:Right({'space': 1}), theLine, rightAlignIndx)
                else
                    let theLine = s:AddRightDelim(s:Right({'space': 1}), theLine)
                endif
            endif
        endif
        " restore leading tabs if appropriate
        if lineHasLeadingTabs
            let theLine = s:ConvertLeadingSpacesToTabs(theLine)
        endif
        " we are done with this line
        call setline(currentLine, theLine)
        let currentLine = currentLine + 1
    endwhile
endfunction
function s:CommentLinesMinimal(firstLine, lastLine)
    "check that minimal comments can be done on this filetype
    if !s:HasMultipartDelims()
        throw 'NERDCommenter.Delimiters exception: Minimal comments can only be used for filetypes that have multipart delimiters'
    endif
    "if we need to use place holders for the comment, make sure they are
    "enabled for this filetype
    if !g:NERDUsePlaceHolders && s:DoesBlockHaveMultipartDelim(a:firstLine, a:lastLine)
        throw 'NERDCommenter.Settings exception: Place holders are required but disabled.'
    endif
    "get the left and right delims to smack on
    let left = s:GetSexyComLeft(g:NERDSpaceDelims,0)
    let right = s:GetSexyComRight(g:NERDSpaceDelims,0)
    "make sure all multipart delims on the lines are replaced with
    "placeholders to prevent illegal syntax
    let currentLine = a:firstLine
    while(currentLine <= a:lastLine)
        let theLine = getline(currentLine)
        let theLine = s:ReplaceDelims(left, right, g:NERDLPlace, g:NERDRPlace, theLine)
        call setline(currentLine, theLine)
        let currentLine = currentLine + 1
    endwhile
    "add the delim to the top line
    let theLine = getline(a:firstLine)
    let lineHasLeadingTabs = s:HasLeadingTabs(theLine)
    let theLine = s:ConvertLeadingTabsToSpaces(theLine)
    let theLine = s:AddLeftDelim(left, theLine)
    if lineHasLeadingTabs
        let theLine = s:ConvertLeadingSpacesToTabs(theLine)
    endif
    call setline(a:firstLine, theLine)
    "add the delim to the bottom line
    let theLine = getline(a:lastLine)
    let lineHasLeadingTabs = s:HasLeadingTabs(theLine)
    let theLine = s:ConvertLeadingTabsToSpaces(theLine)
    let theLine = s:AddRightDelim(right, theLine)
    if lineHasLeadingTabs
        let theLine = s:ConvertLeadingSpacesToTabs(theLine)
    endif
    call setline(a:lastLine, theLine)
endfunction
function s:CommentLinesSexy(topline, bottomline)
    let left = s:GetSexyComLeft(0, 0)
    let right = s:GetSexyComRight(0, 0)
    "check if we can do a sexy comment with the available delimiters
    if left == -1 || right == -1
        throw 'NERDCommenter.Delimiters exception: cannot perform sexy comments with available delimiters.'
    endif
    "make sure the lines arent already commented sexually
    if !s:CanSexyCommentLines(a:topline, a:bottomline)
        throw 'NERDCommenter.Nesting exception: cannot nest sexy comments'
    endif
    let sexyComMarker = s:GetSexyComMarker(0,0)
    let sexyComMarkerSpaced = s:GetSexyComMarker(1,0)
    " we jam the comment as far to the right as possible
    let leftAlignIndx = s:LeftMostIndx(1, 1, a:topline, a:bottomline)
    "check if we should use the compact style i.e that the left/right
    "delimiters should appear on the first and last lines of the code and not
    "on separate lines above/below the first/last lines of code
    if g:NERDCompactSexyComs
        let spaceString = (g:NERDSpaceDelims ? s:spaceStr : '')
        "comment the top line
        let theLine = getline(a:topline)
        let lineHasTabs = s:HasLeadingTabs(theLine)
        if lineHasTabs
            let theLine = s:ConvertLeadingTabsToSpaces(theLine)
        endif
        let theLine = s:SwapOutterMultiPartDelimsForPlaceHolders(theLine)
        let theLine = s:AddLeftDelimAligned(left . spaceString, theLine, leftAlignIndx)
        if lineHasTabs
            let theLine = s:ConvertLeadingSpacesToTabs(theLine)
        endif
        call setline(a:topline, theLine)
        "comment the bottom line
        if a:bottomline != a:topline
            let theLine = getline(a:bottomline)
            let lineHasTabs = s:HasLeadingTabs(theLine)
            if lineHasTabs
                let theLine = s:ConvertLeadingTabsToSpaces(theLine)
            endif
            let theLine = s:SwapOutterMultiPartDelimsForPlaceHolders(theLine)
        endif
        let theLine = s:AddRightDelim(spaceString . right, theLine)
        if lineHasTabs
            let theLine = s:ConvertLeadingSpacesToTabs(theLine)
        endif
        call setline(a:bottomline, theLine)
    else
        " add the left delimiter one line above the lines that are to be commented
        call cursor(a:topline, 1)
        execute 'normal! O'
        let theLine = repeat(' ', leftAlignIndx) . left
        " Make sure tabs are respected
        if !&expandtab
           let theLine = s:ConvertLeadingSpacesToTabs(theLine)
        endif
        call setline(a:topline, theLine)
        " add the right delimiter after bottom line (we have to add 1 cos we moved
        " the lines down when we added the left delim
        call cursor(a:bottomline+1, 1)
        execute 'normal! o'
        let theLine = repeat(' ', leftAlignIndx) . repeat(' ', strlen(left)-strlen(sexyComMarker)) . right
        " Make sure tabs are respected
        if !&expandtab
           let theLine = s:ConvertLeadingSpacesToTabs(theLine)
        endif
        call setline(a:bottomline+2, theLine)
    endif
    " go thru each line adding the sexyComMarker marker to the start of each
    " line in the appropriate place to align them with the comment delims
    let currentLine = a:topline+1
    while currentLine <= a:bottomline + !g:NERDCompactSexyComs
        " get the line and convert the tabs to spaces
        let theLine = getline(currentLine)
        let lineHasTabs = s:HasLeadingTabs(theLine)
        if lineHasTabs
            let theLine = s:ConvertLeadingTabsToSpaces(theLine)
        endif
        let theLine = s:SwapOutterMultiPartDelimsForPlaceHolders(theLine)
        " add the sexyComMarker
        let theLine = repeat(' ', leftAlignIndx) . repeat(' ', strlen(left)-strlen(sexyComMarker)) . sexyComMarkerSpaced . strpart(theLine, leftAlignIndx)
        if lineHasTabs
            let theLine = s:ConvertLeadingSpacesToTabs(theLine)
        endif
        " set the line and move onto the next one
        call setline(currentLine, theLine)
        let currentLine = currentLine + 1
    endwhile
endfunction
function s:CommentLinesToggle(forceNested, firstLine, lastLine)
    let currentLine = a:firstLine
    while currentLine <= a:lastLine
        " get the next line, check commentability and convert spaces to tabs
        let theLine = getline(currentLine)
        let lineHasLeadingTabs = s:HasLeadingTabs(theLine)
        let theLine = s:ConvertLeadingTabsToSpaces(theLine)
        if s:CanToggleCommentLine(a:forceNested, currentLine)
            "if the user has specified forceNesting then we check to see if we
            "need to switch delimiters for place-holders
            if g:NERDUsePlaceHolders
                let theLine = s:SwapOutterMultiPartDelimsForPlaceHolders(theLine)
            endif
            let theLine = s:AddLeftDelim(s:Left({'space': 1}), theLine)
            let theLine = s:AddRightDelim(s:Right({'space': 1}), theLine)
        endif
        " restore leading tabs if appropriate
        if lineHasLeadingTabs
            let theLine = s:ConvertLeadingSpacesToTabs(theLine)
        endif
        " we are done with this line
        call setline(currentLine, theLine)
        let currentLine = currentLine + 1
    endwhile
endfunction
function s:CommentRegion(topLine, topCol, bottomLine, bottomCol, forceNested)
    "switch delims (if we can) if the current set isnt multipart
    let switchedDelims = 0
    if !s:Multipart() && s:AltMultipart() && !g:NERDAllowAnyVisualDelims
        let switchedDelims = 1
        call s:SwitchToAlternativeDelimiters(0)
    endif
    "if there is only one line in the comment then just do it
    if a:topLine == a:bottomLine
        call s:CommentBlock(a:topLine, a:bottomLine, a:topCol, a:bottomCol, a:forceNested)
    "there are multiple lines in the comment
    else
        "comment the top line
        call s:CommentBlock(a:topLine, a:topLine, a:topCol, strlen(getline(a:topLine)), a:forceNested)
        "comment out all the lines in the middle of the comment
        let topOfRange = a:topLine+1
        let bottomOfRange = a:bottomLine-1
        if topOfRange <= bottomOfRange
            call s:CommentLines(a:forceNested, "none", topOfRange, bottomOfRange)
        endif
        "comment the bottom line
        let bottom = getline(a:bottomLine)
        let numLeadingSpacesTabs = strlen(substitute(bottom, '^\([ \t]*\).*$', '\1', ''))
        call s:CommentBlock(a:bottomLine, a:bottomLine, numLeadingSpacesTabs+1, a:bottomCol, a:forceNested)
    endif
    "stick the cursor back on the char it was on before the comment
    call cursor(a:topLine, a:topCol + strlen(s:Left()) + g:NERDSpaceDelims)
    "if we switched delims then we gotta go back to what they were before
    if switchedDelims == 1
        call s:SwitchToAlternativeDelimiters(0)
    endif
endfunction
function s:InvertComment(firstLine, lastLine)
    " go thru all lines in the given range
    let currentLine = a:firstLine
    while currentLine <= a:lastLine
        let theLine = getline(currentLine)
        let sexyComBounds = s:FindBoundingLinesOfSexyCom(currentLine)
        " if the line is commented normally, uncomment it
        if s:IsCommentedFromStartOfLine(s:Left(), theLine) || s:IsCommentedFromStartOfLine(s:Left({'alt': 1}), theLine)
            call s:UncommentLines(currentLine, currentLine)
            let currentLine = currentLine + 1
        " check if the line is commented sexually
        elseif !empty(sexyComBounds)
            let numLinesBeforeSexyComRemoved = s:NumLinesInBuf()
            call s:UncommentLinesSexy(sexyComBounds[0], sexyComBounds[1])
            "move to the line after last line of the sexy comment
            let numLinesAfterSexyComRemoved = s:NumLinesInBuf()
            let currentLine = sexyComBounds[1] - (numLinesBeforeSexyComRemoved - numLinesAfterSexyComRemoved) + 1
        " the line isnt commented
        else
            call s:CommentLinesToggle(1, currentLine, currentLine)
            let currentLine = currentLine + 1
        endif
    endwhile
endfunction
function! NERDComment(isVisual, type) range
    " we want case sensitivity when commenting
    let oldIgnoreCase = &ignorecase
    set noignorecase
    if !exists("g:did_load_ftplugin") || g:did_load_ftplugin != 1
        call s:NerdEcho("filetype plugins should be enabled. See :help NERDComInstallation and :help :filetype-plugin-on", 0)
    endif
    if a:isVisual
        let firstLine = line("'<")
        let lastLine = line("'>")
        let firstCol = col("'<")
        let lastCol = col("'>") - (&selection == 'exclusive' ? 1 : 0)
    else
        let firstLine = a:firstline
        let lastLine = a:lastline
    endif
    let countWasGiven = (a:isVisual == 0 && firstLine != lastLine)
    let forceNested = (a:type == 'nested' || g:NERDDefaultNesting)
    if a:type == 'norm' || a:type == 'nested'
        if a:isVisual && visualmode() == ""
            call s:CommentBlock(firstLine, lastLine, firstCol, lastCol, forceNested)
        elseif a:isVisual && visualmode() == "v" && (g:NERDCommentWholeLinesInVMode==0 || (g:NERDCommentWholeLinesInVMode==2 && s:HasMultipartDelims()))
            call s:CommentRegion(firstLine, firstCol, lastLine, lastCol, forceNested)
        else
            call s:CommentLines(forceNested, "none", firstLine, lastLine)
        endif
    elseif a:type == 'alignLeft' || a:type == 'alignBoth'
        let align = "none"
        if a:type == "alignLeft"
            let align = "left"
        elseif a:type == "alignBoth"
            let align = "both"
        endif
        call s:CommentLines(forceNested, align, firstLine, lastLine)
    elseif a:type == 'invert'
        call s:InvertComment(firstLine, lastLine)
    elseif a:type == 'sexy'
        try
            call s:CommentLinesSexy(firstLine, lastLine)
        catch /NERDCommenter.Delimiters/
            call s:CommentLines(forceNested, "none", firstLine, lastLine)
        catch /NERDCommenter.Nesting/
            call s:NerdEcho("Sexy comment aborted. Nested sexy cannot be nested", 0)
        endtry
    elseif a:type == 'toggle'
        let theLine = getline(firstLine)
        if s:IsInSexyComment(firstLine) || s:IsCommentedFromStartOfLine(s:Left(), theLine) || s:IsCommentedFromStartOfLine(s:Left({'alt': 1}), theLine)
            call s:UncommentLines(firstLine, lastLine)
        else
            call s:CommentLinesToggle(forceNested, firstLine, lastLine)
        endif
    elseif a:type == 'minimal'
        try
            call s:CommentLinesMinimal(firstLine, lastLine)
        catch /NERDCommenter.Delimiters/
            call s:NerdEcho("Minimal comments can only be used for filetypes that have multipart delimiters.", 0)
        catch /NERDCommenter.Settings/
            call s:NerdEcho("Place holders are required but disabled.", 0)
        endtry
    elseif a:type == 'toEOL'
        call s:SaveScreenState()
        call s:CommentBlock(firstLine, firstLine, col("."), col("$")-1, 1)
        call s:RestoreScreenState()
    elseif a:type == 'append'
        call s:AppendCommentToLine()
    elseif a:type == 'insert'
        call s:PlaceDelimitersAndInsBetween()
    elseif a:type == 'uncomment'
        call s:UncommentLines(firstLine, lastLine)
    elseif a:type == 'yank'
        if a:isVisual
            normal! gvy
        elseif countWasGiven
            execute firstLine .','. lastLine .'yank'
        else
            normal! yy
        endif
        execute firstLine .','. lastLine .'call NERDComment('. a:isVisual .', "norm")'
    endif
    let &ignorecase = oldIgnoreCase
endfunction
function s:PlaceDelimitersAndInsBetween()
    " get the left and right delimiters without any escape chars in them
    let left = s:Left({'space': 1})
    let right = s:Right({'space': 1})
    let theLine = getline(".")
    let lineHasLeadTabs = s:HasLeadingTabs(theLine) || (theLine =~ '^ *$' && !&expandtab)
    "convert tabs to spaces and adjust the cursors column to take this into
    "account
    let untabbedCol = s:UntabbedCol(theLine, col("."))
    call setline(line("."), s:ConvertLeadingTabsToSpaces(theLine))
    call cursor(line("."), untabbedCol)
    " get the len of the right delim
    let lenRight = strlen(right)
    let isDelimOnEOL = col(".") >= strlen(getline("."))
    " if the cursor is in the first col then we gotta insert rather than
    " append the comment delimiters here
    let insOrApp = (col(".")==1 ? 'i' : 'a')
    " place the delimiters down. We do it differently depending on whether
    " there is a left AND right delimiter
    if lenRight > 0
        execute ":normal! " . insOrApp . left . right
        execute ":normal! " . lenRight . "h"
    else
        execute ":normal! " . insOrApp . left
        " if we are tacking the delim on the EOL then we gotta add a space
        " after it cos when we go out of insert mode the cursor will move back
        " one and the user wont be in position to type the comment.
        if isDelimOnEOL
            execute 'normal! a '
        endif
    endif
    normal! l
    "if needed convert spaces back to tabs and adjust the cursors col
    "accordingly
    if lineHasLeadTabs
        let tabbedCol = s:TabbedCol(getline("."), col("."))
        call setline(line("."), s:ConvertLeadingSpacesToTabs(getline(".")))
        call cursor(line("."), tabbedCol)
    endif
    startinsert
endfunction
function s:RemoveDelimiters(left, right, line)
    let l:left = a:left
    let l:right = a:right
    let lenLeft = strlen(left)
    let lenRight = strlen(right)
    let delimsSpaced = (g:NERDSpaceDelims || g:NERDRemoveExtraSpaces)
    let line = a:line
    "look for the left delimiter, if we find it, remove it.
    let leftIndx = s:FindDelimiterIndex(a:left, line)
    if leftIndx != -1
        let line = strpart(line, 0, leftIndx) . strpart(line, leftIndx+lenLeft)
        "if the user has specified that there is a space after the left delim
        "then check for the space and remove it if it is there
        if delimsSpaced && strpart(line, leftIndx, s:lenSpaceStr) == s:spaceStr
            let line = strpart(line, 0, leftIndx) . strpart(line, leftIndx+s:lenSpaceStr)
        endif
    endif
    "look for the right delimiter, if we find it, remove it
    let rightIndx = s:FindDelimiterIndex(a:right, line)
    if rightIndx != -1
        let line = strpart(line, 0, rightIndx) . strpart(line, rightIndx+lenRight)
        "if the user has specified that there is a space before the right delim
        "then check for the space and remove it if it is there
        if delimsSpaced && strpart(line, rightIndx-s:lenSpaceStr, s:lenSpaceStr) == s:spaceStr && s:Multipart()
            let line = strpart(line, 0, rightIndx-s:lenSpaceStr) . strpart(line, rightIndx)
        endif
    endif
    return line
endfunction
function s:UncommentLines(topLine, bottomLine)
    "make local copies of a:firstline and a:lastline and, if need be, swap
    "them around if the top line is below the bottom
    let l:firstline = a:topLine
    let l:lastline = a:bottomLine
    if firstline > lastline
        let firstline = lastline
        let lastline = a:topLine
    endif
    "go thru each line uncommenting each line removing sexy comments
    let currentLine = firstline
    while currentLine <= lastline
        "check the current line to see if it is part of a sexy comment
        let sexyComBounds = s:FindBoundingLinesOfSexyCom(currentLine)
        if !empty(sexyComBounds)
            "we need to store the num lines in the buf before the comment is
            "removed so we know how many lines were removed when the sexy com
            "was removed
            let numLinesBeforeSexyComRemoved = s:NumLinesInBuf()
            call s:UncommentLinesSexy(sexyComBounds[0], sexyComBounds[1])
            "move to the line after last line of the sexy comment
            let numLinesAfterSexyComRemoved = s:NumLinesInBuf()
            let numLinesRemoved = numLinesBeforeSexyComRemoved - numLinesAfterSexyComRemoved
            let currentLine = sexyComBounds[1] - numLinesRemoved + 1
            let lastline = lastline - numLinesRemoved
        "no sexy com was detected so uncomment the line as normal
        else
            call s:UncommentLinesNormal(currentLine, currentLine)
            let currentLine = currentLine + 1
        endif
    endwhile
endfunction
function s:UncommentLinesSexy(topline, bottomline)
    let left = s:GetSexyComLeft(0,1)
    let right = s:GetSexyComRight(0,1)
    "check if it is even possible for sexy comments to exist with the
    "available delimiters
    if left == -1 || right == -1
        throw 'NERDCommenter.Delimiters exception: cannot uncomment sexy comments with available delimiters.'
    endif
    let leftUnEsc = s:GetSexyComLeft(0,0)
    let rightUnEsc = s:GetSexyComRight(0,0)
    let sexyComMarker = s:GetSexyComMarker(0, 1)
    let sexyComMarkerUnEsc = s:GetSexyComMarker(0, 0)
    "the markerOffset is how far right we need to move the sexyComMarker to
    "line it up with the end of the left delim
    let markerOffset = strlen(leftUnEsc)-strlen(sexyComMarkerUnEsc)
    " go thru the intermediate lines of the sexy comment and remove the
    " sexy comment markers (eg the '*'s on the start of line in a c sexy
    " comment)
    let currentLine = a:topline+1
    while currentLine < a:bottomline
        let theLine = getline(currentLine)
        " remove the sexy comment marker from the line. We also remove the
        " space after it if there is one and if appropriate options are set
        let sexyComMarkerIndx = stridx(theLine, sexyComMarkerUnEsc)
        if strpart(theLine, sexyComMarkerIndx+strlen(sexyComMarkerUnEsc), s:lenSpaceStr) == s:spaceStr  && g:NERDSpaceDelims
            let theLine = strpart(theLine, 0, sexyComMarkerIndx - markerOffset) . strpart(theLine, sexyComMarkerIndx+strlen(sexyComMarkerUnEsc)+s:lenSpaceStr)
        else
            let theLine = strpart(theLine, 0, sexyComMarkerIndx - markerOffset) . strpart(theLine, sexyComMarkerIndx+strlen(sexyComMarkerUnEsc))
        endif
        let theLine = s:SwapOutterPlaceHoldersForMultiPartDelims(theLine)
        let theLine = s:ConvertLeadingWhiteSpace(theLine)
        " move onto the next line
        call setline(currentLine, theLine)
        let currentLine = currentLine + 1
    endwhile
    " gotta make a copy of a:bottomline cos we modify the position of the
    " last line  it if we remove the topline
    let bottomline = a:bottomline
    " get the first line so we can remove the left delim from it
    let theLine = getline(a:topline)
    " if the first line contains only the left delim then just delete it
    if theLine =~ '^[ \t]*' . left . '[ \t]*$' && !g:NERDCompactSexyComs
        call cursor(a:topline, 1)
        normal! dd
        let bottomline = bottomline - 1
    " topline contains more than just the left delim
    else
        " remove the delim. If there is a space after it
        " then remove this too if appropriate
        let delimIndx = stridx(theLine, leftUnEsc)
        if strpart(theLine, delimIndx+strlen(leftUnEsc), s:lenSpaceStr) == s:spaceStr && g:NERDSpaceDelims
            let theLine = strpart(theLine, 0, delimIndx) . strpart(theLine, delimIndx+strlen(leftUnEsc)+s:lenSpaceStr)
        else
            let theLine = strpart(theLine, 0, delimIndx) . strpart(theLine, delimIndx+strlen(leftUnEsc))
        endif
        let theLine = s:SwapOutterPlaceHoldersForMultiPartDelims(theLine)
        call setline(a:topline, theLine)
    endif
    " get the last line so we can remove the right delim
    let theLine = getline(bottomline)
    " if the bottomline contains only the right delim then just delete it
    if theLine =~ '^[ \t]*' . right . '[ \t]*$'
        call cursor(bottomline, 1)
        normal! dd
    " the last line contains more than the right delim
    else
        " remove the right delim. If there is a space after it and
        " if the appropriate options are set then remove this too.
        let delimIndx = s:LastIndexOfDelim(rightUnEsc, theLine)
        if strpart(theLine, delimIndx+strlen(leftUnEsc), s:lenSpaceStr) == s:spaceStr  && g:NERDSpaceDelims
            let theLine = strpart(theLine, 0, delimIndx) . strpart(theLine, delimIndx+strlen(rightUnEsc)+s:lenSpaceStr)
        else
            let theLine = strpart(theLine, 0, delimIndx) . strpart(theLine, delimIndx+strlen(rightUnEsc))
        endif
        " if the last line also starts with a sexy comment marker then we
        " remove this as well
        if theLine =~ '^[ \t]*' . sexyComMarker
            " remove the sexyComMarker. If there is a space after it then
            " remove that too
            let sexyComMarkerIndx = stridx(theLine, sexyComMarkerUnEsc)
            if strpart(theLine, sexyComMarkerIndx+strlen(sexyComMarkerUnEsc), s:lenSpaceStr) == s:spaceStr  && g:NERDSpaceDelims
                let theLine = strpart(theLine, 0, sexyComMarkerIndx - markerOffset ) . strpart(theLine, sexyComMarkerIndx+strlen(sexyComMarkerUnEsc)+s:lenSpaceStr)
            else
                let theLine = strpart(theLine, 0, sexyComMarkerIndx - markerOffset ) . strpart(theLine, sexyComMarkerIndx+strlen(sexyComMarkerUnEsc))
            endif
        endif
        let theLine = s:SwapOutterPlaceHoldersForMultiPartDelims(theLine)
        call setline(bottomline, theLine)
    endif
endfunction
function s:UncommentLineNormal(line)
    let line = a:line
    "get the comment status on the line so we know how it is commented
    let lineCommentStatus =  s:IsCommentedOuttermost(s:Left(), s:Right(), s:Left({'alt': 1}), s:Right({'alt': 1}), line)
    "it is commented with s:Left() and s:Right() so remove these delims
    if lineCommentStatus == 1
        let line = s:RemoveDelimiters(s:Left(), s:Right(), line)
    "it is commented with s:Left({'alt': 1}) and s:Right({'alt': 1}) so remove these delims
    elseif lineCommentStatus == 2 && g:NERDRemoveAltComs
        let line = s:RemoveDelimiters(s:Left({'alt': 1}), s:Right({'alt': 1}), line)
    "it is not properly commented with any delims so we check if it has
    "any random left or right delims on it and remove the outtermost ones
    else
        "get the positions of all delim types on the line
        let indxLeft = s:FindDelimiterIndex(s:Left(), line)
        let indxLeftAlt = s:FindDelimiterIndex(s:Left({'alt': 1}), line)
        let indxRight = s:FindDelimiterIndex(s:Right(), line)
        let indxRightAlt = s:FindDelimiterIndex(s:Right({'alt': 1}), line)
        "remove the outter most left comment delim
        if indxLeft != -1 && (indxLeft < indxLeftAlt || indxLeftAlt == -1)
            let line = s:RemoveDelimiters(s:Left(), '', line)
        elseif indxLeftAlt != -1
            let line = s:RemoveDelimiters(s:Left({'alt': 1}), '', line)
        endif
        "remove the outter most right comment delim
        if indxRight != -1 && (indxRight < indxRightAlt || indxRightAlt == -1)
            let line = s:RemoveDelimiters('', s:Right(), line)
        elseif indxRightAlt != -1
            let line = s:RemoveDelimiters('', s:Right({'alt': 1}), line)
        endif
    endif
    let indxLeft = s:FindDelimiterIndex(s:Left(), line)
    let indxLeftAlt = s:FindDelimiterIndex(s:Left({'alt': 1}), line)
    let indxLeftPlace = s:FindDelimiterIndex(g:NERDLPlace, line)
    let indxRightPlace = s:FindDelimiterIndex(g:NERDRPlace, line)
    let indxRightAlt = s:FindDelimiterIndex(s:Right({'alt': 1}), line)
    let indxRightPlace = s:FindDelimiterIndex(g:NERDRPlace, line)
    let right = s:Right()
    let left = s:Left()
    if !s:Multipart()
        let right = s:Right({'alt': 1})
        let left = s:Left({'alt': 1})
    endif
    "if there are place-holders on the line then we check to see if they are
    "the outtermost delimiters on the line. If so then we replace them with
    "real delimiters
    if indxLeftPlace != -1
        if (indxLeftPlace < indxLeft || indxLeft==-1) && (indxLeftPlace < indxLeftAlt || indxLeftAlt==-1)
            let line = s:ReplaceDelims(g:NERDLPlace, g:NERDRPlace, left, right, line)
        endif
    elseif indxRightPlace != -1
        if (indxRightPlace < indxLeft || indxLeft==-1) && (indxLeftPlace < indxLeftAlt || indxLeftAlt==-1)
            let line = s:ReplaceDelims(g:NERDLPlace, g:NERDRPlace, left, right, line)
        endif
    endif
    let line = s:ConvertLeadingWhiteSpace(line)
    return line
endfunction
function s:UncommentLinesNormal(topline, bottomline)
    let currentLine = a:topline
    while currentLine <= a:bottomline
        let line = getline(currentLine)
        call setline(currentLine, s:UncommentLineNormal(line))
        let currentLine = currentLine + 1
    endwhile
endfunction
function s:AddLeftDelim(delim, theLine)
    return substitute(a:theLine, '^\([ \t]*\)', '\1' . a:delim, '')
endfunction
function s:AddLeftDelimAligned(delim, theLine, alignIndx)
    "if the line is not long enough then bung some extra spaces on the front
    "so we can align the delim properly
    let theLine = a:theLine
    if strlen(theLine) < a:alignIndx
        let theLine = repeat(' ', a:alignIndx - strlen(theLine))
    endif
    return strpart(theLine, 0, a:alignIndx) . a:delim . strpart(theLine, a:alignIndx)
endfunction
function s:AddRightDelim(delim, theLine)
    if a:delim == ''
        return a:theLine
    else
        return substitute(a:theLine, '$', a:delim, '')
    endif
endfunction
function s:AddRightDelimAligned(delim, theLine, alignIndx)
    if a:delim == ""
        return a:theLine
    else
        " when we align the right delim we are just adding spaces
        " so we get a string containing the needed spaces (it
        " could be empty)
        let extraSpaces = ''
        let extraSpaces = repeat(' ', a:alignIndx-strlen(a:theLine))
        " add the right delim
        return substitute(a:theLine, '$', extraSpaces . a:delim, '')
    endif
endfunction
function s:AltMultipart()
    return b:NERDCommenterDelims['rightAlt'] != ''
endfunction
function s:CanCommentLine(forceNested, lineNum)
    let theLine = getline(a:lineNum)
    " make sure we don't comment lines that are just spaces or tabs or empty.
    if theLine =~ "^[ \t]*$"
        return 0
    endif
    "if the line is part of a sexy comment then just flag it...
    if s:IsInSexyComment(a:lineNum)
        return 0
    endif
    let isCommented = s:IsCommentedNormOrSexy(a:lineNum)
    "if the line isnt commented return true
    if !isCommented
        return 1
    endif
    "if the line is commented but nesting is allowed then return true
    if a:forceNested && (!s:Multipart() || g:NERDUsePlaceHolders)
        return 1
    endif
    return 0
endfunction
function s:CanPlaceCursor(line, col)
    let c = col(".")
    let l = line(".")
    call cursor(a:line, a:col)
    let success = (line(".") == a:line && col(".") == a:col)
    call cursor(l,c)
    return success
endfunction
function s:CanSexyCommentLines(topline, bottomline)
    " see if the selected regions have any sexy comments
    let currentLine = a:topline
    while(currentLine <= a:bottomline)
        if s:IsInSexyComment(currentLine)
            return 0
        endif
        let currentLine = currentLine + 1
    endwhile
    return 1
endfunction
function s:CanToggleCommentLine(forceNested, lineNum)
    let theLine = getline(a:lineNum)
    if (s:IsCommentedFromStartOfLine(s:Left(), theLine) || s:IsCommentedFromStartOfLine(s:Left({'alt': 1}), theLine)) && !a:forceNested
        return 0
    endif
    " make sure we don't comment lines that are just spaces or tabs or empty.
    if theLine =~ "^[ \t]*$"
        return 0
    endif
    "if the line is part of a sexy comment then just flag it...
    if s:IsInSexyComment(a:lineNum)
        return 0
    endif
    return 1
endfunction
function s:ConvertLeadingSpacesToTabs(line)
    let toReturn  = a:line
    while toReturn =~ '^\t*' . s:TabSpace() . '\(.*\)$'
        let toReturn = substitute(toReturn, '^\(\t*\)' . s:TabSpace() . '\(.*\)$'  ,  '\1\t\2' , "")
    endwhile
    return toReturn
endfunction
function s:ConvertLeadingTabsToSpaces(line)
    let toReturn  = a:line
    while toReturn =~ '^\( *\)\t'
        let toReturn = substitute(toReturn, '^\( *\)\t',  '\1' . s:TabSpace() , "")
    endwhile
    return toReturn
endfunction
function s:ConvertLeadingWhiteSpace(line)
    let toReturn = a:line
    while toReturn =~ '^ *\t'
        let toReturn = substitute(toReturn, '^ *\zs\t\ze', s:TabSpace(), "g")
    endwhile
    if !&expandtab
        let toReturn = s:ConvertLeadingSpacesToTabs(toReturn)
    endif
    return toReturn
endfunction
function s:CountNonESCedOccurances(str, searchstr, escChar)
    "get the index of the first occurrence of searchstr
    let indx = stridx(a:str, a:searchstr)
    "if there is an instance of searchstr in str process it
    if indx != -1
        "get the remainder of str after this instance of searchstr is removed
        let lensearchstr = strlen(a:searchstr)
        let strLeft = strpart(a:str, indx+lensearchstr)
        "if this instance of searchstr is not escaped, add one to the count
        "and recurse. If it is escaped, just recurse
        if !s:IsEscaped(a:str, indx, a:escChar)
            return 1 + s:CountNonESCedOccurances(strLeft, a:searchstr, a:escChar)
        else
            return s:CountNonESCedOccurances(strLeft, a:searchstr, a:escChar)
        endif
    endif
endfunction
function s:DoesBlockHaveDelim(delim, top, bottom)
    let currentLine = a:top
    while currentLine < a:bottom
        let theline = getline(currentLine)
        if s:FindDelimiterIndex(a:delim, theline) != -1
            return 1
        endif
        let currentLine = currentLine + 1
    endwhile
    return 0
endfunction
function s:DoesBlockHaveMultipartDelim(top, bottom)
    if s:HasMultipartDelims()
        if s:Multipart()
            return s:DoesBlockHaveDelim(s:Left(), a:top, a:bottom) || s:DoesBlockHaveDelim(s:Right(), a:top, a:bottom)
        else
            return s:DoesBlockHaveDelim(s:Left({'alt': 1}), a:top, a:bottom) || s:DoesBlockHaveDelim(s:Right({'alt': 1}), a:top, a:bottom)
        endif
    endif
    return 0
endfunction
function s:Esc(str)
    let charsToEsc = '*/\."&$+'
    return escape(a:str, charsToEsc)
endfunction
function s:FindDelimiterIndex(delimiter, line)
    "make sure the delimiter isnt empty otherwise we go into an infinite loop.
    if a:delimiter == ""
        return -1
    endif
    let l:delimiter = a:delimiter
    let lenDel = strlen(l:delimiter)
    "get the index of the first occurrence of the delimiter
    let delIndx = stridx(a:line, l:delimiter)
    "keep looping thru the line till we either find a real comment delimiter
    "or run off the EOL
    while delIndx != -1
        "if we are not off the EOL get the str before the possible delimiter
        "in question and check if it really is a delimiter. If it is, return
        "its position
        if delIndx != -1
            if s:IsDelimValid(l:delimiter, delIndx, a:line)
                return delIndx
            endif
        endif
        "we have not yet found a real comment delimiter so move past the
        "current one we are lookin at
        let restOfLine = strpart(a:line, delIndx + lenDel)
        let distToNextDelim = stridx(restOfLine , l:delimiter)
        "if distToNextDelim is -1 then there is no more potential delimiters
        "on the line so set delIndx to -1. Otherwise, move along the line by
        "distToNextDelim
        if distToNextDelim == -1
            let delIndx = -1
        else
            let delIndx = delIndx + lenDel + distToNextDelim
        endif
    endwhile
    "there is no comment delimiter on this line
    return -1
endfunction
function s:FindBoundingLinesOfSexyCom(lineNum)
    "find which delimiters to look for as the start/end delims of the comment
    let left = ''
    let right = ''
    if s:Multipart()
        let left = s:Left({'esc': 1})
        let right = s:Right({'esc': 1})
    elseif s:AltMultipart()
        let left = s:Left({'alt': 1, 'esc': 1})
        let right = s:Right({'alt': 1, 'esc': 1})
    else
        return []
    endif
    let sexyComMarker = s:GetSexyComMarker(0, 1)
    "initialise the top/bottom line numbers of the sexy comment to -1
    let top = -1
    let bottom = -1
    let currentLine = a:lineNum
    while top == -1 || bottom == -1
        let theLine = getline(currentLine)
        "check if the current line is the top of the sexy comment
        if currentLine <= a:lineNum && theLine =~ '^[ \t]*' . left && theLine !~ '.*' . right && currentLine < s:NumLinesInBuf()
            let top = currentLine
            let currentLine = a:lineNum
        "check if the current line is the bottom of the sexy comment
        elseif theLine =~ '^[ \t]*' . right && theLine !~ '.*' . left && currentLine > 1
            let bottom = currentLine
        "the right delimiter is on the same line as the last sexyComMarker
        elseif theLine =~ '^[ \t]*' . sexyComMarker . '.*' . right
            let bottom = currentLine
        "we have not found the top or bottom line so we assume currentLine is an
        "intermediate line and look to prove otherwise
        else
            "if the line doesnt start with a sexyComMarker then it is not a sexy
            "comment
            if theLine !~ '^[ \t]*' . sexyComMarker
                return []
            endif
        endif
        "if top is -1 then we havent found the top yet so keep looking up
        if top == -1
            let currentLine = currentLine - 1
        "if we have found the top line then go down looking for the bottom
        else
            let currentLine = currentLine + 1
        endif
    endwhile
    return [top, bottom]
endfunction
function s:GetSexyComMarker(space, esc)
    let sexyComMarker = b:NERDSexyComMarker
    "if there is no hardcoded marker then we find one
    if sexyComMarker == ''
        "if the filetype has c style comments then use standard c sexy
        "comments
        if s:HasCStyleComments()
            let sexyComMarker = '*'
        else
            "find a comment marker by getting the longest available left delim
            "(that has a corresponding right delim) and taking the last char
            let lenLeft = strlen(s:Left())
            let lenLeftAlt = strlen(s:Left({'alt': 1}))
            let left = ''
            let right = ''
            if s:Multipart() && lenLeft >= lenLeftAlt
                let left = s:Left()
            elseif s:AltMultipart()
                let left = s:Left({'alt': 1})
            else
                return -1
            endif
            "get the last char of left
            let sexyComMarker = strpart(left, strlen(left)-1)
        endif
    endif
    if a:space && g:NERDSpaceDelims
        let sexyComMarker = sexyComMarker . s:spaceStr
    endif
    if a:esc
        let sexyComMarker = s:Esc(sexyComMarker)
    endif
    return sexyComMarker
endfunction
function s:GetSexyComLeft(space, esc)
    let lenLeft = strlen(s:Left())
    let lenLeftAlt = strlen(s:Left({'alt': 1}))
    let left = ''
    "assume c style sexy comments if possible
    if s:HasCStyleComments()
        let left = '/*'
    else
        "grab the longest left delim that has a right
        if s:Multipart() && lenLeft >= lenLeftAlt
            let left = s:Left()
        elseif s:AltMultipart()
            let left = s:Left({'alt': 1})
        else
            return -1
        endif
    endif
    if a:space && g:NERDSpaceDelims
        let left = left . s:spaceStr
    endif
    if a:esc
        let left = s:Esc(left)
    endif
    return left
endfunction
function s:GetSexyComRight(space, esc)
    let lenLeft = strlen(s:Left())
    let lenLeftAlt = strlen(s:Left({'alt': 1}))
    let right = ''
    "assume c style sexy comments if possible
    if s:HasCStyleComments()
        let right = '*/'
    else
        "grab the right delim that pairs with the longest left delim
        if s:Multipart() && lenLeft >= lenLeftAlt
            let right = s:Right()
        elseif s:AltMultipart()
            let right = s:Right({'alt': 1})
        else
            return -1
        endif
    endif
    if a:space && g:NERDSpaceDelims
        let right = s:spaceStr . right
    endif
    if a:esc
        let right = s:Esc(right)
    endif
    return right
endfunction
function s:HasMultipartDelims()
    return s:Multipart() || s:AltMultipart()
endfunction
function s:HasLeadingTabs(...)
    for s in a:000
        if s =~ '^\t.*'
            return 1
        end
    endfor
    return 0
endfunction
function s:HasCStyleComments()
    return (s:Left() == '/*' && s:Right() == '*/') || (s:Left({'alt': 1}) == '/*' && s:Right({'alt': 1}) == '*/')
endfunction
function s:IsCommentedNormOrSexy(lineNum)
    let theLine = getline(a:lineNum)
    "if the line is commented normally return 1
    if s:IsCommented(s:Left(), s:Right(), theLine) || s:IsCommented(s:Left({'alt': 1}), s:Right({'alt': 1}), theLine)
        return 1
    endif
    "if the line is part of a sexy comment return 1
    if s:IsInSexyComment(a:lineNum)
        return 1
    endif
    return 0
endfunction
function s:IsCommented(left, right, line)
    "if the line isnt commented return true
    if s:FindDelimiterIndex(a:left, a:line) != -1 && (s:FindDelimiterIndex(a:right, a:line) != -1 || !s:Multipart())
        return 1
    endif
    return 0
endfunction
function s:IsCommentedFromStartOfLine(left, line)
    let theLine = s:ConvertLeadingTabsToSpaces(a:line)
    let numSpaces = strlen(substitute(theLine, '^\( *\).*$', '\1', ''))
    let delimIndx = s:FindDelimiterIndex(a:left, theLine)
    return delimIndx == numSpaces
endfunction
function s:IsCommentedOuttermost(left, right, leftAlt, rightAlt, line)
    "get the first positions of the left delims and the last positions of the
    "right delims
    let indxLeft = s:FindDelimiterIndex(a:left, a:line)
    let indxLeftAlt = s:FindDelimiterIndex(a:leftAlt, a:line)
    let indxRight = s:LastIndexOfDelim(a:right, a:line)
    let indxRightAlt = s:LastIndexOfDelim(a:rightAlt, a:line)
    "check if the line has a left delim before a leftAlt delim
    if (indxLeft <= indxLeftAlt || indxLeftAlt == -1) && indxLeft != -1
        "check if the line has a right delim after any rightAlt delim
        if (indxRight > indxRightAlt && indxRight > indxLeft) || !s:Multipart()
            return 1
        endif
        "check if the line has a leftAlt delim before a left delim
    elseif (indxLeftAlt <= indxLeft || indxLeft == -1) && indxLeftAlt != -1
        "check if the line has a rightAlt delim after any right delim
        if (indxRightAlt > indxRight && indxRightAlt > indxLeftAlt) || !s:AltMultipart()
            return 2
        endif
    else
        return 0
    endif
    return 0
endfunction
function s:IsDelimValid(delimiter, delIndx, line)
    "get the delimiter without the escchars
    let l:delimiter = a:delimiter
    "get the strings before and after the delimiter
    let preComStr = strpart(a:line, 0, a:delIndx)
    let postComStr = strpart(a:line, a:delIndx+strlen(delimiter))
    "to check if the delimiter is real, make sure it isnt preceded by
    "an odd number of quotes and followed by the same (which would indicate
    "that it is part of a string and therefore is not a comment)
    if !s:IsNumEven(s:CountNonESCedOccurances(preComStr, '"', "\\")) && !s:IsNumEven(s:CountNonESCedOccurances(postComStr, '"', "\\"))
        return 0
    endif
    if !s:IsNumEven(s:CountNonESCedOccurances(preComStr, "'", "\\")) && !s:IsNumEven(s:CountNonESCedOccurances(postComStr, "'", "\\"))
        return 0
    endif
    if !s:IsNumEven(s:CountNonESCedOccurances(preComStr, "`", "\\")) && !s:IsNumEven(s:CountNonESCedOccurances(postComStr, "`", "\\"))
        return 0
    endif
    "if the comment delimiter is escaped, assume it isnt a real delimiter
    if s:IsEscaped(a:line, a:delIndx, "\\")
        return 0
    endif
    "vim comments are so fuckin stupid!! Why the hell do they have comment
    "delimiters that are used elsewhere in the syntax?!?! We need to check
    "some conditions especially for vim
    if &filetype == "vim"
        if !s:IsNumEven(s:CountNonESCedOccurances(preComStr, '"', "\\"))
            return 0
        endif
        "if the delimiter is on the very first char of the line or is the
        "first non-tab/space char on the line then it is a valid comment delimiter
        if a:delIndx == 0 || a:line =~ "^[ \t]\\{" . a:delIndx . "\\}\".*$"
            return 1
        endif
        let numLeftParen =s:CountNonESCedOccurances(preComStr, "(", "\\")
        let numRightParen =s:CountNonESCedOccurances(preComStr, ")", "\\")
        "if the quote is inside brackets then assume it isnt a comment
        if numLeftParen > numRightParen
            return 0
        endif
        "if the line has an even num of unescaped "'s then we can assume that
        "any given " is not a comment delimiter
        if s:IsNumEven(s:CountNonESCedOccurances(a:line, "\"", "\\"))
            return 0
        endif
    endif
    return 1
endfunction
function s:IsNumEven(num)
    return (a:num % 2) == 0
endfunction
function s:IsEscaped(str, indx, escChar)
    "initialise numEscChars to 0 and look at the char before indx
    let numEscChars = 0
    let curIndx = a:indx-1
    "keep going back thru str until we either reach the start of the str or
    "run out of esc chars
    while curIndx >= 0 && strpart(a:str, curIndx, 1) == a:escChar
        "we have found another esc char so add one to the count and move left
        "one char
        let numEscChars  = numEscChars + 1
        let curIndx = curIndx - 1
    endwhile
    "if there is an odd num of esc chars directly before the char at indx then
    "the char at indx is escaped
    return !s:IsNumEven(numEscChars)
endfunction
function s:IsInSexyComment(line)
    return !empty(s:FindBoundingLinesOfSexyCom(a:line))
endfunction
function s:IsSexyComment(topline, bottomline)
    "get the delim set that would be used for a sexy comment
    let left = ''
    let right = ''
    if s:Multipart()
        let left = s:Left()
        let right = s:Right()
    elseif s:AltMultipart()
        let left = s:Left({'alt': 1})
        let right = s:Right({'alt': 1})
    else
        return 0
    endif
    "swap the top and bottom line numbers around if need be
    let topline = a:topline
    let bottomline = a:bottomline
    if bottomline < topline
        topline = bottomline
        bottomline = a:topline
    endif
    "if there is < 2 lines in the comment it cannot be sexy
    if (bottomline - topline) <= 0
        return 0
    endif
    "if the top line doesnt begin with a left delim then the comment isnt sexy
    if getline(a:topline) !~ '^[ \t]*' . left
        return 0
    endif
    "if there is a right delim on the top line then this isnt a sexy comment
    if s:FindDelimiterIndex(right, getline(a:topline)) != -1
        return 0
    endif
    "if there is a left delim on the bottom line then this isnt a sexy comment
    if s:FindDelimiterIndex(left, getline(a:bottomline)) != -1
        return 0
    endif
    "if the bottom line doesnt begin with a right delim then the comment isnt
    "sexy
    if getline(a:bottomline) !~ '^.*' . right . '$'
        return 0
    endif
    let sexyComMarker = s:GetSexyComMarker(0, 1)
    "check each of the intermediate lines to make sure they start with a
    "sexyComMarker
    let currentLine = a:topline+1
    while currentLine < a:bottomline
        let theLine = getline(currentLine)
        if theLine !~ '^[ \t]*' . sexyComMarker
            return 0
        endif
        "if there is a right delim in an intermediate line then the block isnt
        "a sexy comment
        if s:FindDelimiterIndex(right, theLine) != -1
            return 0
        endif
        let currentLine = currentLine + 1
    endwhile
    "we have not found anything to suggest that this isnt a sexy comment so
    return 1
endfunction
function s:LastIndexOfDelim(delim, str)
    let delim = a:delim
    let lenDelim = strlen(delim)
    "set index to the first occurrence of delim. If there is no occurrence then
    "bail
    let indx = s:FindDelimiterIndex(delim, a:str)
    if indx == -1
        return -1
    endif
    "keep moving to the next instance of delim in str till there is none left
    while 1
        "search for the next delim after the previous one
        let searchStr = strpart(a:str, indx+lenDelim)
        let indx2 = s:FindDelimiterIndex(delim, searchStr)
        "if we find a delim update indx to record the position of it, if we
        "dont find another delim then indx is the last one so break out of
        "this loop
        if indx2 != -1
            let indx = indx + indx2 + lenDelim
        else
            break
        endif
    endwhile
    return indx
endfunction
function s:Left(...)
    let params = a:0 ? a:1 : {}
    let delim = has_key(params, 'alt') ? b:NERDCommenterDelims['leftAlt'] : b:NERDCommenterDelims['left'] 
    if delim == ''
        return ''
    endif
    if has_key(params, 'space') && g:NERDSpaceDelims
        let delim = delim . s:spaceStr
    endif
    if has_key(params, 'esc')
        let delim = s:Esc(delim)
    endif
    return delim
endfunction
function s:LeftMostIndx(countCommentedLines, countEmptyLines, topline, bottomline)
    " declare the left most index as an extreme value
    let leftMostIndx = 1000
    " go thru the block line by line updating leftMostIndx
    let currentLine = a:topline
    while currentLine <= a:bottomline
        " get the next line and if it is allowed to be commented, or is not
        " commented, check it
        let theLine = getline(currentLine)
        if a:countEmptyLines || theLine !~ '^[ \t]*$'
            if a:countCommentedLines || (!s:IsCommented(s:Left(), s:Right(), theLine) && !s:IsCommented(s:Left({'alt': 1}), s:Right({'alt': 1}), theLine))
                " convert spaces to tabs and get the number of leading spaces for
                " this line and update leftMostIndx if need be
                let theLine = s:ConvertLeadingTabsToSpaces(theLine)
                let leadSpaceOfLine = strlen( substitute(theLine, '\(^[ \t]*\).*$','\1','') )
                if leadSpaceOfLine < leftMostIndx
                    let leftMostIndx = leadSpaceOfLine
                endif
            endif
        endif
        " move on to the next line
        let currentLine = currentLine + 1
    endwhile
    if leftMostIndx == 1000
        return 0
    else
        return leftMostIndx
    endif
endfunction
function s:Multipart()
    return s:Right() != ''
endfunction
function s:NerdEcho(msg, typeOfMsg)
    if a:typeOfMsg == 0
        echohl WarningMsg
        echom 'NERDCommenter:' . a:msg
        echohl None
    elseif a:typeOfMsg == 1
        echom 'NERDCommenter:' . a:msg
    endif
endfunction
function s:NumberOfLeadingTabs(s)
    return strlen(substitute(a:s, '^\(\t*\).*$', '\1', ""))
endfunction
function s:NumLinesInBuf()
    return line('$')
endfunction
function s:ReplaceDelims(toReplace1, toReplace2, replacor1, replacor2, str)
    let line = s:ReplaceLeftMostDelim(a:toReplace1, a:replacor1, a:str)
    let line = s:ReplaceRightMostDelim(a:toReplace2, a:replacor2, line)
    return line
endfunction
function s:ReplaceLeftMostDelim(toReplace, replacor, str)
    let toReplace = a:toReplace
    let replacor = a:replacor
    "get the left most occurrence of toReplace
    let indxToReplace = s:FindDelimiterIndex(toReplace, a:str)
    "if there IS an occurrence of toReplace in str then replace it and return
    "the resulting string
    if indxToReplace != -1
        let line = strpart(a:str, 0, indxToReplace) . replacor . strpart(a:str, indxToReplace+strlen(toReplace))
        return line
    endif
    return a:str
endfunction
function s:ReplaceRightMostDelim(toReplace, replacor, str)
    let toReplace = a:toReplace
    let replacor = a:replacor
    let lenToReplace = strlen(toReplace)
    "get the index of the last delim in str
    let indxToReplace = s:LastIndexOfDelim(toReplace, a:str)
    "if there IS a delimiter in str, replace it and return the result
    let line = a:str
    if indxToReplace != -1
        let line = strpart(a:str, 0, indxToReplace) . replacor . strpart(a:str, indxToReplace+strlen(toReplace))
    endif
    return line
endfunction
function s:RestoreScreenState()
    if !exists("t:NERDComOldTopLine") || !exists("t:NERDComOldPos")
        throw 'NERDCommenter exception: cannot restore screen'
    endif
    call cursor(t:NERDComOldTopLine, 0)
    normal! zt
    call setpos(".", t:NERDComOldPos)
endfunction
function s:Right(...)
    let params = a:0 ? a:1 : {}
    let delim = has_key(params, 'alt') ? b:NERDCommenterDelims['rightAlt'] : b:NERDCommenterDelims['right'] 
    if delim == ''
        return ''
    endif
    if has_key(params, 'space') && g:NERDSpaceDelims
        let delim = s:spaceStr . delim
    endif
    if has_key(params, 'esc')
        let delim = s:Esc(delim)
    endif
    return delim
endfunction
function s:RightMostIndx(countCommentedLines, countEmptyLines, topline, bottomline)
    let rightMostIndx = -1
    " go thru the block line by line updating rightMostIndx
    let currentLine = a:topline
    while currentLine <= a:bottomline
        " get the next line and see if it is commentable, otherwise it doesnt
        " count
        let theLine = getline(currentLine)
        if a:countEmptyLines || theLine !~ '^[ \t]*$'
            if a:countCommentedLines || (!s:IsCommented(s:Left(), s:Right(), theLine) && !s:IsCommented(s:Left({'alt': 1}), s:Right({'alt': 1}), theLine))
                " update rightMostIndx if need be
                let theLine = s:ConvertLeadingTabsToSpaces(theLine)
                let lineLen = strlen(theLine)
                if lineLen > rightMostIndx
                    let rightMostIndx = lineLen
                endif
            endif
        endif
        " move on to the next line
        let currentLine = currentLine + 1
    endwhile
    return rightMostIndx
endfunction
function s:SaveScreenState()
    let t:NERDComOldPos = getpos(".")
    let t:NERDComOldTopLine = line("w0")
endfunction
function s:SwapOutterMultiPartDelimsForPlaceHolders(line)
    " find out if the line is commented using normal delims and/or
    " alternate ones
    let isCommented = s:IsCommented(s:Left(), s:Right(), a:line)
    let isCommentedAlt = s:IsCommented(s:Left({'alt': 1}), s:Right({'alt': 1}), a:line)
    let line2 = a:line
    "if the line is commented and there is a right delimiter, replace
    "the delims with place-holders
    if isCommented && s:Multipart()
        let line2 = s:ReplaceDelims(s:Left(), s:Right(), g:NERDLPlace, g:NERDRPlace, a:line)
    "similarly if the line is commented with the alternative
    "delimiters
    elseif isCommentedAlt && s:AltMultipart()
        let line2 = s:ReplaceDelims(s:Left({'alt': 1}), s:Right({'alt': 1}), g:NERDLPlace, g:NERDRPlace, a:line)
    endif
    return line2
endfunction
function s:SwapOutterPlaceHoldersForMultiPartDelims(line)
    let left = ''
    let right = ''
    if s:Multipart()
        let left = s:Left()
        let right = s:Right()
    elseif s:AltMultipart()
        let left = s:Left({'alt': 1})
        let right = s:Right({'alt': 1})
    endif
    let line = s:ReplaceDelims(g:NERDLPlace, g:NERDRPlace, left, right, a:line)
    return line
endfunction
function s:TabbedCol(line, col)
    let lineTruncated = strpart(a:line, 0, a:col)
    let lineSpacesToTabs = substitute(lineTruncated, s:TabSpace(), '\t', 'g')
    return strlen(lineSpacesToTabs)
endfunction
function s:TabSpace()
    let tabSpace = ""
    let spacesPerTab = &tabstop
    while spacesPerTab > 0
        let tabSpace = tabSpace . " "
        let spacesPerTab = spacesPerTab - 1
    endwhile
    return tabSpace
endfunction
function s:UnEsc(str, escChar)
    return substitute(a:str, a:escChar, "", "g")
endfunction
function s:UntabbedCol(line, col)
    let lineTruncated = strpart(a:line, 0, a:col)
    let lineTabsToSpaces = substitute(lineTruncated, '\t', s:TabSpace(), 'g')
    return strlen(lineTabsToSpaces)
endfunction
nnoremap <plug>NERDCommenterAltDelims :call <SID>SwitchToAlternativeDelimiters(1)<cr>
nnoremap <silent> <plug>NERDCommenterComment :call NERDComment(0, "norm")<cr>
vnoremap <silent> <plug>NERDCommenterComment <ESC>:call NERDComment(1, "norm")<cr>
nnoremap <silent> <plug>NERDCommenterToggle :call NERDComment(0, "toggle")<cr>
vnoremap <silent> <plug>NERDCommenterToggle <ESC>:call NERDComment(1, "toggle")<cr>
nnoremap <silent> <plug>NERDCommenterMinimal :call NERDComment(0, "minimal")<cr>
vnoremap <silent> <plug>NERDCommenterMinimal <ESC>:call NERDComment(1, "minimal")<cr>
nnoremap <silent> <plug>NERDCommenterSexy :call NERDComment(0, "sexy")<CR>
vnoremap <silent> <plug>NERDCommenterSexy <ESC>:call NERDComment(1, "sexy")<CR>
nnoremap <silent> <plug>NERDCommenterInvert :call NERDComment(0, "invert")<CR>
vnoremap <silent> <plug>NERDCommenterInvert <ESC>:call NERDComment(1, "invert")<CR>
nmap <silent> <plug>NERDCommenterYank :call NERDComment(0, "yank")<CR>
vmap <silent> <plug>NERDCommenterYank <ESC>:call NERDComment(1, "yank")<CR>
nnoremap <silent> <plug>NERDCommenterAlignLeft :call NERDComment(0, "alignLeft")<cr>
vnoremap <silent> <plug>NERDCommenterAlignLeft <ESC>:call NERDComment(1, "alignLeft")<cr>
nnoremap <silent> <plug>NERDCommenterAlignBoth :call NERDComment(0, "alignBoth")<cr>
vnoremap <silent> <plug>NERDCommenterAlignBoth <ESC>:call NERDComment(1, "alignBoth")<cr>
nnoremap <silent> <plug>NERDCommenterNest :call NERDComment(0, "nested")<cr>
vnoremap <silent> <plug>NERDCommenterNest <ESC>:call NERDComment(1, "nested")<cr>
nnoremap <silent> <plug>NERDCommenterUncomment :call NERDComment(0, "uncomment")<cr>
vnoremap <silent> <plug>NERDCommenterUncomment :call NERDComment(1, "uncomment")<cr>
nnoremap <silent> <plug>NERDCommenterToEOL :call NERDComment(0, "toEOL")<cr>
nmap <silent> <plug>NERDCommenterAppend :call NERDComment(0, "append")<cr>
inoremap <silent> <plug>NERDCommenterInInsert <SPACE><BS><ESC>:call NERDComment(0, "insert")<CR>
function! s:CreateMaps(target, combo)
    if !hasmapto(a:target, 'n')
        exec 'nmap ' . a:combo . ' ' . a:target
    endif
    if !hasmapto(a:target, 'v')
        exec 'vmap ' . a:combo . ' ' . a:target
    endif
endfunction
if g:NERDCreateDefaultMappings
    call s:CreateMaps('<plug>NERDCommenterComment',    '<leader>cc')
    call s:CreateMaps('<plug>NERDCommenterToggle',     '<leader>c<space>')
    call s:CreateMaps('<plug>NERDCommenterMinimal',    '<leader>cm')
    call s:CreateMaps('<plug>NERDCommenterSexy',       '<leader>cs')
    call s:CreateMaps('<plug>NERDCommenterInvert',     '<leader>ci')
    call s:CreateMaps('<plug>NERDCommenterYank',       '<leader>cy')
    call s:CreateMaps('<plug>NERDCommenterAlignLeft',  '<leader>cl')
    call s:CreateMaps('<plug>NERDCommenterAlignBoth',  '<leader>cb')
    call s:CreateMaps('<plug>NERDCommenterNest',       '<leader>cn')
    call s:CreateMaps('<plug>NERDCommenterUncomment',  '<leader>cu')
    call s:CreateMaps('<plug>NERDCommenterToEOL',      '<leader>c$')
    call s:CreateMaps('<plug>NERDCommenterAppend',     '<leader>cA')
    if !hasmapto('<plug>NERDCommenterAltDelims', 'n')
        nmap <leader>ca <plug>NERDCommenterAltDelims
    endif
endif
if g:NERDMenuMode != 0
    let menuRoot = ""
    if g:NERDMenuMode == 1
        let menuRoot = 'comment'
    elseif g:NERDMenuMode == 2
        let menuRoot = '&comment'
    elseif g:NERDMenuMode == 3
        let menuRoot = '&Plugin.&comment'
    endif
    function! s:CreateMenuItems(target, desc, root)
        exec 'nmenu <silent> ' . a:root . '.' . a:desc . ' ' . a:target
        exec 'vmenu <silent> ' . a:root . '.' . a:desc . ' ' . a:target
    endfunction
    call s:CreateMenuItems("<plug>NERDCommenterComment",    'Comment', menuRoot)
    call s:CreateMenuItems("<plug>NERDCommenterToggle",     'Toggle', menuRoot)
    call s:CreateMenuItems('<plug>NERDCommenterMinimal',    'Minimal', menuRoot)
    call s:CreateMenuItems('<plug>NERDCommenterNest',       'Nested', menuRoot)
    exec 'nmenu <silent> '. menuRoot .'.To\ EOL <plug>NERDCommenterToEOL'
    call s:CreateMenuItems('<plug>NERDCommenterInvert',     'Invert', menuRoot)
    call s:CreateMenuItems('<plug>NERDCommenterSexy',       'Sexy', menuRoot)
    call s:CreateMenuItems('<plug>NERDCommenterYank',       'Yank\ then\ comment', menuRoot)
    exec 'nmenu <silent> '. menuRoot .'.Append <plug>NERDCommenterAppend'
    exec 'menu <silent> '. menuRoot .'.-Sep-    :'
    call s:CreateMenuItems('<plug>NERDCommenterAlignLeft',  'Left\ aligned', menuRoot)
    call s:CreateMenuItems('<plug>NERDCommenterAlignBoth',  'Left\ and\ right\ aligned', menuRoot)
    exec 'menu <silent> '. menuRoot .'.-Sep2-    :'
    call s:CreateMenuItems('<plug>NERDCommenterUncomment',  'Uncomment', menuRoot)
    exec 'nmenu <silent> '. menuRoot .'.Switch\ Delimiters <plug>NERDCommenterAltDelims'
    exec 'imenu <silent> '. menuRoot .'.Insert\ Comment\ Here <plug>NERDCommenterInInsert'
    exec 'menu <silent> '. menuRoot .'.-Sep3-    :'
    exec 'menu <silent>'. menuRoot .'.Help :help NERDCommenterContents<CR>'
endif
