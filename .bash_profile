# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

shopt -s histappend
export CLICOLOR=1
export HISTIGNORE='&:ls:cd ~:cd ..:[bf]g:exit:h:history'
export HISTCONTROL=erasedups
export PROMPT_COMMAND='history -a'

alias la='ls -al'
alias l='la'
alias lt='ls -ltr'
alias ld='ls -ld'
alias ..='cd ..; l'
alias ...='cd ../..; l'
alias ....='cd ../../..; l'
alias .....='cd ../../../..; l'
alias dp='. ~/.bash_profile'
alias vip='vi ~/.bash_profile'
alias untar='tar xvfz'
alias more='less'
alias g=git
alias gs='git status'
alias ga='git add'
alias gc='git commit -a -m'
alias gh='git checkout'
alias gp='git push'
alias gl='git log --oneline'
alias s='open http://localhost:8000 & python -m SimpleHTTPServer'
alias chrome='open -a Google\ Chrome --args --disable-web-security --user-data-dir'
alias vsc='open -a /Applications/Visual\ Studio\ Code.app/'
export PATH="~/bin:./node_modules/.bin:$PATH"

tt() {
  mv "$@" ~/.Trash
}

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="\[\033[32m\]\W\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
