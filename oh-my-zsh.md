# 要在 Oh My Zsh 中启用智能提示功能，请按照以下步骤操作：
- Install oh-my-zsh
    ```
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ```
- Install zsh-autosuggestions plugin
    ```
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    ```

- Install zsh-syntax-highlighting plugin
    ```
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    ```
-In ~/.zshrc plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

- Install p10k
  ```
  git clone --recursive https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/themes/powerlevel10k
  ```
  ZSH_THEME="powerlevel10k/powerlevel10k"
