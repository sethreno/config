# this is meant to be run from /home/seth

# install necessities
sudo apt install vim -y
sudo apt install vim-gtk -y

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim


## dotnet
wget https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-5.0

export DOTNET_CLI_TELEMETRY_OPTOUT=true


## vscode
wget https://go.microsoft.com/fwlink/?LinkID=760868 -O vscode.deb
sudo apt install ./vscode.deb

sudo apt install docker.io -y
sudo apt install postgresql postgresql-contrib -y

sudo -u postgres createuser seth
sudo -u postgres createdb seth
sudo -u postgres psql -c 'alter user seth with encrypted password \'seth\';' # '
sudo -u postgres psql -c 'alter user seth with superuser;'

# preferred browser
# sudo apt install chromium-browser -y

# preferred shell
sudo apt-add-repository ppa:fish-shell/release-3 -y
sudo apt-get update -y
sudo apt-get install fish -y

# nerd font
# install DroidSansMono Nerd Font --> u can choose another at: https://www.nerdfonts.com/font-downloads
echo "[-] Download fonts [-]"
echo "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DroidSansMono.zip"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DroidSansMono.zip
unzip DroidSansMono.zip -d ~/.fonts
fc-cache -fv


curl -fsSL https://starship.rs/install.sh | bash
mkdir ./config/fish
echo 'starship init fish | source' >> .config/fish/config.fish

# configure everything
echo '' >> .vimrc
echo ':set clipboard=unnamedplus' >> .vimrc

chsh -s `which fish`

echo '' >> .config/fish/config.fish
echo 'fish_vi_key_bindings' >> .config/fish/config.fish
echo '' >> .config/fish/config.fish

echo '' >> .bashrc
echo '# enable vi keybindings in bash' >> .bashrc
echo 'set -o vi' >> .bashrc
echo 'keymap vi' >> .bashrc
echo '' >> .bashrc

git config --global user.name "Seth Reno"
git config --global user.email "sethreno@gmail.com"
git config --global credential.helper store

export VISUAL=vim
export EDITOR="$VISUAL"

# do manual stuff
# * turn on sync in chromium
# * turn on sync in code
# * run BundleInstall in vim
# * select nerd font in terminal
# * log out / back in for default fish shell


