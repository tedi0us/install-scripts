#!/bin/bash

# Create fonts directory if it doesn't exist
mkdir -p ~/.local/share/fonts

# Create a temporary directory for downloads
mkdir -p ~/nerd-fonts-tmp
cd ~/nerd-fonts-tmp

# Download and install all Nerd Fonts
echo "Downloading and installing Nerd Fonts..."

# List of popular Nerd Fonts - add or remove as needed
FONTS=(
    "JetBrainsMono"
    "Hack"
    "FiraCode"
    "DroidSansMono"
    "CascadiaCode"
    "SourceCodePro"
    "UbuntuMono"
    "RobotoMono"
    "Meslo"
    "Inconsolata"
)

for font in "${FONTS[@]}"; do
    echo "Downloading $font..."
    wget -q --show-progress "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.zip"
    unzip -q "${font}.zip" -d "$font"
    
    # Copy fonts to user fonts directory
    cp "$font"/*.ttf ~/.local/share/fonts/ 2>/dev/null || true
    cp "$font"/*.otf ~/.local/share/fonts/ 2>/dev/null || true
    
    # Cleanup downloaded files
    rm -rf "$font" "${font}.zip"
done

# Update font cache
fc-cache -fv

# Clean up temporary directory
cd ~
rm -rf ~/nerd-fonts-tmp

# Create or update .Xresources for terminal font configuration
cat > ~/.Xresources << EOL
! Terminal font configuration
URxvt.font: xft:JetBrainsMono Nerd Font:size=11
URxvt.boldFont: xft:JetBrainsMono Nerd Font:bold:size=11
URxvt.italicFont: xft:JetBrainsMono Nerd Font:italic:size=11
URxvt.boldItalicFont: xft:JetBrainsMono Nerd Font:bold:italic:size=11
EOL

# Merge .Xresources
xrdb -merge ~/.Xresources

# If using GNOME Terminal, set the font
if command -v gsettings &> /dev/null; then
    profile=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
    gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" font 'JetBrainsMono Nerd Font 11'
fi

# Create a test file to verify font installation
cat > ~/test-fonts.sh << 'EOL'
#!/bin/bash
echo "Testing Nerd Font Icons:"
echo -e "\uf121 \ue7c5 \uf7db \uf681 \uf01b \uf268 \uf865 \uf02d \uf0e7 \uf15c"
echo ""
echo "If you see boxes or missing characters above, the font isn't working correctly."
EOL
chmod +x ~/test-fonts.sh

echo "Installation complete! To test the fonts, run: ~/test-fonts.sh"
echo "Please configure your terminal to use JetBrainsMono Nerd Font"
echo ""
echo "For most terminals, you can set the font in the terminal preferences."
echo "Recommended font settings:"
echo "Font: JetBrainsMono Nerd Font"
echo "Size: 11"
echo "Style: Regular"
