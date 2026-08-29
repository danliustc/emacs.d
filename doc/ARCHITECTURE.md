# 项目结构

这套配置直接加载普通 Emacs Lisp 文件。启动时不会生成配置文件。

它借鉴了 Spacemacs 的一个核心思路：每项功能都应有明确的归属。但它不使用
Spacemacs 的 layer 系统。

## 目录结构

```text
init.el
early-init.el
lisp/
  my-settings.el
  my-packages.el
  my-environment.el
  my-ui.el
  my-editing.el
  my-completion.el
  my-org.el
  my-writing.el
  my-files.el
  my-keybindings.el
tests/
  config-tests.el
doc/
  ARCHITECTURE.md
  KEYBINDINGS.md
  ORG-WORKFLOW.md
  COMPANION-TOOLS.md
  MAINTENANCE.md
```

## 加载顺序

`early-init.el` 在普通 init 文件之前运行。它关闭过早的包激活，并在启动期间提高
垃圾回收阈值。

随后，`init.el` 按以下顺序加载模块：

1. `my-settings.el`
2. `my-packages.el`
3. `my-environment.el`
4. `my-ui.el`
5. `my-editing.el`
6. `my-completion.el`
7. `my-org.el`
8. `my-writing.el`
9. `my-files.el`
10. `my-keybindings.el`

加载顺序是显式的。项目没有自动搜索模块，也没有隐藏的依赖系统。

所有模块加载完成后，`init.el` 加载 `custom.el`，再从 `my/packages` 恢复
`package-selected-packages`。最后这一步很重要，因为 Customize 可能在
`custom.el` 中保存自己的值。

## 模块职责

`my-settings.el` 管理用户设置和路径。存在 `user-settings.el` 时会加载它。

`my-packages.el` 管理包仓库和完整的第三方包清单。启动时不会安装包或刷新仓库。

`my-environment.el` 管理 macOS、剪贴板、外部工具检查和
`my/check-environment`。

`my-ui.el` 管理界面、字体和主题。

`my-editing.el` 管理 Evil、`fd`、空白处理、备份和通用编辑设置。

`my-completion.el` 管理 minibuffer 补全、候选动作和历史记录。

`my-org.el` 管理全部 Org 数据规则。修改前请先阅读 `ORG-WORKFLOW.md`。

`my-writing.el` 管理 Markdown 和拼写检查。

`my-files.el` 管理 Dired、项目、最近文件和导航 wrapper。

`my-keybindings.el` 管理所有自定义快捷键。其他模块只提供命令，不直接增加
leader 键。

## 命名规则

- 本项目提供的公共名称使用 `my/` 前缀。
- 内部辅助函数使用 `my/module--name` 形式。
- 每个模块只提供一个与文件名相同的 feature。
- 所有 Emacs Lisp 文件都启用 lexical binding。
- 长篇说明放入 `doc/`，不要堆在代码注释中。

## 本机文件和运行时文件

以下内容不纳入 Git：

- `user-settings.el`
- `custom.el`
- `elpa/`
- `recentf`
- `history`
- `projects`
- 备份和自动保存目录

Org 任务数据也位于本仓库之外。
