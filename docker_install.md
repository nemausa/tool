以下是在 Ubuntu 上安装 Docker 的步骤，格式化为 Markdown，适用于 Ubuntu 20.04、22.04 或 24.04 等版本，基于官方推荐方法，并包含之前提到的错误处理建议。

```markdown
# 在 Ubuntu 上安装 Docker

以下是在 Ubuntu 系统上安装 Docker 的详细步骤，适用于 Ubuntu 20.04、22.04 或 24.04。

## 前提条件
- 确保系统为 64 位，Docker 不支持 32 位系统。
- 确保有 sudo 权限。
- 检查 Ubuntu 版本：
  ```bash
  lsb_release -a
  ```

## 安装步骤

### 1. 更新系统包索引
```bash
sudo apt update
sudo apt upgrade -y
```

### 2. 安装必要的依赖
```bash
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
```

### 3. 添加 Docker 的官方 GPG 密钥
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

### 4. 添加 Docker 的 APT 源
```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

### 5. 再次更新包索引并安装 Docker
```bash
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
```

### 6. 验证 Docker 安装
```bash
sudo docker --version
sudo docker run hello-world
```
> **提示**：`docker run hello-world` 会拉取一个测试镜像并运行，验证安装是否成功。

### 7. （可选）设置非 root 用户运行 Docker
默认情况下，Docker 需 root 权限。为避免每次使用 `sudo`，将当前用户添加到 `docker` 组：
```bash
sudo usermod -aG docker $USER
newgrp docker
```
注销并重新登录以生效。

### 8. （可选）设置 Docker 开机自启
```bash
sudo systemctl enable docker
sudo systemctl start docker
```