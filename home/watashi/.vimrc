source $VIMRUNTIME/mswin.vim
source $VIMRUNTIME/vimrc_example.vim
behave mswin

set fileencodings=utf-8,gb18030,shift-jis,big5,euc-jp,euc-kr
set fileformats=unix
set fileformat=unix
set number autoindent tabstop=4 shiftwidth=4 expandtab smarttab
" set ruler ttyfast
colorscheme ron

autocmd FileType c,cpp set cindent cinoptions=:0g0t0(sus

if has("gui_running")
"	set lines=40 columns=111
	set lines=32 columns=100
	colo desert
"	set guifont=Bitstream\ Vera\ Sans\ Mono\ 10
endif

highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/

" au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery

map <F5> :call DoIt()<CR>

function DoIt()
	if &filetype == "c"
		let CompileIt="gcc \\\"%\\\" -Wall -O2 -lm -D__WATASHI__"
		let RunIt="./a.out"
	elseif &filetype == "cpp" || &filetype == "cpp.doxygen"
		let CompileIt="g++ \\\"%\\\" -std=c++0x -Wall -O2 -D__WATASHI__"
		let RunIt="./a.out"
	elseif &filetype == "cs"
		let CompileIt="gmcs \\\"%\\\""
		let RunIt="mono \\\"%<.exe\\\""
	elseif &filetype == "java"
		let CompileIt="javac -Xlint \\\"%\\\""
		let RunIt="java \\\"%<\\\" -watashi"
	elseif &filetype == "pascal"
		let CompileIt="fpc \\\"%\\\""
		let RunIt="\\\"./%<\\\""
	elseif &filetype == "fortran"
		let CompileIt="gfortran \\\"%\\\""
		let RunIt="\\\"./a.out\\\""
	elseif &filetype == "tex"
		let CompileIt="xelatex \\\"%\\\""
		let RunIt="evince \\\"%<.pdf\\\""
	elseif &filetype == "haskell" || &filetype == "lhaskell"
		let CompileIt="true"
		let RunIt="ghci \\\"%\\\""
	elseif &filetype == "sh"
		let CompileIt="true"
		let RunIt="bash \\\"%\\\""
	elseif &filetype == "ruby"
		let CompileIt="true"
		let RunIt="ruby \\\"%\\\""
    elseif &filetype == "lisp"
        let CompileIt="true"
        let RunIt="clisp -i \\\"%\\\""
    elseif &filetype == "tcl"
        let CompileIt="true"
        let RunIt="tclsh \\\"%\\\""
	elseif &filetype == "php" || &filetype == "perl" || &filetype == "python" || &filetype == "scala"
		let CompileIt="true"
		let RunIt=&filetype . " \\\"%\\\""
	else
		let CompileIt="true"
		let RunIt="true"
	endif
	execute "w"
	execute "!xterm -fn 10*20 -geometry 80x32 -e \"" . CompileIt . " && echo \"__compiled__\" && " . RunIt . " ; read -n 1\""
endfunction

map <F6> :call DoIt()2<CR>

function DoIt2()
	execute "w"
	execute "!xterm -fn 10*20 -geometry 80x32 -e \"g++ \\\"%\\\" -Wall -O2 -D__WATASHI__  && echo \"__compiled__\" && ./a.out ; read -n 1\""
endfunction


