# Git 配置与仓库清理

## 1. 永久保存凭证
默认情况下，Git 会把输入的用户名和密码写入磁盘：
```bash
git config --global credential.helper store
```

---

## 2. 删除大于 50 MB 的文件

1. 更新软件包并安装依赖：

   ```bash
   sudo apt update
   sudo apt install git-lfs
   git lfs install
   sudo apt install -y python3-pip
   pip3 install --user git-filter-repo
   ```
2. 确保 `~/.local/bin` 已经在 PATH 中：

   ```bash
   export PATH=$PATH:$HOME/.local/bin
   ```
3. 删除所有超过 50 MB 的大文件：

   ```bash
   git filter-repo --strip-blobs-bigger-than 50M --force
   ```

---

## 3. 保持非 ASCII 文件名可读

默认情况下，Git 会把非 ASCII 文件名转义为 `\uXXXX`。可以通过以下命令关闭：

```bash
git config --system core.quotepath false
```

---

## 4. 使用 UTF-8 编码提交信息和日志

确保 Git 输入/输出使用 UTF-8：

```bash
export LESSCHARSET=utf-8
git config --global i18n.commitEncoding utf-8
git config --global i18n.logOutputEncoding utf-8
```

---

## 5. 常用 Git 查询

* **按作者搜索提交**

  ```bash
  git log --all --author="xxx"
  ```

* **查找包含某个提交的分支**

  ```bash
  git branch --contains <commit-id>
  ```

---

## 6. 在远程分支中按作者搜索提交

1. 抓取所有远程分支：

   ```bash
   git fetch --all
   ```

2. 在所有远程分支中搜索某个作者的提交：

   ```bash
   git log --remotes --author="用户名"
   ```

3. 精简输出（仅显示提交哈希和信息）：

   ```bash
   git log --remotes --author="用户名" --oneline
   ```

4. 仅查看某个远程分支的提交：

   ```bash
   git log origin/dev --author="用户名" --oneline
   ```
