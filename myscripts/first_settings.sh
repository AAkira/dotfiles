
# ctrl + rでコマンド履歴を遡る際に
# ctrl + sで履歴を進める機能を有効にする
stty stop undef

# homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# neobundle install
curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh

# nodebrew
brew install nodebrew
# nodejs
sudo nodebrew install-binary stable
sudo nodebrew use stable

# lua install
brew install lua

# vim update
brew update
brew reinstall vim --with-lua
# (+lua)になってればok
# vim --version | grep lua
