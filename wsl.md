## 方法 : 使用 X 服务器

如果你在使用 Windows 10，或者想要更多的控制，可以使用 X 服务器（如 Xming 或 VcXsrv）来显示 GUI。

### 步骤:

1. **安装 X 服务器**:
   - 下载并安装 [Xming](https://sourceforge.net/projects/xming/) 或 [VcXsrv](https://sourceforge.net/projects/vcxsrv/).

2. **配置 X 服务器**:
   - 启动 X 服务器并确保它可以接受来自 localhost 的连接（通常是默认设置）。
   - 如果使用 VcXsrv，启动时选择“Disable access control”选项，以允许所有客户端连接。

3. **设置 DISPLAY 环境变量**:
   在 WSL 中，运行以下命令：
   - 如果你使用的是 VcXsrv，通常可以将 DISPLAY 设置为：
   ```bash
   export DISPLAY=localhost:0
   ```
   - 如果你使用的是 Xming，可以尝试：
   ```bash
   export DISPLAY=$(ip route | grep default | awk '{print $3}'):0
   ```
