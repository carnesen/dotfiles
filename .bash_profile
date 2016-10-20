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
alias lt='ls -ltr'
alias ld='ls -ld'
alias l='la'
alias ..='cd ..; l'
alias ...='cd ../..; l'
alias ....='cd ../../..; l'
alias .....='cd ../../../..; l'
alias dp='. ~/.bash_profile'
alias vip='vi ~/.bash_profile'
alias untar='tar xvfz'
alias more='less'
alias ap='ansible-playbook'
alias an=ansible
alias gs='git status'
alias ga='git add'
alias gc='git commit -a -m'
alias gh='git checkout'
alias ghm='git checkout master'
alias gp='git push'
alias gpu='git push -u origin'
alias gl='git log --oneline'
alias gb='git blame --date=short'
alias gr='git fetch; git stash; git rebase; git stash pop'
alias md='mongod --config /usr/local/etc/mongod.conf'
alias mdl='tail -f /usr/local/var/log/mongodb/mongo.log'
alias pg='postgres'

export PGDATA=/usr/local/var/postgres

export PATH="./node_modules/.bin:$PATH"
