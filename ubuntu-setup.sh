# preconfigured i3 window manager
sudo add-apt-repository ppa:regolith-linux/release -y
sudo apt install regolith-desktop-mobile -y

# install necessities
sudo apt install vim -y
sudo apt install vim-gtk -y
sudo apt install curl -y
sudo apt install git -y
sudo snap install --classic code
sudo snap install dotnet-sdk --classic --channel=3.1
sudo snap alias dotnet-sdk.dotnet dotnet
sudo apt install docker.io -y
sudo apt install postgresql postgresql-contrib -y

sudo -u postgres createuser seth
sudo -u postgres createdb seth
sudo -u postgres psql -c 'alter user seth with encrypted password \'seth\';'
sudo -u postgres psql -c 'alter user seth with superuser;'

# preferred browser
sudo apt install chromium-browser -y

# preferred shell
sudo apt-add-repository ppa:fish-shell/release-3 -y
sudo apt-get update -y
sudo apt-get install fish -y

curl -fsSL https://starship.rs/install.sh | bash
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

sudo update-alternatives --config x-www-browser

# do manual stuff
# * reboot & select regolith
# * turn on sync in chromium
# * turn on sync in code
