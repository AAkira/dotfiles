export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

# java
export JAVA_HOME=`/usr/libexec/java_home -v 11`
PATH="$PATH:$JAVA_HOME/bin"

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

# poetry
export PATH="$HOME/.poetry/bin:$PATH"

# rbenv
[[ -d ~/.rbenv  ]] && \
  export PATH=${HOME}/.rbenv/bin:${PATH} && \
  eval "$(rbenv init -)"

# go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# flutter fvm
export PATH="$PATH":"$HOME/.pub-cache/bin"

# myscript
export PATH=$PATH:$HOME/myscripts

# read my tokens
source ~/.aa-conf

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
  . "$HOME/google-cloud-sdk/path.zsh.inc";
fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
  . "$HOME/google-cloud-sdk/completion.zsh.inc";
fi

# SDK_MAN
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export PATH="$PATH":"/Applications/Docker.app/Contents/Resources/bin/docker-compose-v1"
export PATH="$PATH":"/Applications/Docker.app/Contents/Resources/bin/"

export PATH="$HOME/.poetry/bin:$PATH"
