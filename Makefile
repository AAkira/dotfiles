mac:
	/usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew update --force && brew upgrade
	brew install rmtrash

install-dev-tools:
	sudo easy_install pip
	make install-zsh
	make install-vim
	make install-java
	make install-go
	make install-pyenv

install-zsh:
	# install zsh
	brew install zsh
	sudo sh -c "echo '/usr/local/bin/zsh' >> /etc/shells"
	chsh -s /usr/local/bin/zsh
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

install-vim:
	# install neo vim
	brew install neovim/neovim/neovim
	# install dein vim
	curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
	sh ./installer.sh ~/.cache/dein

install-java:
	brew cask install java8

install-go:
	brew install go
	# dependencies
	brew install glide
	brew install dep
	# go mock
	go get github.com/golang/mock/gomock
	go install github.com/golang/mock/mockgen

install-pyenv:
	brew install pyenv
	brew install pyenv-virtualenv

install-rubyenv:
	brew install rbenv
	brew install ruby-build
	rbenv install $(rbenv install -l | grep -v - | tail -1)
	rbenv global $(rbenv install -l | grep -v - | tail -1)

install-node:
	brew install nodebrew
	mkdir -p ~/.nodebrew/src
	nodebrew install-binary stable
	nodebrew use stable
	# nodebrew ls-remote  // show version list

install-yarn:
	brew install yarn

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

install-aws:
	pip install awscli
	brew install git-secrets
	git secrets --register-aws --global

install-db:
	brew install mysql
	pip install mycli
	brew install redis

install-ios:
	# cocoapods
	sudo gem update --system -n /usr/local/bin
	sudo gem install -n /usr/local/bin cocoapods
	pod setup
	# xvim
	@echo "[キーチェーンアクセス]->[証明書アシスタント]->[証明書を作成]"
	@echo "name: XcodeSigner, 自己署名ルート, コード署名"
	@read -p "Enter keys if you set it: "
	sudo codesign -f -s XcodeSigner /Applications/Xcode.app
	mkdir -p XcodeProjects
	cd XcodeProjects && git clone https://github.com/XVimProject/XVim2
	cd XcodeProjects && xcode-select -p # success: /Applications/Xcode.app/Contents/Developer | set `xcode-select -s` if failure
	cd XcodeProjects/XVim2 &&	make

install-tools:
	# protobuf
	go get -u google.golang.org/grpc
	go get -u github.com/golang/protobuf/protoc-gen-go
	brew install protobuf
	# graphql
	npm install -g apollo
	# keynote highlight
	brew install highlight
	brew install luarocks
	# peco
	brew install peco
	# jq
	brew install jq
	# tree
	brew install tree

install:
	cp -r ./ ~/ 

