#!/usr/bin/env bash

set -e

cd "$(dirname "${BASH_SOURCE}")";

CWD=$(pwd)

function doIt() {
  find . \
       -maxdepth 1 \
         \! \( -name ".git" \
               -or -name "emacs" \
               -or -name "install.sh" \
               -or -name "." \
               -or -name ".#*" \) \
        -execdir ln -sf "$CWD/{}" "$HOME/{}" \;
  mkdir -p ~/.config/nvim
  ln -s "$CWD/.vimrc" "$HOME/.config/nvim/init.vim"
  ln -s "$CWD/.vimrc" "$HOME/.vim/init.vim"
  mkdir -p ~/bin;
  mkdir -p ~/src;
  source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
  doIt;
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
  echo "";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    doIt;
    git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
  fi;
fi;
unset doIt;

echo "Your dotfiles have been synchronized!"

# Install tmux plugins
echo "Installing tmux plugins.."
sudo pip install powerline-status
mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

read -p "Install XCode Command Line Tools? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Running installer.."
  xcode-select --install
fi;

read -p "Install Homebrew packages? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sudo xcodebuild -license
  echo "Running homebrew..."
  . Brewfile
fi;

#echo "Fetching iTerm2 color schemes..."
#git clone https://github.com/mbadolato/iTerm2-Color-Schemes ~/src/iTerm2-Color-Schemes

echo "Installing version manager..."
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.2.0
source ~/.asdf/asdf.sh

echo "Adding Erlang, Elixir, Go plugins"
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf plugin-add golang https://github.com/kennyp/asdf-golang.git

echo ""
echo "All done!"
