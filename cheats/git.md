# Git 命令速查

在 Git 项目目录下执行。左右对比时尽量拉宽终端。

## Lazygit：选择文件，左右对比修改

```sh
DELTA_FEATURES=+side-by-side lazygit
```

在文件列表用方向键选择文件，查看差异；按 `q` 退出。

## 查看修改文件列表

```sh
git status -sb
```

## 查看未暂存修改，左右对比

```sh
git --no-pager diff --color=always | delta --side-by-side
```

## 查看已暂存修改，左右对比

```sh
git --no-pager diff --cached --color=always | delta --side-by-side
```

## 只查看指定文件

将 `path/to/file.cpp` 换成实际文件路径。

```sh
git --no-pager diff --color=always -- path/to/file.cpp | delta --side-by-side
```

`git diff` 不显示未跟踪的新文件内容；先用 `git status -sb` 确认文件状态。
delta 进入分页器后，按 `q` 退出。
