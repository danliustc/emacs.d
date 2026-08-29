# 配套软件

这套配置还依赖 beorg、同步服务和少量命令行工具。它们不由 Emacs 包管理器维护。

## 环境检查

运行：

```text
M-x my/check-environment
```

该命令检查：

- Emacs 版本
- 本地命令行工具
- Org 目录访问权限
- 必需的 Org 文件
- beorg 的 `init.org`
- 实际配置与仓库样例的差异
- 可能的 Dropbox 冲突副本

检查过程是只读的，不会安装工具、复制文件或修改同步设置。

它无法证明 Dropbox 已经完成同步，也无法从手机读取 beorg 版本和设置。

## beorg 设置

beorg 可以在 iPhone 和 iPad 上读取普通 Org 文件。仓库中的配置样例是
`beorg-init.sample.org`。

使用方法：

1. 先阅读样例。
2. 将它复制到 `my/org-dir`，文件名必须是小写的 `init.org`。
3. 如果已经存在 `init.org`，先比较差异，不要直接覆盖。
4. 在 beorg 中重新加载配置。

可以完全关闭并重新打开 beorg，也可以在 beorg REPL 中运行：

```scheme
(load 'init)
```

`init.org` 管理状态、日志、过滤器、编辑器工具栏和启动页面。仓库样例中的搜索
语法需要 beorg 3.39.0 或更高版本。

以下内容仍然需要在 App 界面中设置：

- Dropbox 账号
- 同步目录
- 同步权限
- 两个捕获模板
- 默认模板

长按 Agenda、Tasks 或 Files 页面底部的 `+`，选择 `Manage Templates…`：

| 模板 | Save To | State | 用途 |
| --- | --- | --- | --- |
| ✅ 任务 | `tasks.org` | `TODO` | 设为默认模板 |
| 💭 想法 | `ideas.org` | 不设置 | 创建普通标题 |

两个模板都使用默认行为，将条目追加到文件末尾。模板由 App 管理，不在
`init.org` 中使用 `item-templates` 维护。这样可以使用 beorg 当前文档支持的模板
界面，也能避免依赖没有完整公开说明的模板字符串格式。

不要在本仓库保存 Dropbox 凭据。

## beorg 修改后的检查

在手机上完成以下短测试：

1. 确认 beorg 版本不低于 3.39.0。
2. 同步并确认可以看到 `tasks.org` 和 `ideas.org`。
3. 在 REPL 运行 `(load 'init)`，确认没有错误。
4. 创建一个任务，确认它以 `TODO` 状态进入 `tasks.org`。
5. 创建一个想法，确认它进入 `ideas.org` 且没有 TODO 状态。
6. 完成一个重复任务，确认它恢复为 `TODO`。
7. 确认状态记录位于 `LOGBOOK` 中。
8. 确认 Tasks 只显示 `TODO` 和 `WAITING`，并按状态分组、按优先级排序。
9. 确认 Tasks 不显示 `init.org` 和 `archive.org`。

beorg 更新前后，应将样例与当前官方的
[脚本指南](https://www.beorgapp.com/manual/scripting/)、
[library.org 参考](https://www.beorgapp.com/manual/library-org/)、
[搜索指南](https://www.beorgapp.com/manual/search/)、
[模板指南](https://www.beorgapp.com/manual/templates/)和
[同步指南](https://www.beorgapp.com/manual/sync/)进行核对。

官网展示的 `library.org` 可能与手机中安装的版本不同。需要确认实际变量时，在
beorg REPL 中点击帮助图标，查看 App 自带的 `library.org`。

## Dropbox

`my/org-dir` 必须指向 beorg 同步的同一个目录。

新版 Dropbox 在 macOS 上通常使用：

```text
~/Library/CloudStorage/Dropbox/orgfiles
```

旧版可能使用：

```text
~/Dropbox/orgfiles
```

目录存在不代表同步正常。第一次设置时，应创建一个小测试条目，并在两个设备上确认。

出现冲突副本时：

1. 停止在两台设备上继续编辑。
2. 保留两份文件。
3. 比较发生变化的标题。
4. 合并需要保留的内容。
5. 等合并后的文件完成同步，再删除多余副本。

## Homebrew 工具

系统级 Brewfile 是系统软件的唯一来源。本仓库不再增加第二份 Brewfile。

| 工具 | 重要程度 | 缺失时的行为 |
| --- | --- | --- |
| Emacs 30+ | 必需 | 无法运行 |
| `rg` | 推荐 | 回退到 Emacs `rgrep` |
| `pandoc` | 可选 | 仍可编辑 Markdown |
| `aspell` 或 `ispell` | 可选 | 不启用拼写检查 |
| JetBrains Mono | 可选 | 回退到 SF Mono，再到 Menlo |

本仓库只报告缺少的工具，不会运行 `brew install` 或 `brew upgrade`。
