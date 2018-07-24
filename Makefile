mac:
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew update --force && brew upgrade
	brew install rmtrash

install-develop:
	sudo easy_install pip
	make install-zsh
	make install-vim
	make install-plugins
	make install-go
	make install-pyenv

install-zsh:
	# install zsh
	brew install zsh
	sudo sh -c "echo '/usr/local/bin/zsh' >> /etc/shells"
	chsh -s /usr/local/bin/zsh
	# install oh-my-zsh
	curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
	# install syntax highlight
	sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	# install completions
	sudo git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions

install-vim:
	# install neo vim
	brew install neovim/neovim/neovim
	# install dein vim
	curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
	sh ./installer.sh ~/.cache/dein

install-plugins:
	brew install peco

install-go:
	brew install go
	brew install glide
	brew install dep

install-pyenv:
	brew install pyenv
	brew install pyenv-virtualenv

install-kube:
	brew install kubernetes-helm
	go get github.com/roboll/helmfile
	brew install direnv
	# pod log https://github.com/wercker/stern
	brew install stern 
	# https://github.com/kubernetes/kops
	brew install kops 

install-aws:
	pip install awscli
	brew install git-secrets
	git secrets --register-aws --global

install-db:
	brew install mysql
	pip install mycli

install-tools:
	# go mock
	go get github.com/golang/mock/gomock
	go install github.com/golang/mock/mockgen
	# protobuf
	go get -u google.golang.org/grpc
	brew install protobuf


install:
	cp -r ./ ~/ 
