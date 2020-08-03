#!/usr/bin/env bash -x

# Settings
PROJECT_DIRECTORY="${HOME}/Projects"

echo "Hello $(whoami)! Let's get you set up."

# Setup Projects Directory
if [[ ! -e $PROJECT_DIRECTORY ]]; then
  mkdir -p $PROJECT_DIRECTORY
else 
  echo "${PROJECT_DIRECTORY} already exists! \n"
fi

# Install Xcode tools
if [ ! -d "$(xcode-select -p)" ]; then
  sudo xcode-select --install
else 
  echo "Xcode Tools are already installed! \n"
fi

# Install Homebrew and Brewfile
if ! type "brew" > /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
  echo "Homebrew is already installed! \n"
fi

brew bundle

# Install Oh My ZSH
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install ZSH Syntax Highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# ln -s "${PROJECT_DIRECTORY}/machine-setup/dotfiles/.zshrc" "${HOME}/.zshrc"
