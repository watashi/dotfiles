source $VIMRUNTIME/mswin.vim
source $VIMRUNTIME/vimrc_example.vim
behave mswin

set fileencodings=ucs-bom,utf-8,gb18030,shift-jis,big5,euc-jp,euc-kr
" set fileencoding=utf-8
set fileformats=unix
set fileformat=unix
set nobomb
set number autoindent tabstop=2 shiftwidth=2 expandtab smarttab
" set ruler ttyfast
colorscheme ron

autocmd FileType c,cpp set cindent cinoptions=:0g0t0(sus

if has("gui_running")
  "  set lines=40 columns=111
  set lines=32 columns=100
  colo desert
  "  set guifont=Bitstream\ Vera\ Sans\ Mono\ 10
  set guioptions-=T
  set nomousehide
endif

highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/

" au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery

map <F5> :call CompileAndRun()<CR>

function DictGet(dict, key, default)
  if has_key(a:dict, a:key)
    let value = a:dict[a:key]
  else
    let value = a:default
  endif
  return substitute(value, '\s%.\b\s', "'\\0'", 'g')
endfunction

function CompileAndRun()
  let compileDict = {
        \ 'c':            'gcc -O2 -Wall -Wextra -lm -D__WATASHI__ %',
        \ 'cpp':          'g++ -std=c++0x -O2 -Wall -Wextra -D__WATASHI__ %',
        \ 'cpp.doxygen':  'g++ -std=c++0x -O2 -Wall -Wextra -D__WATASHI__ %',
        \ 'cs':           'dmcs -r:System.Numerics -langversion:Future %',
        \ 'java':         'javac -Xlint %',
        \ 'pascal':       'fpc %',
        \ 'fortran':      'gfortran %',
        \ 'tex':          'xelatex %',
        \ }
  let compile = DictGet(compileDict, &filetype, 'true')

  let runDict = {
        \ 'c':            './a.out',
        \ 'cpp':          './a.out',
        \ 'cpp.doxygen':  './a.out',
        \ 'cs':           'mono %<.exe',
        \ 'java':         'java -D__WATASHI__ %<',
        \ 'pascal':       './%<',
        \ 'fortran':      './a.out',
        \ 'tex':          'evince %<.pdf',
        \
        \ 'haskell':      'ulimit -t 60 && ghci -Wall %',
        \ 'lhaskell':     'ghci -Wall %',
        \ 'sh':           'bash %',
        \ 'lisp':         'clisp -i %',
        \ 'python':       'python2 %',
        \ 'tcl':          'perl %',
        \ 'javascript':   'node %',
        \ 'scheme':       'guile %',
        \
        \ 'perl':         'perl %',
        \ 'php':          'php %',
        \ 'ruby':         'ruby %',
        \ 'scala':        'scala %',
        \ 'ocaml':        'ocaml %',
        \ }
  let run = DictGet(runDict, &filetype, 'false')

  let compileAndRun =
        \ compile . ' && echo __compiled__ && ' .
        \ run . ' ; echo __done__ \[\$?\] && wait && read -n 1'

  execute 'w'
  execute '!xterm -fn "10*20" -geometry 80x32 -e "' . compileAndRun . '"'
endfunction

