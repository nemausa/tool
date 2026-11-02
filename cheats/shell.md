# Shell 命令速查

## 查看命令速查表

```sh
cheats          # 默认查看 shell.md
cheats git      # Git 命令
cheats nvim     # nvim 操作
```

新终端自动加载 cheats 函数；当前终端先执行一次：

```sh
source ~/.zshrc
```

也可以直接查看文件：

```sh
less ~/tools/cheats/git.md
```

less：方向键滚动，空格翻页，`/关键词` 然后回车搜索，`n` 下一个，`N` 上一个，`q` 退出。
Markdown 以纯文本显示。

## 编辑和新增速查表

```sh
nvim ~/tools/cheats/git.md
nvim ~/tools/cheats/build.md
```

按主题新增 `.md` 文件即可，例如保存 build.md 后可用 `cheats build` 查看。
不在速查表中保存密码或令牌。

## 搜索执行过的命令

按 Ctrl+r，输入命令片段，例如 `lazygit`；继续按 Ctrl+r 查找更早的匹配项。
回车执行选中的命令，Ctrl+c 取消。
