# homebrew-mytap

个人自维护的 [Homebrew](https://brew.sh) tap。

## 使用方式

```bash
# 添加 tap
brew tap orkady/mytap

# 查看本 tap 收录的软件
brew search --cask orkady/mytap

# 安装
brew install --cask orkady/mytap/ocs-desktop
```

## 收录内容

| Cask | 说明 | 平台 |
|---|---|---|
| [ocs-desktop](Casks/ocs-desktop.rb) | OCS 网课助手桌面客户端，浏览器多开与用户脚本环境一键配置 | macOS (Apple Silicon) |

## 说明

- 本 tap 仅支持 Apple Silicon。
- `ocs-desktop` 依赖 GitHub Releases 作为分发源，版本更新由 `livecheck` 自动检测。

## License

本仓库的代码与元数据以 [BSD-2-Clause](LICENSE) 发布。
收录的第三方软件版权归各自作者所有，本 tap 仅提供安装方式，不分发任何二进制内容。
