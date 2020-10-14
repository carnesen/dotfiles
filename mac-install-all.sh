#!/bin/bash

# This script sets up a new Mac

if command -v brew > /dev/null 2>&1; then
	echo "Homebrew is already installed"
else
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

if [ -d "/usr/local/etc/bash_completion.d" ]; then
	echo "Homebrew bash completion is already installed"
else
	brew install bash-completion
fi

if [ -d "/Applications/Firefox.app" ]; then
	echo "Firefox is already installed"
else
	echo "Installing Firefox"
	brew cask install firefox
fi

if [ -d "/Applications/Google Chrome.app" ]; then
	echo "Google Chrome is already installed"
else
	echo "Installing Google Chrome"
	brew cask install google-chrome
fi

if [ -d "/Applications/iTerm.app" ]; then
	echo "iTerm2 is already installed"
else
	echo "Installing iTerm2"
	brew cask install iterm2
fi

SHELL_DESIRED="/bin/bash"
if [ "${SHELL}" == "${SHELL_DESIRED}" ]; then
	echo "Shell is already ${SHELL_DESIRED}"
else
	echo "About to change default shell for $(whoami). You'll be prompted for your password."
	chsh -s "${SHELL_DESIRED}"
fi

GITHUB_DIR="${HOME}/GitHub"
DOTFILES_DIR="${GITHUB_DIR}/dotfiles"

if [ -d "${DOTFILES_DIR}" ]; then
	echo "Dotfiles directory already exists"
else
	echo "Cloning dotfiles to ${GITHUB_DIR}"
	mkdir -p "${GITHUB_DIR}"
	git -C "${GITHUB_DIR}" clone git@github.com:carnesen/dotfiles.git
fi

if [ -d "/Applications/Moom.app" ]; then
	echo "Moom is already installed"
else
	brew cask install moom
fi

if command -v code > /dev/null 2>&1; then
	echo "Visual Studio Code is already installed"
else
	echo "Installing Visual Studio Code"
	brew cask install visual-studio-code
fi

VS_CODE_SETTINGS_FILE_PATH="${HOME}/Library/Application Support/Code/User/settings.json"
if [ -L "${VS_CODE_SETTINGS_FILE_PATH}" ]; then
	echo "Visual Studio Code settings file already symlinked"
else
	rm -f "${VS_CODE_SETTINGS_FILE_PATH}"
	ln -s "${GITHUB_DIR}/dotfiles/settings.json" "${VS_CODE_SETTINGS_FILE_PATH}" 
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
		echo "Visual Studio Code extension ${VS_CODE_EXTENSION} already installed"
	else
		code --install-extension "${VS_CODE_EXTENSION}"
	fi
done

if command -v fnm > /dev/null 2>&1; then
	echo "Fast Node Manager (fnm) is already installed"
else
	brew install Schniz/tap/fnm
fi

if command -v gcloud > /dev/null 2>&1; then
	echo "Google Cloud SDK is already installed"
else
	brew cask install google-cloud-sdk
fi

