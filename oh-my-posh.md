# 在 Windows 上安装 Oh My Posh

## 1. 安装 PowerShell

确保你的系统上安装了 PowerShell。你可以在 Windows 10 或更高版本中找到它，通常预装了。

## 2. 安装 Oh My Posh

1. **打开 PowerShell**：
   - 以管理员身份运行 PowerShell。

2. **安装 Oh My Posh**：
   运行以下命令来安装 Oh My Posh：

   ```powershell
   Install-Module oh-my-posh -Scope CurrentUser
   Install-Module oh-my-posh -Scope CurrentUser -Force
   ```

## 3. 加载 Oh My Posh： 

1. 要在每次启动 PowerShell 时加载 Oh My Posh，可以在你的 PowerShell 配置文件中添加以下行

   ```powershell
   oh-my-posh init pwsh | Invoke-Expression
   ```
2. 如果你还没有配置文件，可以使用以下命令创建一个：
   ```
   New-Item -Path $PROFILE -ItemType File -Force
   ```

## 4. 选择主题

1. Oh My Posh 提供多种主题。你可以通过运行以下命令来查看可用主题：
   ```
   Get-PoshThemes
   ```

2. 要设置主题，请在你的配置文件中添加：
   ```powershell
   Set-PoshPrompt -Theme aliens 
   ```