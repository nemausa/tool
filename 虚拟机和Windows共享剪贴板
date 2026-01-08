# 🖥️ VMware Workstation 17.5.1 + Ubuntu 22.04

## Windows ↔ Ubuntu 剪贴板无法共享（完整排查 & 解决指南）

---

## ✅ 结论速览（先看这个）

> **VMware 剪贴板共享 = 必须满足以下条件：**

* ✅ Ubuntu **运行在图形桌面**
* ✅ 会话类型是 **X11**
* ✅ 已安装 **open-vm-tools-desktop**
* ❌ **Wayland 会导致剪贴板失效**
* ❌ **tty（纯终端）下永远不可能共享**

---

## 1️⃣ 当前会话类型判断（第一步必查）

```bash
echo $XDG_SESSION_TYPE
```

### 结果含义

| 输出        | 含义         | 剪贴板     |
| --------- | ---------- | ------- |
| `tty`     | 无图形桌面      | ❌ 不可能   |
| `wayland` | Wayland 会话 | ❌ 高概率失效 |
| `x11`     | X11 会话     | ✅ 正常    |

> **VMware + Ubuntu 22.04：唯一稳定的是 `x11`**

---

## 2️⃣ 如果是 `tty`（必须先装桌面）

### 判断是否有桌面环境

```bash
dpkg -l | grep ubuntu-desktop
```

如果 **没有输出**，说明你当前是：

* Ubuntu Server / Minimal
* 没有 GUI
* 剪贴板不可能共享

### 安装桌面（推荐完整版）

```bash
sudo apt update
sudo apt install -y ubuntu-desktop
sudo reboot
```

---

## 3️⃣ 如果是 `wayland`（这是最常见问题）

### ❌ Wayland 是问题根源

Ubuntu 22.04 默认启用 Wayland
VMware Tools 对 Wayland 剪贴板支持 **不完整**

### ✅ 永久切换到 X11（强烈推荐）

#### 编辑 GDM 配置

```bash
sudo nano /etc/gdm3/custom.conf
```

确保内容为：

```ini
WaylandEnable=false
```

> ⚠️ 注意：
>
> * 前面的 `#` 必须去掉
> * 必须是 `false`

#### 重启

```bash
sudo reboot
```

#### 重启后确认

```bash
echo $XDG_SESSION_TYPE
```

✅ **必须输出：**

```text
x11
```

---

## 4️⃣ 安装 & 校验 VMware Tools（关键组件）

### 必须安装的包

```bash
sudo apt update
sudo apt install -y open-vm-tools open-vm-tools-desktop
```

> ❗ **没有 `open-vm-tools-desktop` = 剪贴板无效**

### 检查服务状态

```bash
systemctl status vmtoolsd
```

应看到：

```text
Active: active (running)
```

如未运行：

```bash
sudo systemctl enable vmtoolsd
sudo systemctl restart vmtoolsd
```

---

## 5️⃣ Windows 宿主机侧设置（容易忽略）

在 **VMware Workstation（Windows）**：

1. **关闭虚拟机**
2. `VM Settings` → `Options` → `Guest Isolation`
3. 勾选：

   * ✅ Enable copy and paste
   * ✅ Enable drag and drop
4. 启动虚拟机

---

## 6️⃣ 快速自检清单（1 分钟对完）

在 Ubuntu 里逐条确认：

```bash
echo $XDG_SESSION_TYPE        # 必须是 x11
dpkg -l | grep open-vm-tools # 必须有 desktop
systemctl status vmtoolsd    # 必须 running
```

在 Windows VMware 里：

* Guest Isolation 两项已勾选

---

## 7️⃣ 常见误区总结（踩一次就够）

| 误区                | 实际情况             |
| ----------------- | ---------------- |
| “我进 Ubuntu 了”     | tty ≠ 桌面         |
| “装了 vmtools 还不行”  | 少了 desktop 包     |
| “Wayland 是新技术更好”  | VMware 下不稳定      |
| “这是 VMware 的 bug” | 是 Wayland + 协议限制 |

---

## 8️⃣ 最终推荐稳定组合（实战结论）

```text
VMware Workstation 17.5.1
Ubuntu 22.04
X11 (禁用 Wayland)
open-vm-tools + open-vm-tools-desktop
```

> **这个组合下：剪贴板 100% 正常**

---

## 9️⃣ 一句话口诀（下次直接想起）

> **剪贴板不通 → 先看 `$XDG_SESSION_TYPE`**
> `tty` → 装桌面
> `wayland` → 切 X11
> `x11` → 查 vmtools
