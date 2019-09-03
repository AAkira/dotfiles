export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

# java
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

# android
export ANDROID_HOME=~/Library/Android/sdk
export PATH=$PATH:${ANDROID_HOME}
export PATH=$PATH:${ANDROID_HOME}/platform-tools
export PATH=$PATH:${ANDROID_HOME}/tools

# node
export PATH=$HOME/.nodebrew/current/bin:$PATH

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/shims:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# rbenv
[[ -d ~/.rbenv  ]] && \
  export PATH=${HOME}/.rbenv/bin:${PATH} && \
  eval "$(rbenv init -)"

# go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# flutter
export PATH="$HOME/flutter/bin:$PATH"

# myscript
export PATH=$PATH:$HOME/myscripts

# read my tokens
source ~/.aa-conf
