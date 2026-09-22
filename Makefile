.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  setup                    Run complete initialization setup"
	@echo "  mac                      Install Homebrew, update, and run brew bundle"
	@echo "  brew-bundle              Install packages defined in Brewfile"
	@echo "  init-mac                 Apply macOS defaults (Finder, Dock, keyboard, etc.)"
	@echo "  init-shortcut            Configure keyboard & Mission Control shortcuts"
	@echo "  japanese-input           Install & configure Google Japanese IME"
	@echo "  install-oh-my-zsh        Install Oh My Zsh, plugins, and custom theme"
	@echo "  setup-mise               Install mise and run mise install"
	@echo "  link-configs             Create symbolic links for config files (lazygit, herdr, hunk, etc.)"
	@echo "  setup-default-extension  Associate text/code file extensions with CotEditor"
	@echo "  setup-ghq                Configure ghq root directory"
	@echo "  install-vim-theme        Install Neovim solarized8 color scheme"
	@echo "  setup-iterm-theme        Configure iTerm2 color theme (Solarized Light)"

.PHONY: setup
setup:
	@echo "=========================================="
	@echo "  Starting dotfiles initial setup"
	@echo "=========================================="
	@$(MAKE) mac
	@$(MAKE) init-mac
	@$(MAKE) install-oh-my-zsh
	@$(MAKE) setup-mise
	@$(MAKE) link-configs
	@$(MAKE) setup-ghq
	@$(MAKE) setup-default-extension
	@$(MAKE) install-vim-theme
	@$(MAKE) setup-iterm-theme
	@echo ""
	@echo "=========================================="
	@echo "  Setup completed!"
	@echo "  Run 'make japanese-input' if you need Google Japanese IME."
	@echo "=========================================="

.PHONY: mac
mac:
	@which brew >/dev/null 2>&1 || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew update --force && brew upgrade
	brew bundle

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
	# Configure input source & Mission Control shortcuts
	@$(MAKE) init-shortcut
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
	@echo "==> Installing Oh My Zsh plugins..."
	@mkdir -p ~/.oh-my-zsh/custom/plugins
	@[ -d "$$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
	@[ -d "$$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ] || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
	@[ -d "$$HOME/.oh-my-zsh/custom/plugins/zsh-completions" ] || git clone --depth=1 https://github.com/zsh-users/zsh-completions "$$HOME/.oh-my-zsh/custom/plugins/zsh-completions"
	@$(MAKE) install-ohmyzsh-theme
	@echo "==> Oh My Zsh setup completed!"

.PHONY: install-ohmyzsh-theme
install-ohmyzsh-theme:
	@mkdir -p ~/.oh-my-zsh/custom/themes
	@mkdir -p ~/.oh-my-zsh/themes
	ln -sfn ~/git-misc/ohmyzsh-theme/aatheme.zsh-theme ~/.oh-my-zsh/custom/themes/aatheme.zsh-theme
	ln -sfn ~/git-misc/ohmyzsh-theme/aatheme.zsh-theme ~/.oh-my-zsh/themes/aatheme.zsh-theme

.PHONY: setup-mise
setup-mise:
	@which mise >/dev/null 2>&1 || brew install mise
	mise install

.PHONY: setup-ghq
setup-ghq:
	git config --global ghq.root '~/src'

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


.PHONY: setup-iterm-theme
setup-iterm-theme:
	@python3 ~/myscripts/set_iterm_solarized.py

.PHONY: link-configs
link-configs:
	@echo "==> Linking tool configurations..."
	@mkdir -p ~/Library/Application\ Support/lazygit
	ln -sfn ~/lazygit/config.yml ~/Library/Application\ Support/lazygit/config.yml
	@mkdir -p ~/.config/herdr
	ln -sfn ~/herdr/config.toml ~/.config/herdr/config.toml
	@mkdir -p ~/.config/hunk
	ln -sfn ~/hunk/config.toml ~/.config/hunk/config.toml
	@$(MAKE) install-ohmyzsh-theme
	@echo "==> Configuration links created successfully."

.PHONY: install
install:
	cp -r ./ ~/

