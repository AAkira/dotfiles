.PHONY: mac
mac:
	/usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew update --force && brew upgrade
	brew install rmtrash

.PHONY: init-mac
init-mac:
	# screen shot settings
	defaults write com.apple.screencapture disable-shadow -boolean true
	defaults write com.apple.screencapture type jpg
	# key speed
	defaults write -g KeyRepeat -int 2
	defaults write -g InitialKeyRepeat -int 15
	# finder
	defaults write com.apple.finder _FXShowPosixPathInTitle -boolean true && killall Finder
	defaults write com.apple.finder AppleShowAllFiles true && killall Finder off

.PHONY: install-dev-tools
install-dev-tools:
	sudo easy_install pip
	make install-zsh
	make install-vim
	make install-java
	make install-go
	make install-pyenv
	make install-node
	make install-dart
	make install-fvm

.PHONY: install-zsh
install-oh-my-zsh:
	# install oh-my-zsh
	curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
	# restore dotfile
	cp ~/dotfiles/.zshrc ~/
	# install syntax highlight
	sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	# install completions
	sudo git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
	# apply oy-my-zsh mytheme (aatheme.zsh-theme based on kphoen)
	ln -s ~/git-misc/ohmyzsh-theme/aatheme.zsh-theme ~/.oh-my-zsh/themes
	# zsh-autosuggestions 
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

.PHONY: install-vim
install-vim:
	# install neo vim
	brew install neovim

.PHONY: install-vim-theme
install-vim-theme:
	cd ~/.config/nvim/colors
	curl https://github.com/lifepillar/vim-solarized8/tree/master/colors/solarized8.vim -o solarized8.vim

.PHONY: install-asdf
install-asdf:
	brew install asdf
	asdf plugin-add python
	asdf plugin add flutter
	asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
	asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
	asdf plugin-add java https://github.com/halcyon/asdf-java.git

.PHONY: install-yarn
install-yarn:
	# using asdf
	corepack enable
	asdf reshim nodejs

.PHONY: install-qhq
install-ghq:
	brew install ghq
	git config --global ghq.root '~/src'

.PHONY: install-linter
install-linter:
	npm install textlint --global
	# For Japanese
	npm i -g textlint-rule-max-ten textlint-rule-spellcheck-tech-word textlint-rule-no-mix-dearu-desumasu
	# js linter
	npm install -g eslint
	# js formatter
	npm install prettier -D
	# python errror checker
	pip install pyflakes
	# python linter
	pip install pep8
	# python formatter
	pip install --upgrade autopep8
	pip install isort
	# vim
	pip install vim-vint

.PHONY: install-java
install-java:
	brew cask install java8

.PHONY: install-go
install-go:
	brew install go
	# dependencies
	brew install glide
	brew install dep
	# go mock
	go get github.com/golang/mock/gomock
	go install github.com/golang/mock/mockgen

.PHONY: install-ts
install-ts:
	npm install -g typescript
	npm install -g ts-node

.PHONY: install-kube
install-kube:
	brew install kubernetes-helm
	go get github.com/roboll/helmfile
	brew install direnv
	# pod log https://github.com/wercker/stern
	brew install stern 
	# https://github.com/kubernetes/kops
	brew install kops 
	# https://github.com/GoogleContainerTools/skaffold
	brew install skaffold

.PHONY: install-aws
install-aws:
	pip install awscli
	brew install git-secrets
	git secrets --register-aws --global

.PHONY: install-db
install-db:
	brew install mysql
	pip install mycli
	brew install redis

.PHONY: install-ios
install-ios:
	# cocoapods
	sudo gem update --system -n /usr/local/bin
	sudo gem install -n /usr/local/bin cocoapods
	pod setup
	# swimat
	brew cask install swimat
	@echo "Open swimat app"
	@echo "Xcode > Editor > Swimat"
	# xvim
	@echo "[キーチェーンアクセス]->[証明書アシスタント]->[証明書を作成]"
	@echo "name: XcodeSigner, 自己署名ルート, コード署名"
	@read -p "Enter keys if you set it: "
	sudo codesign -f -s XcodeSigner /Applications/Xcode.app
	mkdir -p XcodeProjects
	cd XcodeProjects && git clone https://github.com/XVimProject/XVim2
	cd XcodeProjects && xcode-select -p # success: /Applications/Xcode.app/Contents/Developer | set `xcode-select -s` if failure
	cd XcodeProjects/XVim2 &&	make

.PHONY: install-xvim
update-xvim:
	cd XcodeProjects && git pull origin master
	cd XcodeProjects/XVim2 && make
	sudo codesign -f -s XcodeSigner /Applications/Xcode.app

.PHONY: install-tools
install-tools:
	# keynote highlight
	brew install highlight
	# peco
	brew install peco
	# jq
	brew install jq
	# tree
	brew install tree
	
.PHONY: setup-default-extension
setup-default-extension:
	# open some files by CotEditor because there are opened by XCode
	brew install duti
	duti -s com.coteditor.CotEditor txt all
	duti -s com.coteditor.CotEditor json all
	duti -s com.coteditor.CotEditor xml all
	duti -s com.coteditor.CotEditor kt all
	duti -s com.coteditor.CotEditor java all
	duti -s com.coteditor.CotEditor css all
	duti -s com.coteditor.CotEditor md all
	duti -s com.coteditor.CotEditor yml all

.PHONY: install-misc
install-misc:
	# https://github.com/fumiyas/home-commands/blob/master/echo-sd
	brew tap fumiyas/echo-sd
	brew install echo-sd

.PHONY: install
install:
	cp -r ./ ~/ 

