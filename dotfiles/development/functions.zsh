# Setup Composer
function composer () {
  echo "Current working directory: \"$(pwd)\""
  echo "Current Command: \"$0 $*\""
  tty=
  tty -s && tty=--tty
  docker run \
    $tty \
    --interactive \
    --rm \
    -e COMPOSER_HOME=/composer \
    --volume "$HOME/.ssh":/root/.ssh \
    --volume "$HOME/.composer":/composer \
    --volume "$(pwd)":/app \
    composer:latest \
    composer "$@"
}

# Setup NGINX
function nginx () {
  echo "Current working directory: \"$(pwd)\""
  echo "Current Command: \"$0 $*\""
  docker run \
    --interactive \
    --rm \
    -v "$(pwd)":/usr/share/nginx/html \
    -p 80:80 \
    nginx:latest
}

# Brew Utilitiy
function brew-update () {
  # Update Brew Installs
  brew update
  brew upgrade
  brew cask upgrade
  brew cleanup -s

  # Run Diagnostics
  brew doctor
  brew missing
}

function brew-reinstall () {
  brew list | xargs brew reinstall
}

# Android Emulator Fix
function emulator () {
  /usr/local/share/android-sdk/tools/emulator "$@"
}

# Legacy Functions
# function zscaler-disable () {
#   while read -r device; do
#     echo "[$device]"
#     sudo networksetup -setautoproxystate "$device" off;
#     echo "Proxy Disabled! \n"
#   done <<< "$(networksetup -listallnetworkservices | tail -n +2)"
# }

# function managesoft-disable() {
#   sudo /opt/managesoft/install/unconfigure.sh
#   sudo chmod -R 000 /opt/managesoft/bin/*
#   sudo chmod -R 000 /opt/managesoft/libexec/*
# }

# function managesoft-enable() {
#   sudo /opt/managesoft/install/configure.sh
#   sudo chmod -R 700 /opt/managesoft/bin/*
#   sudo chmod -R 700 /opt/managesoft/libexec/*
# }

# # JAMF Tools
# function jamf-status () {
#   process=$(ps aux | grep -i jamf | grep -v grep | wc -l)

#   if [ $process -gt 0 ]; then
#       echo "JAMF is running! \n"
#   else
#       echo "JAMF is not running! \n"
#   fi
# }

# function jamf-enable () {
#   sudo chmod 0755 /usr/local/jamf/bin/jamf;
#   sudo chmod 0755 /usr/local/jamf/bin/jamfAgent;
#   sudo chmod 0755 /Library/Application\ Support/JAMF/Jamf.app/Contents/MacOS/JamfAgent.app/Contents/MacOS/JamfAgent
#   sudo chmod 0755 /Library/Application\ Support/JAMF/Jamf.app/Contents/MacOS/JamfDaemon.app/Contents/MacOS/JamfDaemon
#   jamf-status
# }

# function jamf-disable () {
#   # Change permissions of files so they can not be run
#   sudo chmod 0000 /usr/local/jamf/bin/jamf;
#   sudo chmod 0000 /usr/local/jamf/bin/jamfAgent;
#   sudo chmod 0000 /Library/Application\ Support/JAMF/Jamf.app/Contents/MacOS/JamfAgent.app/Contents/MacOS/JamfAgent
#   sudo chmod 0000 /Library/Application\ Support/JAMF/Jamf.app/Contents/MacOS/JamfDaemon.app/Contents/MacOS/JamfDaemon

#   # Kill Remaining processes
#   for pid in $(ps -ax | grep -i jamf | grep -v grep | awk '{print $1}'); do
#       sudo kill -9 $pid
#   done

#   # Disable zScaler and check status
#   zscaler-disable
#   jamf-status
# }

# function jamf-report () {
#   jamf-enable
#   sudo jamf recon
#   jamf-disable
# }
