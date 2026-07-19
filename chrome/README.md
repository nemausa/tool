# Firefox 启用自定义样式

## 1. 确认开关已经打开

地址栏输入：

```text
about:config
````

搜索：

```text
toolkit.legacyUserProfileCustomizations.stylesheets
```

将值设置为：

```text
true
```

---

## 2. 添加样式文件

地址栏输入：

```text
about:support
```

在页面中找到：

```text
Profile Folder / 配置文件夹
```

点击：

```text
Open Folder / 打开文件夹
```

也可以直接在地址栏输入：

```text
about:profiles
```

找到当前正在使用的配置：

```text
This is the profile in use and it cannot be deleted.
```

然后点击：

```text
Root Directory → Open Folder
```

---

## 3. 创建 chrome 文件夹

在打开的配置目录中，新建文件夹：

```text
chrome
```

目录示例：

```text
Firefox Profile/
└── chrome/
```

---

## 4. 放置 userChrome.css

在 `chrome` 文件夹中创建文件：

```text
userChrome.css
```

最终结构应为：

```text
Firefox Profile/
└── chrome/
    └── userChrome.css
```

Windows 示例路径：

```text
C:\Users\Nemausa\AppData\Roaming\Mozilla\Firefox\Profiles\qagctrl9.default-release\chrome\userChrome.css
```

---

## 5. 重启 Firefox

保存 `userChrome.css` 后，完全关闭并重新打开 Firefox，样式才会生效。

注意：Windows 里要打开“显示文件扩展名”，避免文件变成：

```text
userChrome.css.txt
```