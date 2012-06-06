# History, Cache {{{
local ZSH_CACHE=~/.cache/zsh
HISTFILE=$ZSH_CACHE/histfile
HISTSIZE=5000
SAVEHIST=5000
mkdir -p $ZSH_CACHE
# }}}

# Zstyles, Autoload, Completion {{{
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $ZSH_CACHE/comp_cache
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*' menu select=8
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*:processes' command 'ps xo pid,user:10,cmd | grep -v "zsh$" | grep -v "\ssshd:"'
zstyle ':vcs_info:*' formats '%F{cyan}%s %B%b%f '
zstyle ':vcs_info:*' enable git svn
zstyle ':chpwd:*' recent-dirs-file $ZSH_CACHE/chpwd_recent

autoload -Uz compinit vcs_info zmv zcp zln add-zsh-hook zed zfinit select-word-style

# zftp
zfinit

# backward kill word now stops at /
select-word-style bash

# custom completion scripts
local CUSTOM_COMP_PATH=~/.profile.d/zcompletion
[[ -d $CUSTOM_COMP_PATH ]] && fpath=($CUSTOM_COMP_PATH $fpath)
compinit
# }}}

# Setopt, Bindkey {{{
setopt append_history inc_append_history autocd cshnullglob extendedglob short_loops hist_ignore_space hist_ignore_dups prompt_subst
bindkey -v
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^K' kill-line
bindkey '^L' clear-screen
bindkey '^R' history-incremental-search-backward
bindkey '^W' backward-kill-word
bindkey '^[.' insert-last-word
# auto replace ... to ../.. (from zsh-lovers)
rationalise-dot() {
    if [[ $LBUFFER = *.. ]] && [[ "$LBUFFER" = "$BUFFER" ]]; then
LBUFFER+=/..
    else
LBUFFER+=.
    fi
}
zle -N rationalise-dot
bindkey . rationalise-dot
# }}}

# Prompt {{{
# vcs_info_wrapper
_vcs_info() {
  vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && echo -n "${vcs_info_msg_0_}"
}

if [[ -n "$SSH_TTY" ]]; then
export PS1="%F{cyan}%U%n@%m%u%f %B%F{red}%(?..[%?] )%f%F{cyan}%#%f%b "
else
export PS1="%F{g}%U%n%u%f %B%F{red}%(?..[%?] )%f%F{g}%#%f%b "
fi

export RPS1='$(_vcs_info)'"%B%F{yellow}%~%f%b"
# }}}

# No Beep {{{
setterm -blength 0
# }}}

# Title, Paths {{{
# change title
title() {
    [ $TERM != 'linux' ] && print -Pn "\e]2;$@\a"
}

chpwd() {
    # push current path to $path_history (use zsh cdr instead)
    [[ -z $cb_flag ]] && path_history+=($PWD)
}

preexec() {
    # modify title to command name
    # if in ssh, add hostname
    # if $TITLE is non-empty, use it
    emulate -L zsh
    local -a cmd
    cmd=(${(z)1})
    [[ -n "$TITLE" ]] && cmd[1]="$TITLE"
    if [[ -z "$SSH_CLIENT" ]]; then
title $cmd[1]:t "$cmd[2,-1]"
    else
title "%m: " $cmd[1]:t "$cmd[2,-1]"
    fi
}

precmd() {
    # modify title to partial path
    # if in ssh, add hostname
    if [[ -z "$SSH_CLIENT" ]]; then
title "%2c"
    else
title "%m: %2c"
    fi
}

cb() {
    # pop current pwd
    path_history[-1]=()
    # set flag
    cb_flag=1
    # top, -1 means the last element
    cd $path_history[-1]
    # unset flag
    unset cb_flag
}

precmd
# }}}

# Basic alias {{{
# short names
# alias la='ls -A'
# alias ll='ls -lh'
# alias l='ls -CF'
# alias md='mkdir -p'
# alias rd='rmdir'
# alias bd='bg && disown'
# default parameters
# alias ls='ls --color=auto'
# alias rm='rm -v'
# alias mv='mv -vi'
# alias cp='cp -aviu'
# alias scp='noglob scp -r'
# suffix
# alias -g L='| less'
# alias -g N='&> /dev/null'
# alias -g S='&> /dev/null &!'
# alias -g CE='2> >(while read line; do print "\e[91m"${(q)line}"\e[0m"; done)'
# alias -g EL='|& less'
# alias -g H='| head'
# alias -g EH='|& head'
# alias -g T='| tail'
# alias -g ET='|& tail'
# alias -g M='| most'
# alias -g EM='|& most'
# }}}
source ~/.bash_aliases

# Load other stuff {{{
for i in /etc/profile.d/*.{sh,zsh} ~/.profile.d/*.{sh,zsh}; do
if [[ -e ${i}.zwc ]]; then # use ${i:r} to remove ext
        source ${i}.zwc
    else
source $i
    fi
done
# }}}

# Deprecated {{{
# cdr (now use autojump)
if ! which autojump &>/dev/null; then
autoload -Uz chpwd_recent_dirs cdr
    add-zsh-hook chpwd chpwd_recent_dirs
fi

# }}}

# zsh-syntax-highlighting {{{
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# }}}



#Rebind HOME and END to do the decent thing:
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
case $TERM in (xterm*)
bindkey '\eOH' beginning-of-line
bindkey '\eOF' end-of-line
esac

#To discover what keycode is being sent, hit ^v
#and then the key you want to test.

#And DEL too, as well as PGDN and insert:
bindkey '^[[3~' delete-char
bindkey '^[[6~' end-of-history
#bindkey '\e[2~' redisplay

#Now bind pgup to paste the last word of the last command,
bindkey '\e[5~' insert-last-word





export JAVA_HOME=/opt/java
# export TOMCAT_JAVA_HOME=$JAVA_HOME
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

export HISTSIZE=1024
export MANPATH=$MANPATH:/usr/local/ch6.3.0/docs/man
export LESS=-R
export RI=-fansi
export PAGER=/usr/bin/less
export EDITOR=/usr/bin/vim

# Cope
export PATH=/usr/share/perl5/site_perl/auto/share/dist/Cope:$PATH
# Io
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib


