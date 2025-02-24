sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt-get update
sudo apt install -y git
git --version
sudo apt install -y zsh
zsh --version
chsh -s $(which zsh)
echo $SHELL

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --recursive https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/themes/powerlevel10k
sudo apt install -y autojump
# 替换主题
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# 启用插件 (git + zsh-autosuggestions + zsh-syntax-highlighting + autojump)
sed -i 's/^plugins=(.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting autojump)/' ~/.zshrc

sudo apt-get install -y python3 python3-pip
pip3 install --user pynvim

sudo apt install -y clangd make cmake 
curl -fsSL https://deb.nodesource.com/setup_23.x | sudo -E bash -
sudo apt-get install -y nodejs
node -v
npm -v
sudo apt-get install -y neovim
nvim --version

rm -rf ~/.config/nvim
git clone https://github.com/nemausa/nvimrc.git ~/.config/nvim && nvim
