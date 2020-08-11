#!/usr/bin/env bash

# Settings
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SSH_KEY_DIRECTORY="${SCRIPT_DIR}/dotfiles/.ssh/source-control"
PROJECT_DIRECTORY="${HOME}/Projects"
OH_MY_ZSH_DIRECTORY="${HOME}/.oh-my-zsh"

echo "Hello $(whoami)! Let's get you set up."
echo $SCRIPT_DIR

# Generate SSH Key
if [[ ! -e $SSH_KEY_DIRECTORY ]]; then
  mkdir -p $SSH_KEY_DIRECTORY
  ssh-keygen -t rsa -b 4096 -C "me+github@ethanpursley.com" -f $SSH_KEY_DIRECTORY/github
  git config --global core.excludesfile ~/.gitignore
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


# Symlink dotfiles
# ln -s "${SCRIPT_DIR}/dotfiles/.zshrc" "${HOME}/.zshrc"
ln -sfn ${SCRIPT_DIR}/dotfiles/.zsh-env ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/zsh-env
ln -sfn ${SCRIPT_DIR}/dotfiles/.iterm2 ${HOME}/.iterm2

###############################################################################
# Set iTerm2 Defaults & Settings                                              #
###############################################################################

# Set iTerm2 Custom Preferences Folder
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "${HOME}/.iterm2"

# Set Load from Custom Preferences Folder
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

# Set Save Preferences To Custom Folder when Exiting
# defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile_selection -int 1

# Set Onboarding to viewed
# defaults write com.googlecode.iterm2 NoSyncOnboardingWindowHasBeenShown -bool true

# Set Auto-Update to true
# defaults write com.googlecode.iterm2 SUEnableAutomaticChecks -bool true

# Install the Solarized Dark theme for iTerm
open "${SCRIPT_DIR}/settings/iTerm2/Solarized-Dark.itermcolors"

# ###############################################################################
# # Set macOS Defaults                                                          #
# ###############################################################################

# # Save to disk (not to iCloud) by default
# defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# # Automatically quit printer app once the print jobs complete
# defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# ###############################################################################
# # Dock, Dashboard, and hot corners                                            #
# ###############################################################################

# # Automatically hide and show the Dock
# defaults write com.apple.dock autohide -bool true

# # Minimize windows into their application’s icon
# defaults write com.apple.dock minimize-to-application -bool true

# # Change location to left of the screen
# defaults write com.apple.dock orientation -string "left"

# # Hide recently opened apps in the dock
# defaults write com.apple.dock how-recents -bool false

# ###############################################################################
# # Spotlight                                                                   #
# ###############################################################################

# # Disable Spotlight indexing for any volume that gets mounted and has not yet
# # been indexed before.
# # Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
# sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"

# # Change indexing order and disable some search results
# # Yosemite-specific search results (remove them if you are using macOS 10.9 or older):
# #   MENU_DEFINITION
# #   MENU_CONVERSION
# #   MENU_EXPRESSION
# #   MENU_SPOTLIGHT_SUGGESTIONS (send search queries to Apple)
# #   MENU_WEBSEARCH             (send search queries to Apple)
# #   MENU_OTHER
# defaults write com.apple.spotlight orderedItems -array \
#   '{"enabled" = 1;"name" = "APPLICATIONS";}' \
#   '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
#   '{"enabled" = 1;"name" = "DIRECTORIES";}' \
#   '{"enabled" = 1;"name" = "PDF";}' \
#   '{"enabled" = 1;"name" = "FONTS";}' \
#   '{"enabled" = 0;"name" = "DOCUMENTS";}' \
#   '{"enabled" = 0;"name" = "MESSAGES";}' \
#   '{"enabled" = 0;"name" = "CONTACT";}' \
#   '{"enabled" = 0;"name" = "EVENT_TODO";}' \
#   '{"enabled" = 0;"name" = "IMAGES";}' \
#   '{"enabled" = 0;"name" = "BOOKMARKS";}' \
#   '{"enabled" = 0;"name" = "MUSIC";}' \
#   '{"enabled" = 0;"name" = "MOVIES";}' \
#   '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
#   '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
#   '{"enabled" = 0;"name" = "SOURCE";}' \
#   '{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
#   '{"enabled" = 0;"name" = "MENU_OTHER";}' \
#   '{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
#   '{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
#   '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
#   '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'

# # Load new settings before rebuilding the index
# killall mds > /dev/null 2>&1

# # Make sure indexing is enabled for the main volume
# sudo mdutil -i on / > /dev/null

# # Rebuild the index from scratch
# sudo mdutil -E / > /dev/null

# ###############################################################################
# # Terminal & iTerm 2                                                          #
# ###############################################################################

# # Only use UTF-8 in Terminal.app
# defaults write com.apple.terminal StringEncodings -array 4

# # Enable Secure Keyboard Entry in Terminal.app
# # See: https://security.stackexchange.com/a/47786/8918
# defaults write com.apple.terminal SecureKeyboardEntry -bool true

# # Disable the annoying line marks
# defaults write com.apple.Terminal ShowLineMarks -int 0

# ###############################################################################
# # Time Machine                                                                #
# ###############################################################################

# # Prevent Time Machine from prompting to use new hard drives as backup volume
# defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# ###############################################################################
# # Activity Monitor                                                            #
# ###############################################################################

# # Show the main window when launching Activity Monitor
# defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# # Show all processes in Activity Monitor
# defaults write com.apple.ActivityMonitor ShowCategory -int 0

# # Sort Activity Monitor results by CPU usage
# defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
# defaults write com.apple.ActivityMonitor SortDirection -int 0

# ###############################################################################
# # Kill affected applications                                                  #
# ###############################################################################

# for app in "Activity Monitor" \
#   "Address Book" \
#   "cfprefsd" \
#   "Dock" \
#   "Finder"; do
#   killall "${app}" &> /dev/null
# done
# echo "Done. Note that some of these changes require a logout/restart to take effect."
