# 维护指南

所有修改都应保持小而清晰，并且容易验证。

## Emacs 包

`lisp/my-packages.el` 中的 `my/packages` 是完整的第三方包清单。

安装缺少的包：

```text
M-x my/install-missing-packages
```

升级已安装的包：

```text
M-x my/upgrade-packages
```

执行任何一个命令后都要重启 Emacs。配置加载时会检查包是否存在。

只有在确认 `my/packages` 正确后，才清理未使用的包：

```text
M-x package-autoremove
```

启动过程不能刷新包仓库，也不能安装软件包。

## 增加或修改软件包

1. 在 `my/packages` 中增加或删除对应 symbol。
2. 将 `use-package` 配置放入负责该功能的模块。
3. 使用 `:ensure nil`。
4. 第三方包必须用 `package-installed-p` 保护。
5. leader 快捷键调用可选软件包时，必须提供降级路径。
6. 更新对应文档。
7. 运行测试。

不要为了一个很短的设置新建模块。应优先放入职责最接近的现有模块。

## 修改快捷键

所有自定义快捷键都放在 `lisp/my-keybindings.el`。

- 优先复用现有 leader 分组。
- 保持 leader 数量很小。
- 不要增加自定义的全局 `C-c` 快捷键。
- 同步更新 `KEYBINDINGS.md`。
- 增加或更新 ERT 按键查找测试。

## 修改 Org 行为

先阅读 `ORG-WORKFLOW.md`。Capture、Refile、重复任务或状态发生变化时，通常也要
更新 `beorg-init.sample.org`。

测试必须使用临时 Org 目录，绝不能指向真实 Dropbox 文件夹。

## 运行测试

运行隔离的 ERT 测试：

```sh
emacs --batch -Q -l tests/config-tests.el -f ert-run-tests-batch-and-exit
```

只有在适合加载真实本机设置时，才运行普通启动检查：

```sh
emacs --batch -l init.el
```

编译模块并检查告警：

```sh
emacs --batch -L lisp -f batch-byte-compile lisp/*.el
```

检查后删除生成的 `.elc` 文件。Git 会忽略它们。

## 检查配套软件

运行：

```text
M-x my/check-environment
```

如果 beorg 行为发生变化，还要执行 `COMPANION-TOOLS.md` 中的手机检查清单。
目前没有自动化的手机测试。

## 运行时文件

不要提交以下文件或目录：

- `user-settings.el`
- `custom.el`
- `elpa/`
- `recentf`
- `history`
- `projects`
- `backups/`
- `auto-saves/`
- `.elc` 文件

修改配置时，不要直接编辑 `elpa/` 中的软件包文件。

## 文档规则

使用清楚、直接的中文。

- 句子尽量简短。
- 一段只说明一个主题。
- 先说明要做什么，再解释原因。
- 每份完整列表只保留一个来源。
- 其他地方使用链接，不要复制相同内容。

文档职责：

- 安装和日常使用：`README.md`
- 代码结构：`ARCHITECTURE.md`
- 快捷键：`KEYBINDINGS.md`
- Org 数据规则：`ORG-WORKFLOW.md`
- beorg 和系统工具：`COMPANION-TOOLS.md`
- 修改与测试步骤：`MAINTENANCE.md`
