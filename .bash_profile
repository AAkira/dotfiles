# default path
# export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
# brewのpathを優先/usr/local/bin
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

# android
export ANDROID_HOME=/Applications/eclipse/android:/Applications/Android/sdk
export PATH=$PATH:${ANDROIDNDK_HOME}
# node
export PATH=$HOME/.nodebrew/current/bin:$PATH
# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# 毎回 source ~/.bashrc するのが面倒なので
if [ -f ~/.bashrc ] ; then
. ~/.bashrc
fi

# cdをtypoしても自動的に正しく補正
shopt -s cdspell

# コマンド履歴を増やす defalut=500
export HISTFILESIZE=10000
export HISTSIZE=10000

# bash customize 
source ~/myprofile/.my_bash_info
# git 補完
source ~/.git-completion.bash
