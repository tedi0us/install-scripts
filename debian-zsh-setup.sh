#!/bin/bash

# Install required packages
sudo apt update
sudo apt install -y zsh curl git wget fonts-powerline

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Create new .zshrc
cat > ~/.zshrc << 'EOL'
# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme settings
ZSH_THEME="gruvbox"
SOLARIZED_THEME="dark"

# Plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    colored-man-pages
    command-not-found
    debian
    docker
    history
    sudo
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# History settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt appendhistory
setopt sharehistory
setopt incappendhistory

# Enable correction
setopt correct
setopt correctall
export SPROMPT="Correct %R to %r? [Yes, No, Abort, Edit] "

# Better completion
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Useful aliases
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias update='sudo apt update && sudo apt upgrade'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias grep='grep --color=auto'

# Set colors for ls
eval "$(dircolors -b)"
alias ls='ls --color=auto'

# Gruvbox theme colors for terminal
if [[ -z "$TMUX" ]]; then
    export TERM="xterm-256color"
fi
EOL

# Install gruvbox theme
curl -L -o ~/.oh-my-zsh/custom/themes/gruvbox.zsh-theme https://raw.githubusercontent.com/sbugzu/gruvbox-zsh/master/gruvbox.zsh-theme

# Make zsh the default shell
chsh -s $(which zsh)

echo "Installation complete! Please log out and log back in for the shell change to take effect."
echo "You might want to install a Nerd Font for better icons: https://www.nerdfonts.com/"
