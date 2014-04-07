export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/Applications/eclipse/android/platform-tools:/Applications/eclipse/android/apktool
ANDROIDNDK_HOME=/Applications/android-ndk-r7
export PATH=$PATH:${ANDROIDNDK_HOME}
export NODE_PATH=/usr/local/lib/node_modules\n

# 毎回 source ~/.bashrc するのが面倒なので
if [ -f ~/.bashrc ] ; then
. ~/.bashrc
fi
