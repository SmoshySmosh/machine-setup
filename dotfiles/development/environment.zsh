# Use this file to store all environment variables

export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

# Chrome Driver
export DETECT_CHROMEDRIVER_VERSION=true

# Python Setup
# export PYTHONPATH="/usr/local/opt/python@3.8/libexec/bin"

# Android Development
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export ANT_HOME=/usr/local/opt/ant
export MAVEN_HOME=/usr/local/opt/maven
export GRADLE_HOME=/usr/local/opt/gradle
export ANDROID_HOME=/usr/local/share/android-sdk
export ANDROID_NDK_HOME=/usr/local/share/android-sdk/ndk-bundle
export INTEL_HAXM_HOME=/usr/local/Caskroom/intel-haxm
export PATH=$ANT_HOME/bin:$PATH
export PATH=$MAVEN_HOME/bin:$PATH
export PATH=$GRADLE_HOME/bin:$PATH
export PATH=$ANDROID_HOME/tools:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/build-tools/23.0.1:$PATH

# PATH Additions
export PATH="/usr/local/opt/curl/bin:$PATH"
# export PATH="/usr/local/sbin:$PATH:/usr/local/opt/go/libexec/bin:/Users/$USER/go/bin"
