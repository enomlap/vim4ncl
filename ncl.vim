" Vim indent file
" Language:	    NCL Script
" Maintainer:	Zuohj <@.org>
" URL:		    ---
" Latest Revision:  2017-05-02
" arch-tag:	    ---

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif

let b:did_indent = 1
let b:follow=0

setlocal indentexpr=GetNCLIndent()
setlocal indentkeys+==then,=do,=else,=elif,=esac,=fi,=fin,=fil,=done
setlocal indentkeys-=:,0#

" Only define the function once.
if exists("*GetNCLIndent")
  finish
endif

set cpoptions-=C

function GetNCLIndent()
  " Find a non-blank line above the current line.
  let lnum = prevnonblank(v:lnum - 1)

  " Hit the start of the file, use zero indent.
  if lnum == 0
    return 0
  endif

  " Add a 'shiftwidth' after if, while, else, case, until, for, function()
  " Skip if the line also contains the closure for the above
  let ind = indent(lnum)
  let line = getline(lnum)
	if (line =~ '^\s*\(begin\|if\|then\|do\|else\)\>')
		\ || (line =~'\<semi-\(if\|do\)\s*$')
		let ind = ind + &sw
	endif

	" Subtract a 'shiftwidth' on a then, do, else, done
	" Retain the indentation level if line matches fin (for find)
	let line = getline(v:lnum)
	let lastline=getline(prevnonblank(v:lnum -1))
	if (line =~ '^\s*\(end\|else\|\(end\s*\(do\|if\)\)\)\>')
		\ && (lastline !~ '^\s*\(end\s*if\)\>')
	"if (line =~ '^\s*\(end\|else\|\(end\s*\(do\|if\)\)\)\>')
		"	\ && line !~ '^\s*fi[ln]\>'
		let ind = ind - &sw
		"if (line =~ '^\s*\(end\s*if\)\>' && b:inCombineIFELSE > 0)
		if (line =~ '^\s*\(else\s*if\)\>')
			let b:follow=1
		else
			let b:follow=0
		endif
	endif

	return ind
endfunction

" vim: set sts=2 sw=2:
