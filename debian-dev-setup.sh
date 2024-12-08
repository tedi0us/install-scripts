#!/bin/bash

# Function to print section headers
print_section() {
    echo "===================="
    echo "$1"
    echo "===================="
}

# Update system first
print_section "Updating System"
sudo apt update && sudo apt upgrade -y

# Install basic dependencies
print_section "Installing Basic Dependencies"
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common \
    wget \
    git

# Install Azure CLI
print_section "Installing Azure CLI"
curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | \
    sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt update
sudo apt install -y azure-cli

# Install GitHub CLI
print_section "Installing GitHub CLI"
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
    sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
    sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install -y gh

# Install Visual Studio Code
print_section "Installing Visual Studio Code"
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt update
sudo apt install -y code

# Install Google Chrome
print_section "Installing Google Chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

# Install Slack
print_section "Installing Slack"
wget https://downloads.slack-edge.com/releases/linux/4.29.149/prod/x64/slack-desktop-4.29.149-amd64.deb
sudo apt install -y ./slack-desktop-*.deb
rm slack-desktop-*.deb

# Install Azure Functions Core Tools
print_section "Installing Azure Functions Core Tools"
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
echo "deb [arch=amd64] https://packages.microsoft.com/debian/$(lsb_release -rs | cut -d'.' -f 1)/prod $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/azure-functions.list
sudo apt update
sudo apt install -y azure-functions-core-tools-4

# Python alias and pip setup
print_section "Setting up Python environment"
sudo apt install -y python3-pip python3-venv
echo "alias python=python3" >> ~/.zshrc
echo "alias pip=pip3" >> ~/.zshrc

# Install additional useful tools
print_section "Installing Additional Tools"
sudo apt install -y \
    htop \
    tldr \
    neofetch \
    tree \
    jq \
    ripgrep \
    fd-find \
    ncdu \
    tmux \
    net-tools \
    mlocate

# Setup Node.js using nvm
print_section "Setting up Node.js"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm use --lts

# Add useful aliases to .zshrc
print_section "Adding useful aliases"
cat >> ~/.zshrc << 'EOL'

# Custom aliases
alias update='sudo apt update && sudo apt upgrade'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias l='ls -lah'
alias cls='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias g='git'
alias gst='git status'
alias gd='git diff'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias python=python3
alias pip=pip3

# NVM setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Add Visual Studio Code to path
export PATH="$PATH:/usr/bin/code"

# Azure Functions Core Tools alias
alias func='azure-functions-core-tools'

EOL

# Create common development directories
print_section "Creating development directories"
mkdir -p ~/Development/Projects
mkdir -p ~/Development/Scripts
mkdir -p ~/Development/Tools

print_section "Installation Complete!"
echo "Please restart your terminal or source your .zshrc file:"
echo "source ~/.zshrc"

# Print installed versions
print_section "Installed Versions"
echo "Node.js: $(node -v)"
echo "npm: $(npm -v)"
echo "Python: $(python3 --version)"
echo "pip: $(pip3 --version)"
echo "Azure CLI: $(az --version | head -n 1)"
echo "GitHub CLI: $(gh --version | head -n 1)"
