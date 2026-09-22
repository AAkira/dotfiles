export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

# brew
eval $(/opt/homebrew/bin/brew shellenv)

# mise
if command -v mise >/dev/null 2>&1; then
  if [ -n "$ZSH_VERSION" ]; then
    eval "$(mise activate zsh)"
  else
    eval "$(mise activate bash)"
  fi
fi

# local bin & tools (Antigravity CLI, etc.)
export PATH="$HOME/.local/bin:$PATH"

# android
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools"

# go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# myscript
export PATH="$PATH:$HOME/myscripts"

# read my tokens
if [ -f "$HOME/.aa-conf" ]; then
  source "$HOME/.aa-conf"
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
  . "$HOME/google-cloud-sdk/path.zsh.inc";
fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
  . "$HOME/google-cloud-sdk/completion.zsh.inc";
fi

# Docker
export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin/docker-compose-v1"
export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin"

