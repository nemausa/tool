#bash

sudo apt install curl
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs
node -v
npm -v

sudo apt install clangd
git clone git@github.com:Nemausa/neovim-config.git ~/.config/nvim && nvim


TSInstall all
CocInstall coc-clangd
CocInstall coc-snippets
