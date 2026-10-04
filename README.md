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

# 升级（tap 已添加后，brew 会自动发现本 tap 的新版本）
brew upgrade ocs-desktop
```

> 首次使用需本机已配置 GitHub SSH key。仓库 remote 请用 SSH 地址
> （`git@github.com:Orkady/homebrew-mytap.git`），这样 `brew update`
> 才能免密拉取本 tap 的最新 cask 定义。

## 收录内容

| Cask | 说明 | 分发源 | 平台 |
|---|---|---|---|
| [ocs-desktop](Casks/ocs-desktop.rb) | OCS 网课助手桌面客户端 | GitHub Releases | macOS (Apple Silicon) |
| [hover-translate](Casks/hover-translate.rb) | 悬停取词翻译工具 | 阿里云 OSS + Sparkle | macOS 14+ |

### 两种分发模式的差异

本 tap 收录的两个 cask 恰好代表了两类分发方式，编写方式不同：

| | ocs-desktop | hover-translate |
|---|---|---|
| 有 GitHub 仓库 | ✅ | ❌ 仅官网 |
| `livecheck` 策略 | `:github_latest` | `:sparkle` |
| 版本来源 | GitHub Releases API | `appcast.xml` |
| 代码签名 | adhoc，未公证（签名损坏） | Developer ID，**已公证** |
| 需要 `xattr` 绕过 | ✅ 需要 | ❌ 不需要 |

**没有 GitHub 仓库的 cask 一样可以写**，只要满足两点：能拿到稳定的下载 URL，
以及能找到版本信息源（如 Sparkle appcast、更新页、或自行写 livecheck 规则）。
`hover-translate` 就是用第 2 条的 `:sparkle` 策略解决版本检测的。

---

## 如何检查与处理软件更新

Homebrew 把「检测更新」和「应用更新」分成两步，两者都由工具完成，
**不需要手动去网上找版本号**。

### 整体机制

```
① 上游发布新版 (如 v2.13.0)
        ↓
② brew livecheck      ← 自动抓取，比对版本号，告诉你「有新版」
        ↓
③ 改 Casks/ocs-desktop.rb   ← 只有这一步需要人工
   更新 version 和 sha256
        ↓
④ git push           ← 发布，你本机 brew upgrade 即可装到新版
        ↓
⑤ 其他人的 brew update + brew upgrade 生效
```

### 第一步：检测（完全自动）

```bash
# 代理环境下先执行（brew 的联网命令走 Ruby，不继承系统代理）
export http_proxy=http://127.0.0.1:7890 https_proxy=http://127.0.0.1:7890 all_proxy=http://127.0.0.1:7890

# 查本 tap 收录的软件有没有新版
brew livecheck --cask orkady/mytap/ocs-desktop

# 顺带看看本机已安装的哪些过期了（含第三方 tap）
brew outdated --cask
```

`livecheck` 的输出有三种：

| 输出 | 含义 | 要做什么 |
|---|---|---|
| `2.12.0 ==> 2.12.0` | 无新版 | 不用管 |
| `2.12.0 ==> 2.13.0` | 有新版 | 走下面的流程 |
| `Error: ... Unable to get versions` | 检测失败 | 见下方「排错」 |

这套检测靠 cask 里的 `livecheck` 块驱动，它已经配好：

```ruby
livecheck do
  url "https://github.com/ocsjs/ocs-desktop/releases/latest"
  strategy :github_latest
end
```

> 注意这里必须填 **GitHub 网页地址**，不能填 `api.github.com` 的 API 地址。
> `github_latest` 策略内部会自己转成 API 调用，填 API 地址反而会匹配失败。
> 这个 URL 是随上游从 `darwin` 改名为 `mac` 之后同步调整过的。

### 第二步：改 cask（需要人工，这一步无法自动化）

需要改两个字段：

```ruby
cask "ocs-desktop" do
  version "2.13.0"          # ← 改成新版本号（注意上游有无 v 前缀）
  sha256 "新的校验和"       # ← 必须重新计算
  # ...
end
```

#### 计算 sha256

```bash
cd /tmp
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890

# 下到临时目录，别污染仓库
curl -L -o ocs.dmg \
  "https://github.com/ocsjs/ocs-desktop/releases/download/v2.13.0/ocs-2.13.0-setup-mac-arm64.dmg"

# 校验值必须与 HTTP 头声明的字节数一致，再算 sha256
ls -l ocs.dmg
shasum -a 256 ocs.dmg

# 算完删掉（474MB 左右，务必执行）
rm ocs.dmg
```

对 `hover-translate` 这类 Sparkle 分发的应用，版本号和 URL 应以
appcast 为准，不要自己猜：

```bash
# 先看 appcast 里的最新版本与真实下载地址
curl -s "https://hover-translate.oss-cn-beijing.aliyuncs.com/appcast.xml" \
  | grep -E "shortVersionString|enclosure url" | head -4
```

**sha256 绝不能凭印象填写**。版本号写错 brew 会直接报错；
sha256 写错会导致安装时校验失败，或更糟——装上被篡改的文件。

### 第三步：本地验证（push 前必做）

```bash
cd ~/Projects/homebrew-mytap
export http_proxy=http://127.0.0.1:7890 https_proxy=http://127.0.0.1:7890

brew style Casks/ocs-desktop.rb                    # 代码风格，预期无输出
brew audit --strict --tap=orkady/mytap            # 规范审计，静默即通过
brew livecheck --cask orkady/mytap/ocs-desktop    # 预期 xxx ==> xxx
```

三条命令都必须通过再 push。

### 第四步：发布

```bash
cd ~/Projects/homebrew-mytap
git add Casks/ocs-desktop.rb
git commit -m "Update ocs-desktop to 2.13.0"
git push
```

推送后本机即可：

```bash
brew update                 # 拉取 tap 最新定义
brew upgrade ocs-desktop
```

### 关于自动化

GitHub 的 Dependabot **不支持** Homebrew tap（它只处理
GitHub Actions、npm、pip 等生态的依赖），所以本 tap 的版本更新
无法靠它生成 PR。

可行的半自动化方式是自己写 CI 定时跑 `brew livecheck`，
有新版就发 issue 或开 MR 提醒你。但**更新 `version` 与 `sha256`
这两步最终仍需人工确认**——因为还要核对上游是否改了发布格式
（文件名、架构后缀、DMG 变 ZIP 等），这些无法自动判断。

---

## 排错速查

| 报错 | 原因 | 解决 |
|---|---|---|
| `No available formula with the name "xxx"` | `brew audit` 漏了 `--tap=` | 用 `brew audit --strict --tap=orkady/mytap` |
| `Cask 'xxx' is unavailable` | tap 未添加，或 remote 不是 SSH | `brew tap orkady/mytap`；检查 `git remote -v` |
| `GithubLatest strategy does not apply to this URL` | livecheck 填成了 API 地址 | 改成 `https://github.com/OWNER/REPO/releases/latest` |
| `Unable to get versions` | 网络不通 | 先 export 代理变量 |
| `Permission to X.git denied to Y` | HTTPS 凭据权限不足 | 把 remote 改成 SSH 地址 |
| 输出里混大量 Ruby warning | brew 子命令的 stdout 噪声 | 加 `2>&1 \| grep -v "warning:"` |

---

## 说明

- 本 tap 仅支持 Apple Silicon（`ocs-desktop` 上游未提供 Intel 构建）。
- `ocs-desktop` 上游为 Electron 应用，使用 adhoc 签名且未公证。
  cask 中的 `xattr -cr` 只能清除 quarantine 属性，无法修复签名本身。
  若安装后双击无法启动，需到
  `系统设置 → 隐私与安全性` 点击「仍要打开」，这是上游应用的状态，
  不是本 cask 的缺陷。
- `zap trash` 清单基于 Electron 应用的标准路径推导。首次
  `brew uninstall --zap` 后建议核对实际残留并按需修正。

## License

本仓库的代码与元数据以 [BSD-2-Clause](LICENSE) 发布。
收录的第三方软件版权归各自作者所有，本 tap 仅提供安装方式，不分发任何二进制内容。
