export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

# asdf
. $(brew --prefix asdf)/libexec/asdf.sh

# android
export ANDROID_HOME=~/Library/Android/sdk
export PATH=$PATH:${ANDROID_HOME}
export PATH=$PATH:${ANDROID_HOME}/platform-tools
export PATH=$PATH:${ANDROID_HOME}/tools

# poetry
export PATH="$HOME/.poetry/bin:$PATH"

# go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# flutter (fvm)
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


export PATH="$PATH":"/Applications/Docker.app/Contents/Resources/bin/docker-compose-v1"
export PATH="$PATH":"/Applications/Docker.app/Contents/Resources/bin/"

# for asdf ruby on m1 mac
RUBY_CONFIGURE_OPTS='--build aarch64-apple-darwin20.6'
RUBY_CFLAGS=-DUSE_FFI_CLOSURE_ALLOC

