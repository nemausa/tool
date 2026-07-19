Mac nvim 长按响应慢
# 关闭按住弹菜单，改为直接重复字符
defaults write -g ApplePressAndHoldEnabled -bool false

# 重复速率，数值越小越快（推荐 2~3）
defaults write NSGlobalDomain KeyRepeat -int 2
# 首次重复前延迟，数值越小延迟越短（推荐 15~20）
defaults write NSGlobalDomain InitialKeyRepeat -int 15
