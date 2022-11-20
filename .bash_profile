######################################
### Chris Arnesen's .bash_profile. ###
######################################

####################
### Dependencies ###
####################

# Global definitions #
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# brew cask install google-cloud-sdk
GOOGLE_CLOUD_SDK_PATH_BASH_INC='/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc'
[ -s "${GOOGLE_CLOUD_SDK_PATH_BASH_INC}" ] && . "${GOOGLE_CLOUD_SDK_PATH_BASH_INC}"
GOOGLE_CLOUD_SDK_COMPLETION_BASH_INC='/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc'
[ -s "${GOOGLE_CLOUD_SDK_PATH_BASH_INC}" ] && . "${GOOGLE_CLOUD_SDK_PATH_BASH_INC}"

# brew install bash-completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# brew install Schniz/tap/fnm
if command -v fnm > /dev/null 2>&1; then
	eval "$(fnm env)"
fi

#############################
### Environment variables ###
#############################

# https://apple.stackexchange.com/questions/371997/suppressing-zsh-verbose-message-in-macos-catalina
export BASH_SILENCE_DEPRECATION_WARNING=1

# Add ~/bin and the current directory's Node.js module executables to PATH
export PATH="~/bin:./node_modules/.bin:$PATH"

# Colorized terminal
export CLICOLOR=1

# Customize bash history
shopt -s histappend
shopt -s cmdhist
export HISTCONTROL=erasedups
export HISTIGNORE='l:ls:cd:..:...:....:exit:h:history'
export HISTSIZE=50000
export HISTTIMEFORMAT="%h %d %H:%M:%S "
export PROMPT_COMMAND='history -a'

# Use Visual Studio Code as default shell editor
export EDITOR='code --wait'

# Set up colored prompt of the form "dotfiles (master) $ " where master is the current Git branch name
function parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\[\033[32m\]\W\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

###############################
### General-purpose helpers ###
###############################

alias ..='cd ..; l'
alias ...='cd ../..; l'
alias ....='cd ../../..; l'
alias .....='cd ../../../..; l'

alias cw='cd ~/GitHub/carnesen'

function edit() {
	echo "Running \"${EDITOR} $*\". This command will terminate when the editor closes the file..."
	${EDITOR} "$@"
}

alias l='ls -alFGh'

alias h='history'

# Source/edit bash profile
alias sp='. ~/.bash_profile'
alias ep='edit ~/.bash_profile'

function iterm() {
	DIR=${1:-.}
	echo "Opening $DIR in iTerm"
	open -a iTerm $DIR
}

alias more='less'

# Generate a random six-charater lowercase string
alias rand='cat /dev/random | LC_CTYPE=C tr -dc "[:lower:]" | head -c 6'

# Serve the current or specified directory
alias serve='open http://localhost:8000 & python3 -m http.server'

# "to trash": Move the specified paths to a MacOS trash folder. This is safer
# and faster than "rm -rf"
function tt() {
	local random_string=$(rand)
	local trash_dir=~/.Trash/${random_string}/
	mkdir -p "${trash_dir}"
	mv "$@" "${trash_dir}"
}

alias timestamp='date "+%F-%T"'

alias untar='tar xvfz'

####################
### Git commands ###
####################

alias g='git'

# "git create branch"
alias gcb='git switch -c'

alias gs='git status'

# "git list branches"
alias glb='git branch -v'

# "git force push"
function gfp() {
	local branch=$(git rev-parse --abbrev-ref HEAD)
	git push --force-with-lease --set-upstream origin ${branch}
}

# "git force commit"
function gfc() {
	git add .
	gs
	git commit "$@"
	gfp
}

# "git force amend"
alias gfa='gfc --amend --date=now'

# "git force re-commit"
alias gfr='gfa --no-edit'

# "git remove untracked"
alias gru='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs git branch -D'

# Switch to specific branch
alias gsd='git switch develop && git pull'
alias gsm='git switch master && git pull'
alias gsn='git switch main && git pull'
alias gsdmd='git switch develop-multi-dealer && git pull'
function g7() {
	local ref=${1:-HEAD}
	git rev-parse --short=7 "${ref}"
}

##

##############################
### JavaScript development ###
##############################

alias ud='rm -rf node_modules/ package-lock.json && npx npm-check-updates --dep dev,prod --upgrade && npm install && npm test'

alias rd='npm ci'

alias prettier='npx prettier --write --trailing-comma all --single-quote'

# Terraform
alias tf='terraform'
