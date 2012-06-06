alias ls='ls --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
# alias dosbox='\dosbox -conf ~/.dosbox/dosbox.conf'
alias lns='\ln -isvb'
alias mv='\mv -i'
alias cp='\cp -i'

alias du1='du --max-depth 1'

# alias del='\mv -t ~/.trash'
# alias rm='\mv -t ~/.trash'
alias rm='\trash-put'
alias rmbak='\rm *~'
# alias fsc='\mono /opt/FSharp-2.0.0.0/bin/fsc.exe'
# alias fsi='\mono /opt/FSharp-2.0.0.0/bin/fsi.exe'
alias firefox_='\firefox -P temp -no-remote'
alias play='mplayer -loop 0 -shuffle -playlist'
alias clisp='clisp -q'

alias scala='scala -deprecation'
alias scalac='scalac -deprecation'
alias fsc='fsc -deprecation'

alias lunar='luit -encoding GBK \lunar -h'
alias lunar0='\lunar -h `date "+%Y %m %d %H"` | iconv -f GBK -t UTF-8'

alias pry='ruby -r pry -e pry'
