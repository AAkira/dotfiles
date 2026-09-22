.PHONY: mac
mac:
	/usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew update --force && brew upgrade
	brew install rmtrash
.PHONY: brew-bundle
brew-bundle:
	brew bundle

.PHONY: init-mac
init-mac:
	# Keyboard settings
	# Set fastest key repeat rate (1 is absolute fastest)
	defaults write -g KeyRepeat -int 1
	# Reduce key repeat delay (20 is optimal limit before fallback)
	defaults write -g InitialKeyRepeat -int 20
	# Disable press-and-hold for keys in favor of key repeat
	defaults write -g ApplePressAndHoldEnabled -bool false
	# Use F1, F2, etc. keys as standard function keys
	defaults write -g com.apple.keyboard.fnState -bool true
	# Configure input source shortcuts
	make init-shortcut
	# Screenshot settings
	# Disable shadow in screenshots
	defaults write com.apple.screencapture disable-shadow -bool true
	# Save screenshots as JPEG
	defaults write com.apple.screencapture type jpg
	# Finder settings
	# Show hidden files by default
	defaults write com.apple.finder AppleShowAllFiles -bool true
	# Show all filename extensions
	defaults write NSGlobalDomain AppleShowAllExtensions -bool true
	# Display full POSIX path in Finder window title
	defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
	# Show path bar
	defaults write com.apple.finder ShowPathbar -bool true
	# Show status bar
	defaults write com.apple.finder ShowStatusBar -bool true
	# Use list view in all Finder windows by default
	defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
	# Dock settings
	# Automatically hide and show the Dock
	defaults write com.apple.dock autohide -bool true
	# Do not show recent applications in Dock
	defaults write com.apple.dock show-recents -bool false
	# Do not rearrange Spaces based on most recent use (required for tiling WMs like AeroSpace)
	defaults write com.apple.dock mru-spaces -bool false
	# Restart affected applications
	killall Finder 2>/dev/null || true
	killall Dock 2>/dev/null || true
	killall SystemUIServer 2>/dev/null || true

.PHONY: init-shortcut
init-shortcut:
	@python3 ~/myscripts/set_shortcuts.py

.PHONY: japanese-input
japanese-input:
	@if [ ! -d "/Library/Input Methods/GoogleJapaneseInput.app" ]; then \
		echo "Installing Google Japanese IME via Homebrew..."; \
		brew install --cask google-japanese-ime; \
	else \
		echo "Google Japanese IME is already installed."; \
	fi
	@echo "Opening Keyboard Settings..."
	@open "x-apple.systempreferences:com.apple.Keyboard-Settings.extension" || true
	@echo ""
	@echo "============================================================"
	@echo "【Google日本語入力の設定手順】"
	@echo "1. 開いた「キーボード」設定の「入力ソース」>「編集...」をクリック"
	@echo "2. 左下の「+」ボタンから「日本語」>「ひらがな (Google)」を追加"
	@echo "============================================================"

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

.PHONY: install-oh-my-zsh
install-oh-my-zsh:
	@if [ ! -d "$$HOME/.oh-my-zsh/.git" ]; then \
		echo "==> Installing Oh My Zsh..."; \
		TMP_BACKUP=$$(mktemp -d); \
		if [ -d "$$HOME/.oh-my-zsh/custom" ]; then cp -r "$$HOME/.oh-my-zsh/custom" "$$TMP_BACKUP/"; fi; \
		if [ -d "$$HOME/.oh-my-zsh/themes" ]; then cp -r "$$HOME/.oh-my-zsh/themes" "$$TMP_BACKUP/"; fi; \
		rm -rf "$$HOME/.oh-my-zsh"; \
		git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$$HOME/.oh-my-zsh"; \
		if [ -d "$$TMP_BACKUP/custom" ]; then cp -rn "$$TMP_BACKUP/custom/." "$$HOME/.oh-my-zsh/custom/" 2>/dev/null || true; fi; \
		if [ -d "$$TMP_BACKUP/themes" ]; then cp -rn "$$TMP_BACKUP/themes/." "$$HOME/.oh-my-zsh/themes/" 2>/dev/null || true; fi; \
		rm -rf "$$TMP_BACKUP"; \
		echo "==> Oh My Zsh installed successfully."; \
	else \
		echo "==> Oh My Zsh is already installed."; \
	fi
	@echo "==> Installing Oh My Zsh plugins..."; \
	mkdir -p ~/.oh-my-zsh/custom/plugins
	@[ -d "$$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
	@[ -d "$$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ] || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
	@[ -d "$$HOME/.oh-my-zsh/custom/plugins/zsh-completions" ] || git clone --depth=1 https://github.com/zsh-users/zsh-completions "$$HOME/.oh-my-zsh/custom/plugins/zsh-completions"
	@$(MAKE) install-ohmyzsh-theme
	@echo "==> Oh My Zsh setup completed!" 

.PHONY: install-vim
install-vim:
	# install neo vim
	brew install neovim

.PHONY: install-vim-theme
install-vim-theme:
	mkdir -p ~/.config/nvim/colors
	curl -fsSL https://raw.githubusercontent.com/lifepillar/vim-solarized8/master/colors/solarized8.vim -o ~/.config/nvim/colors/solarized8.vim

.PHONY: install-asdf
install-asdf:
	brew install asdf
	asdf plugin add python
	asdf plugin add flutter
	asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
	asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
	asdf plugin add java https://github.com/halcyon/asdf-java.git
	asdf plugin add awscli

.PHONY: install-yarn
install-yarn:
	# using asdf
	corepack enable
	asdf reshim nodejs

.PHONY: install-ghq
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

.PHONY: install-lazygit
install-lazygit:
	brew install lazygit git-delta
	mkdir -p ~/Library/Application\ Support/lazygit
	ln -sfn ~/lazygit/config.yml ~/Library/Application\ Support/lazygit/config.yml

.PHONY: install-herdr
install-herdr:
	brew install herdr
	mkdir -p ~/.config/herdr
	ln -sfn ~/herdr/config.toml ~/.config/herdr/config.toml

.PHONY: install-hunk
install-hunk:
	brew install hunk
	mkdir -p ~/.config/hunk
	ln -sfn ~/hunk/config.toml ~/.config/hunk/config.toml
	@$(MAKE) install-ohmyzsh-theme
	@echo "==> Configuration links created successfully."

.PHONY: install
install:
	cp -r ./ ~/

