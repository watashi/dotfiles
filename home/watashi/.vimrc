source $VIMRUNTIME/mswin.vim
source $VIMRUNTIME/vimrc_example.vim
behave mswin

set fileencodings=ucs-bom,utf-8,gb18030,shift-jis,big5,euc-jp,euc-kr
" set fileencoding=utf-8
set fileformats=unix
set fileformat=unix
set nobomb
set number
" set foldmethod=syntax foldcolumn=1
set autoindent tabstop=2 shiftwidth=2 expandtab smarttab
" set ruler ttyfast
colorscheme ron

autocmd FileType c,cpp set cindent cinoptions=:0g0t0(sus
let g:load_doxygen_syntax=1

if has("gui_running")
  "  set lines=40 columns=111
  set lines=32 columns=100
  colo desert
  "  set guifont=Bitstream\ Vera\ Sans\ Mono\ 10
  set guioptions-=T
  set nomousehide
endif

highlight Tab ctermbg=lightblue guibg=lightblue
call matchadd("Tab", "\t")

highlight WhitespaceEOL ctermbg=red guibg=red
call matchadd("WhitespaceEOL", "\\s\\+$")

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
  let cc = ' -O3 -Wall -Wextra -Wconversion -Wshadow -D__WATASHI__ %'

  let compileDict = {
        \ 'c':            'gcc -std=c1x -lm' . cc,
        \ 'cpp':          'g++ -std=c++0x' . cc,
        \ 'cpp.doxygen':  'g++ -std=c++0x' . cc,
        \ 'cs':           'dmcs -define:__WATASHI__ -r:System.Numerics -langversion:Future %',
        \ 'd':            'dmd %',
        \ 'java':         'javac -Xlint %',
        \ 'pascal':       'fpc -d__WATASHI__ -So -XS %',
        \ 'fortran':      'gfortran %',
        \ 'tex':          'xelatex %',
        \ }
  let compile = DictGet(compileDict, &filetype, 'true')

  let runDict = {
        \ 'c':            './a.out',
        \ 'cpp':          './a.out',
        \ 'cpp.doxygen':  './a.out',
        \ 'cs':           'mono %<.exe',
        \ 'd':            './%<',
        \ 'java':         'java -D__WATASHI__ %<',
        \ 'pascal':       './%<',
        \ 'fortran':      './a.out',
        \ 'tex':          'evince %<.pdf',
        \
        \ 'go':           'go run %',
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

