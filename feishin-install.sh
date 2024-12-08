#!/bin/bash

# Create a directory for the download
mkdir -p ~/Applications/feishin
cd ~/Applications/feishin

# Download the latest release of Feishin
echo "Downloading latest Feishin release..."
LATEST_RELEASE=$(curl -s https://api.github.com/repos/jeffvli/feishin/releases/latest | grep "browser_download_url.*deb" | cut -d : -f 2,3 | tr -d \")
wget -O feishin.deb $LATEST_RELEASE

# Install Feishin and its dependencies
echo "Installing Feishin..."
sudo apt install -y ./feishin.deb

# Clean up downloaded files
rm feishin.deb

# Create desktop shortcut
cat > ~/.local/share/applications/feishin.desktop << EOL
[Desktop Entry]
Name=Feishin
Exec=/usr/bin/feishin
Icon=feishin
Type=Application
Categories=AudioVideo;Audio;Player;
Comment=Modern music streaming client
EOL

echo "Installation complete! You can now launch Feishin from your applications menu"
echo "or run 'feishin' in the terminal."
