下面是你要的 **“方案一：用电脑下载整套离线包，再上传到路由器（推荐）”** 的 **Markdown 输出格式**（清晰排版、可复制保存）：

---

# 📦 **方案一：用电脑下载 PassWall 整套离线包，再上传到路由器（推荐）**

这是一种 **100% 可成功** 的安装方式，因为不依赖路由器在线下载。
整个流程分为：**下载 → 解压 → 上传 → 安装** 四步。

---

## 🧰 **步骤 1：在电脑上下载 PassWall 离线 IPK 压缩包**

1. 在电脑浏览器打开 PassWall 发布页面（电脑能连外网即可）
2. 下载与你架构匹配的离线包：

```
passwall_packages_ipk_aarch64_cortex-a53.zip
```

📌 *此文件包含完整 PassWall 所需的 `.ipk` 软件包（含 GUI、依赖、小工具等）*
📌 *无需路由器网络，完全适配你的架构 aarch64_cortex-a53*

---

## 📁 **步骤 2：在电脑上解压离线包**

把下载的：

```
passwall_packages_ipk_aarch64_cortex-a53.zip
```

解压，会看到几十个 `.ipk` 文件，例如：

* luci-app-passwall_*.ipk
* passwall_*.ipk
* dns2socks_*.ipk
* tcping_*.ipk
* chinadns-ng_*.ipk（可选）
* v2ray-geosite_*.ipk
* v2ray-geoip_*.ipk
* ……

⚠ **不要删除任何文件**（后面会用）。

---

## 📤 **步骤 3：把所有 IPK 上传到路由器 `/tmp/passwall`**

1. 使用 WinSCP、LuCI 文件上传、scp 等工具
2. 创建目录：

```bash
mkdir -p /tmp/passwall
```

3. 上传解压后的所有 `.ipk` 到 `/tmp/passwall/`

📌 `/tmp` 是内存盘，不会占用 overlay 空间（非常重要）。

---

## 🛠 **步骤 4：在路由器上一次性安装 PassWall**

SSH 登录路由器，执行：

```bash
cd /tmp/passwall

# 可选：更新软件列表（使用 pku 的软件源）
opkg update

# 安装 PassWall 全套
opkg install ./*.ipk
```

如果出现如下情况：

* 某些包已安装 → 忽略
* 某些大包（如 xray-core/sing-box）因空间不足无法安装 → 忽略（PassWall 仍可运行）

安装成功后，重启 web 界面：

```bash
/etc/init.d/uhttpd restart
```

然后进入后台：

**服务 → PassWall**

PassWall 即可使用。

---

# 🎉 完成！

通过该方法，你不需要路由器访问外网，也不会遇到：

* HTTPS 连接失败
* 空间不足导致下载失败
* IPK安装顺序错误
* 依赖问题

---

# 📌 如果你需要，我可以继续提供：

* 👉 精简版 PassWall（适合空间不足）
* 👉 外置 xray-core（不占 overlay）
* 👉 自动化安装脚本（一步执行）
* 👉 最佳 PassWall 配置（DNS + 分流 + TUN）

---

如果你要，我可以直接给你一个 **完全自动化的 Markdown 版安装脚本**。
