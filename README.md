# my dotfiles

## Setup

```bash
# Run all initial setup at once:
make setup

# Or run individual steps:
make mac                      # Install Homebrew & run brew bundle
make init-mac                 # Apply macOS defaults (includes shortcuts)
make init-shortcut            # Configure keyboard & Mission Control shortcuts
make install-oh-my-zsh        # Install Oh My Zsh, plugins, and custom theme
make setup-mise               # Install mise and tools
make link-configs             # Link tool configs (lazygit, herdr, hunk, etc.)
make japanese-input           # Install & open settings for Google Japanese Input
make setup-default-extension  # Set CotEditor as default editor for text files
make install-vim-theme        # Install Neovim solarized8 color scheme
make setup-iterm-theme        # Configure iTerm2 color theme (Solarized Light)
make help                     # Show available targets
```

## Shell

I use zsh and oh-my-zsh.  
I don't use the `.bashrc` now.  

## Vim

I use [neovim](https://neovim.io/).  
I don't use the `.vimrc` now.  

The nvim config file is [`~/.config/nvim/init.vim`](https://github.com/AAkira/dotfiles/blob/master/.config/nvim/init.vim)  

I manage plugins using [dein.vim](https://github.com/Shougo/dein.vim).    

The dein.vim config file is [`.vim/rc/dein_lazy.toml`](https://github.com/AAkira/dotfiles/blob/master/.vim/rc/dein_lazy.toml)


## Trash

There are old files in the `.old` folder.
