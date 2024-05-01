#!/bin/bash

set -eo pipefail

# Manual configuration:
# - Decrease display size https://www.cnet.com/how-to/7-macos-display-settings-to-help-you-see-your-mac-better/
# - Fix trackpad and keyboard settings
# - Install 1Password manually for security sake

# This script sets up a new Mac

SHELL_DESIRED="/bin/bash"
if [ "${SHELL}" == "${SHELL_DESIRED}" ]; then
	echo "Shell is already ${SHELL_DESIRED}"
else
	echo "About to change default shell for $(whoami). You'll be prompted for your password."
	chsh -s "${SHELL_DESIRED}"
	echo "Changed default shell. About to restart for it to take effect. You'll be prompted for your password."
	sudo shutdown -r now
fi

BASH_PROFILE_PATH="$HOME/.bash_profile"
if [ -f "${BASH_PROFILE_PATH}" ]; then
	echo "~/.bash_profile already exists"
else
	echo "Writing ~/.bash_profile"
	echo "" >> "${BASH_PROFILE_PATH}"
fi

if command -v brew > /dev/null 2>&1; then
	echo "Homebrew: already installed"
else
	echo "Installing Homebrew"
	echo "Note this also installs XCode command-line tools"
	echo "You'll be prompted to enter your admin password"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

if command -v wget > /dev/null 2>&1; then
	echo "wget: already installed"
else
	echo "wget: installing"
	brew install wget
fi

if [ -d "/Applications/Google Chrome.app" ]; then
	echo "Google Chrome: already installed"
else
	echo "Installing Google Chrome"
	brew install --cask google-chrome
fi

if [ -f ~/.ssh/id_rsa ]; then
	echo "Found SSH key"
else
	echo "Setting up SSH key"
	ssh-keygen -t rsa -b 4028 -f ~/.ssh/id_rsa
	echo "Add the following SSH public key to GitHub and rerun this script"
	echo ""
	cat ~/.ssh/id_rsa.pub
	exit 0
fi

if [ -d "/usr/local/etc/bash_completion.d" ]; then
	echo "Homebrew bash completion: already installed"
else
	echo "Installing bash completion"
	brew install bash-completion
fi

if [ -d "/Applications/Moom.app" ]; then
	echo "Moom: already installed"
else
	echo "Moom: installing"
	brew install --cask moom
fi

if [ -d "/Applications/Docker.app" ]; then
	echo "Docker Desktop: already installed"
else
	echo "Docker Desktop: skip installing"
	# brew install --cask docker
	# Launch Docker Desktop to complete the installation
	# open "/Applications/Docker.app"
fi

if [ -d "/Applications/Slack.app" ]; then
	echo "Slack: already installed"
else
	echo "Slack: skip installing"
	# brew install --cask slack
fi

if command -v fnm > /dev/null 2>&1; then
	echo "Fast Node Manager (fnm): already installed"
else
	echo "Fast Node Manager (fnm): installing"
	brew install fnm
	echo 'eval $(fnm env)' >> ~/.bash_profile
	source ~/.bash_profile
fi

if command -v node > /dev/null 2>&1; then
	echo "Node.js: already installed"
else
	echo "Node.js: installing"
	fnm install 20
	fnm default 20
	source ~/.bash_profile
fi

GITHUB_CARNESEN_DIR="${HOME}/GitHub/carnesen"
GITHUB_CARNESEN_DEV_DIR="${HOME}/GitHub/carnesen/dev"

if [ -d "${GITHUB_CARNESEN_DEV_DIR}" ]; then
	echo "@carnesen/dev: already exists"
else
	echo "@carnesen/dev: installing"
	mkdir -p "${GITHUB_CARNESEN_DIR}"
	git -C "${GITHUB_CARNESEN_DIR}" clone git@github.com:carnesen/dev.git
	npm --prefix "${GITHUB_CARNESEN_DEV_DIR}" ci
	npm --prefix "${GITHUB_CARNESEN_DEV_DIR}" run dev -- clone-carnesens
fi

DOTFILES_DIR="${GITHUB_CARNESEN_DIR}/dotfiles"
if [ -d "${DOTFILES_DIR}" ]; then
	echo "Dotfiles directory already exists"
else
	echo "FATAL ERROR: Expected ${GITHUB_CARNESEN_DIR} directory to have been cloned by @carnesen/dev"
	exit 1
fi

if grep "dotfiles" ~/.bash_profile; then
	echo "dotfiles: already being sourced"
else
	echo "dotfiles: sourcing from bash_profile"
	echo "source ${DOTFILES_DIR}/.bash_profile" >> ~/.bash_profile
	source ~/.bash_profile
fi

if command -v code > /dev/null 2>&1; then
	echo "Visual Studio Code: already installed"
else
	echo "Visual Studio Code: installing"
	brew install --cask visual-studio-code
	# Launch Visual Studio Code so that it creates its directories
	code "${DOTFILES_DIR}"
	echo "Sleeping to make sure the program is up and running"
	sleep 5
fi

VS_CODE_SETTINGS_FILE_PATH="${HOME}/Library/Application Support/Code/User/settings.json"
if [ -L "${VS_CODE_SETTINGS_FILE_PATH}" ]; then
	echo "Visual Studio Code: settings file already symlinked"
else
	echo "Visual Studio Code: symlinking settings file"
	rm -f "${VS_CODE_SETTINGS_FILE_PATH}"
	ln -s "${GITHUB_CARNESEN_DIR}/dotfiles/settings.json" "${VS_CODE_SETTINGS_FILE_PATH}" 
fi

VS_CODE_EXTENSIONS_DESIRED=(
	"dbaeumer.vscode-eslint"
	"sdras.night-owl"
	"stkb.rewrap"
	"streetsidesoftware.code-spell-checker"
)

VS_CODE_EXTENSIONS_INSTALLED="$(code --list-extensions)"
for VS_CODE_EXTENSION in ${VS_CODE_EXTENSIONS_DESIRED[@]}; do
	if [[ "${VS_CODE_EXTENSIONS_INSTALLED}" == *"${VS_CODE_EXTENSION}"* ]]; then
		echo "Visual Studio Code extension ${VS_CODE_EXTENSION}: already installed"
	else
		echo "Visual Studio Code extension ${VS_CODE_EXTENSION}: already installed"
		code --install-extension "${VS_CODE_EXTENSION}"
	fi
done

if command -v gcloud > /dev/null 2>&1; then
	echo "Google Cloud SDK: already installed"
else
	echo "Google Cloud SDK: installing"
	brew install --cask google-cloud-sdk
fi

# The MacOS Git version is old. Install the latest with Homebrew.
if [ "$(command -v git)" = "/usr/local/bin/git" ]; then
	echo "Git: already installed"
else
	echo "Git: installing"
	brew install git
fi

# "git config" fails if the property is not set
GIT_USER_NAME="$(git config --global --get user.name || true)"
if [ -n "${GIT_USER_NAME}" ]; then
	echo "Git: user.name is ${GIT_USER_NAME}"
else
	echo "Git: setting user.name"
	git config --global user.name "Chris Arnesen"
fi

GIT_USER_EMAIL="$(git config --global --get user.email || true)"
if [ -n "${GIT_USER_EMAIL}" ]; then
	echo "Git: user.email is ${GIT_USER_EMAIL}"
else
	echo "Git: setting user.email"
	git config --global user.email "chris.arnesen@gmail.com"
fi

if command -v gh > /dev/null 2>&1; then
	echo "GitHub CLI (gh): already installed"
else
	echo "GitHub CLI (gh): installing"
	brew install gh
	gh auth login
fi

if command -v github > /dev/null 2>&1; then
	echo "GitHub Desktop: already installed"
else
	echo "GitHub Desktop: installing"
	brew install --cask github
fi

if command -v gpg > /dev/null 2>&1; then
	echo "GnuPG: already installed"
else
	echo "GnuPG: installing"
	brew install gnupg
fi

echo "Setting git pull to rebase instead of merge by default"
git config --global pull.rebase true
