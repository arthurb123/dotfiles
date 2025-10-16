#!/usr/bin/env bash
set -e  # Exit immediately on error

echo "=== Dotfiles setup started ==="

# Check for yay first
if ! command -v yay &>/dev/null; then
  echo "Oops! Yay is not installed. Please install yay first (e.g. 'sudo pacman -S yay')."
  exit 1
fi

# Ask about package installation
read -p "Do you want to install required packages? (y/n): " install_packages

if [[ "$install_packages" =~ ^[Yy]$ ]]; then
  echo "Installing required packages with yay..."
  packages=(
    hyprland
    waybar
    mpvpaper
    rofi
    dunst
    kitty
    neovim
    neovide
    nautilus
    zsh
    git
    network-manager-applet
    volumeicon
    polkit-gnome
    swayidle
    swaylock
    xbindkeys
    pavucontrol
    bluez
    bluez-utils
    brightnessctl
    grim
    slurp
    wl-clipboard
    wdisplays
    fcitx5
    sddm
    nvm
  )

  for pkg in "${packages[@]}"; do
    echo "Installing $pkg..."
    yay -S --needed --noconfirm "$pkg"
  done

  echo "Package installation complete."
else
  echo "Skipping package installation."
fi

echo "Setting up dotfiles..."

# Make sure important dirs exist
mkdir -p ~/.config

# Move files with overwrite confirmation
read -p "This will MOVE files and overwrite existing ones. Continue? (y/n): " confirm_move
if [[ "$confirm_move" =~ ^[Yy]$ ]]; then
  mv -f ./home/* ~/ 2>/dev/null || true
  mv -f ./config/* ~/.config/ 2>/dev/null || true
  sudo mv -f ./etc/* /etc/ 2>/dev/null || true
  sudo mv -f ./usr/* /usr/ 2>/dev/null || true
  echo "Files moved successfully."
else
  echo "Aborted moving files."
fi

# --- OH MY ZSH + POWERLEVEL10K ---
read -p "Do you want to install Oh My Zsh and Powerlevel10k? (y/n): " install_zsh
if [[ "$install_zsh" =~ ^[Yy]$ ]]; then
  echo "Installing Oh My Zsh..."
  if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh already installed. Skipping..."
  else
    # Install Oh My Zsh (without switching shell automatically)
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  echo "Installing Powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k || true

  echo "Installing Zsh plugins..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || true
  git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions || true

  echo "Copying .zshrc configuration..."
  cp -f ./zshrc ~/.zshrc

  echo "Setting Zsh as default shell..."
  chsh -s /usr/bin/zsh

  echo "Oh My Zsh and Powerlevel10k setup complete."
else
  echo "Skipping Oh My Zsh setup."
fi

echo "=== Dotfiles setup complete ==="