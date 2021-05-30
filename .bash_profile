# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

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

# General-purpose helpers
alias h='history'
alias l='ls -alFGh'
alias cw='cd ~/GitHub/carnesen'
alias ..='cd ..; l'
alias ...='cd ../..; l'
alias ....='cd ../../..; l'
alias .....='cd ../../../..; l'
alias sp='. ~/.bash_profile' # "source profile"
alias ep='edit ~/.bash_profile' # "edit profile"
alias untar='tar xvfz'
alias more='less'
alias timestamp='date "+%F-%T"'

# Generate a random six-charater lowercase string
alias rand='cat /dev/random | LC_CTYPE=C tr -dc "[:lower:]" | head -c 6'

function edit() {
	echo "Running \"${EDITOR} $*\". This command will terminate when the editor closes the file..."
	${EDITOR} "$@"
}

function iterm() {
	DIR=${1:-.}
	echo "Opening $DIR in iTerm"
	open -a iTerm $DIR
}

# "to trash": Move the specified paths to a MacOS trash folder. This is safer
# and faster than "rm -rf"
function tt() {
	local random_string=$(rand)
	local trash_dir=~/.Trash/${random_string}/
	mkdir -p "${trash_dir}"
	mv "$@" "${trash_dir}"
}

# Git commands
function push() {
	local branch=$(git rev-parse --abbrev-ref HEAD)
	git push --set-upstream origin ${branch} "$@"
}
alias g='git'
alias gb='git switch -c'
alias gm='git switch master && git pull'
alias gs='git status'
alias gc='git add . && git status && git commit && push'
alias gfp='git push --force-with-lease' # "git force push"
function g7() {
	local ref=${1:-HEAD}
	git rev-parse --short=7 "${ref}"
}
alias recommit='git commit --all --amend --no-edit'
alias git-remove-untracked='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs git branch -D'

# Open a Python http server on the current or specified directory (e.g. "s ~/GitHub/www/dist")
alias s='open http://localhost:8000 & python3 -m http.server'

# JavaScript development
alias ud='rm -rf node_modules/ package-lock.json && npx npm-check-updates --dep dev,prod --upgrade && npm install && npm test'
alias rd='npm ci'
alias prettier='npx prettier --write --trailing-comma all --single-quote'

# brew cask install google-cloud-sdk
GOOGLE_CLOUD_SDK_PATH_BASH_INC='/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc'
[ -s "${GOOGLE_CLOUD_SDK_PATH_BASH_INC}" ] && . "${GOOGLE_CLOUD_SDK_PATH_BASH_INC}"
GOOGLE_CLOUD_SDK_COMPLETION_BASH_INC='/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc'
[ -s "${GOOGLE_CLOUD_SDK_PATH_BASH_INC}" ] && . "${GOOGLE_CLOUD_SDK_PATH_BASH_INC}"

# brew install bash-completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# brew install Schniz/tap/fnm
if command -v fnm > /dev/null 2>&1; then
	eval "$(fnm env --multi)"
fi
