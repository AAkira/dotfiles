export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/Users/a13885/Library/Android/sdk
ANDROIDNDK_HOME=/Applications/android-ndk-r7
export PATH=$PATH:${ANDROIDNDK_HOME}
export NODE_PATH=/usr/local/lib/node_modules\n
export ANDROID_HOME=/Applications/eclipse/android

# 毎回 source ~/.bashrc するのが面倒なので
if [ -f ~/.bashrc ] ; then
. ~/.bashrc
fi

# cdをtypoしても自動的に正しく補正
shopt -s cdspell

# コマンド履歴を増やす defalut=500
export HISTFILESIZE=10000
export HISTSIZE=10000

# bash info position, git...
# ここに書くと複雑で長いので外部ファイルを読み込む
source ~/.my_bash_info
