.PHONY: mac
mac:
	/usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew update --force && brew upgrade
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
	@[ -d "$$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
	@[ -d "$$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ] || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
	@[ -d "$$HOME/.oh-my-zsh/custom/plugins/zsh-completions" ] || git clone --depth=1 https://github.com/zsh-users/zsh-completions "$$HOME/.oh-my-zsh/custom/plugins/zsh-completions"
	@$(MAKE) install-ohmyzsh-theme
	@echo "==> Oh My Zsh setup completed!" 


.PHONY: install-vim-theme
install-vim-theme:
	mkdir -p ~/.config/nvim/colors
	curl -fsSL https://raw.githubusercontent.com/lifepillar/vim-solarized8/master/colors/solarized8.vim -o ~/.config/nvim/colors/solarized8.vim



.PHONY: setup-mise
setup-mise:
	@which mise >/dev/null 2>&1 || brew install mise
	mise install

.PHONY: setup-ghq

.PHONY: setup-default-extension
setup-default-extension:
	duti -s com.coteditor.CotEditor txt all
	duti -s com.coteditor.CotEditor json all
	duti -s com.coteditor.CotEditor xml all
	duti -s com.coteditor.CotEditor kt all
	duti -s com.coteditor.CotEditor java all
	duti -s com.coteditor.CotEditor css all
	duti -s com.coteditor.CotEditor md all
	duti -s com.coteditor.CotEditor yml all


	ln -sfn ~/lazygit/config.yml ~/Library/Application\ Support/lazygit/config.yml
	ln -sfn ~/herdr/config.toml ~/.config/herdr/config.toml
	ln -sfn ~/hunk/config.toml ~/.config/hunk/config.toml
	@$(MAKE) install-ohmyzsh-theme
	@echo "==> Configuration links created successfully."

.PHONY: install
install:
	cp -r ./ ~/

