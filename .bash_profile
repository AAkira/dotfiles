export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

# android
export ANDROID_HOME=/Applications/eclipse/android:/Applications/Android/sdk:/Applications/android-sdk
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

# go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# myscript
export PATH=$PATH:$HOME/myscripts
