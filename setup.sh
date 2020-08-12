#!/usr/bin/env bash

# Settings
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DOTFILES_DIRECTORY="${SCRIPT_DIR}/dotfiles"
SSH_KEY_DIRECTORY="${DOTFILES_DIRECTORY}/.ssh/source-control"
PROJECT_DIRECTORY="${HOME}/Projects"
OH_MY_ZSH_DIRECTORY="${HOME}/.oh-my-zsh"

echo "Hello $(whoami)! Let's get you set up."

# Generate SSH Key
if [[ ! -e $SSH_KEY_DIRECTORY ]]; then
  mkdir -p $SSH_KEY_DIRECTORY
  ssh-keygen -t rsa -b 4096 -C "me+github@ethanpursley.com" -f $SSH_KEY_DIRECTORY/github
else 
  echo "${SSH_KEY_DIRECTORY} already exists!"
fi

# Setup Projects Directory
if [[ ! -e $PROJECT_DIRECTORY ]]; then
  mkdir -p $PROJECT_DIRECTORY
else 
  echo "${PROJECT_DIRECTORY} already exists!"
fi

# Install Xcode tools
if [ ! -d "$(xcode-select -p)" ]; then
  xcode-select --install
else 
  echo "Xcode Tools are already installed!"
fi

# Install Homebrew and Brewfile
if ! type "brew" > /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
  echo "Homebrew is already installed!"
fi

brew analytics off
brew bundle

# Install Oh My ZSH
if [[ ! -e $OH_MY_ZSH_DIRECTORY ]]; then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else 
  echo "${OH_MY_ZSH_DIRECTORY} already exists!"
fi

# Install ZSH Syntax Highlighting
if [[ ! -e $OH_MY_ZSH_DIRECTORY/custom/plugins/zsh-syntax-highlighting ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else 
  echo "${OH_MY_ZSH_DIRECTORY}/custom/plugins/zsh-syntax-highlighting already exists!"
fi

###############################################################################
# Set Symlinks to Repository Files for Configurations                         #
###############################################################################

# Set ZSH Configuration
ln -sfn ${DOTFILES_DIRECTORY}/.zshrc ${HOME}/.zshrc
for f in ${DOTFILES_DIRECTORY}/.zsh-env/*.zsh; do ln -sfn $f ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/$(basename -- $f); done

# Set SSH Configuration
# ln -sfn ${DOTFILES_DIRECTORY}/.ssh ${HOME}/.ssh

# Set iTerm2 Configruation
ln -sfn ${DOTFILES_DIRECTORY}/.iterm2 ${HOME}/.iterm2

# Set Git Configuration
for f in ${DOTFILES_DIRECTORY}/.git*; do ln -sfn $f ${HOME}/$(basename -- $f); done

###############################################################################
# Set GIT Settings                                                            #
###############################################################################

# Set Global Ignore File
git config --global core.excludesfile ~/.gitignore

# Set Global Commit Template File
git config --global commit.template ~/.gitmessage

###############################################################################
# Set iTerm2 Defaults & Settings                                              #
###############################################################################

# Set iTerm2 Custom Preferences Folder
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "${HOME}/.iterm2"

# Set Load from Custom Preferences Folder
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

# Install the Solarized Dark theme for iTerm (Set this if your profile doesn't already include it)
# open "${SCRIPT_DIR}/settings/iTerm2/Solarized-Dark.itermcolors"

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Enable Secure Keyboard Entry in Terminal.app
# See: https://security.stackexchange.com/a/47786/8918
defaults write com.apple.terminal SecureKeyboardEntry -bool true

###############################################################################
# Set macOS Defaults                                                          #
###############################################################################

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

###############################################################################
# Dock                                                                        #
###############################################################################

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Change location to left of the screen
defaults write com.apple.dock orientation -string "left"

# Hide recently opened apps in the dock
defaults write com.apple.dock how-recents -bool false

###############################################################################
# Track Pad & Mouse                                                           #
###############################################################################

# Set Scroll Direction: Natural to off
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Set Track Pad Tracking Speed to "Fast"
defaults write NSGlobalDomain com.apple.trackpad.scaling -int 3

# Set Mouse Tracking Speed to "Fast"
defaults write NSGlobalDomain com.apple.mouse.scaling -int 3

# Set Mouse Scroll Speed to "Fast"
defaults write NSGlobalDomain com.apple.scrollwheel.scaling -int 3

###############################################################################
# Time Machine                                                                #
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

###############################################################################
# Activity Monitor                                                            #
###############################################################################

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Spotlight                                                                   #
###############################################################################

# Disable Spotlight indexing for any volume that gets mounted and has not yet
# been indexed before.
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
# sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"

# Change indexing order and disable some search results
# Yosemite-specific search results (remove them if you are using macOS 10.9 or older):
#   MENU_DEFINITION
#   MENU_CONVERSION
#   MENU_EXPRESSION
#   MENU_SPOTLIGHT_SUGGESTIONS (send search queries to Apple)
#   MENU_WEBSEARCH             (send search queries to Apple)
#   MENU_OTHER
defaults write com.apple.spotlight orderedItems -array \
  '{"enabled" = 1;"name" = "APPLICATIONS";}' \
  '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
  '{"enabled" = 1;"name" = "MENU_EXPRESSION";}' \
  '{"enabled" = 0;"name" = "DIRECTORIES";}' \
  '{"enabled" = 0;"name" = "PDF";}' \
  '{"enabled" = 0;"name" = "FONTS";}' \
  '{"enabled" = 0;"name" = "DOCUMENTS";}' \
  '{"enabled" = 0;"name" = "MESSAGES";}' \
  '{"enabled" = 0;"name" = "CONTACT";}' \
  '{"enabled" = 0;"name" = "EVENT_TODO";}' \
  '{"enabled" = 0;"name" = "IMAGES";}' \
  '{"enabled" = 0;"name" = "BOOKMARKS";}' \
  '{"enabled" = 0;"name" = "MUSIC";}' \
  '{"enabled" = 0;"name" = "MOVIES";}' \
  '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
  '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
  '{"enabled" = 0;"name" = "SOURCE";}' \
  '{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
  '{"enabled" = 0;"name" = "MENU_OTHER";}' \
  '{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
  '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'

# Load new settings before rebuilding the index
killall mds > /dev/null 2>&1

# Make sure indexing is enabled for the main volume
sudo mdutil -i on / > /dev/null

# Rebuild the index from scratch
sudo mdutil -E / > /dev/null

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" \
  "cfprefsd" \
  "Dock" \
  "Finder"; do
  killall "${app}" &> /dev/null
done

echo "Done. Note that some of these changes require a logout/restart to take effect."
