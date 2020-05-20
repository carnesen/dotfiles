# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

shopt -s histappend
shopt -s cmdhist
export CLICOLOR=1
export HISTCONTROL=erasedups
export HISTIGNORE='l:ls:cd:..:...:....:exit:h:history'
export HISTSIZE=10000
export HISTTIMEFORMAT="%h %d %H:%M:%S "
export PROMPT_COMMAND='history -a'
export EDITOR='code --wait'
export PATH="~/bin:./node_modules/.bin:$PATH"
export PS1="\[\033[32m\]\W\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

alias h='history'
alias pa='. $(pipenv --venv)/bin/activate'
alias g7='git rev-parse --short=7 HEAD'
alias recommit='git commit --all --amend --no-edit'
alias la='ls -al'
alias l='la'
alias lt='ls -ltr'
alias ld='ls -ld'
alias ..='cd ..; l'
alias ...='cd ../..; l'
alias ....='cd ../../..; l'
alias .....='cd ../../../..; l'
alias dp='. ~/.bash_profile'
alias ep='edit ~/.bash_profile'
alias untar='tar xvfz'
alias more='less'
alias g='git'
alias gs='git status'
alias s='open http://localhost:8000 & python -m SimpleHTTPServer'
alias ud='rm -rf node_modules/ package-lock.json && npx npm-check-updates --dep dev,prod --upgrade && npm install && npm test'
alias rd='rm -rf node_modules/ && npm install'
alias prettier='npx prettier --write --trailing-comma all --single-quote'

function edit() {
  echo "Running \"${EDITOR} $*\". This command will terminate when the editor closes the file..."
  ${EDITOR} "$@"
}

function iterm() {
  DIR=${1:-.}
  echo "Opening $DIR in iTerm"
  open -a iTerm $DIR
}

function tt() {
  mv "$@" ~/.Trash
}

function parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
