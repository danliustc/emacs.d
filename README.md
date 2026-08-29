# 简洁的 Emacs 配置

这是一套用于 Org 任务管理、笔记和写作的个人 Emacs 配置。

它使用 Evil 提供 Vim 风格的编辑体验，并采用一小部分 Spacemacs 风格的快捷键。
它不是 Spacemacs、Doom Emacs，也不是完整的 IDE。

日常流程只有两个主要入口：

```text
SPC a o c     捕获任务或笔记
SPC a o o d   查看今天
```

## 运行要求

- macOS
- Emacs 30 或更高版本
- 推荐安装 `rg`，用于项目搜索
- 可选安装 `pandoc`，用于 Markdown 导出
- 可选安装 `aspell` 或 `ispell`，用于拼写检查

这些工具应该由系统级 Brewfile 管理。本仓库不会安装或升级 Homebrew 软件。

## 安装

将本仓库放到 `~/.emacs.d`。

创建本机设置文件：

```sh
cp user-settings.example.el user-settings.el
```

启动 Emacs，然后安装缺少的 Emacs 包：

```text
M-x my/install-missing-packages
```

安装完成后重启 Emacs。

## 个人设置

编辑 `user-settings.el`。Git 会忽略这个文件。

```elisp
(setq my/org-dir "~/Library/CloudStorage/Dropbox/orgfiles")
(setq my/font "Iosevka")
(setq my/font-size 150)
(setq my/theme 'solarized-light)

;; 大型项目可以按需加入额外文件。
(setq my/org-extra-agenda-files
      '("~/Library/CloudStorage/Dropbox/orgfiles/project-x.org"))
```

请先确认这台 Mac 上真实的 Dropbox 路径。新版 Dropbox 通常使用
`~/Library/CloudStorage/Dropbox/orgfiles`，旧版可能使用 `~/Dropbox/orgfiles`。
路径填错后，Emacs 仍可能创建一个新的本地目录，因此表面上看不出问题。

## 日常使用

捕获只有两个选项：

```text
SPC a o c t   任务 -> tasks.org
SPC a o c n   想法或笔记 -> ideas.org
```

查看今天：

```text
SPC a o o d
```

这个视图显示今天的项目，以及所有未排期的活动任务。它不会显示 `SOMEDAY`。

需要整理条目时使用：

```text
, T T         切换 TODO 状态
, d s         设置排期
```

## Vim 编辑

- Evil 的 Normal、Motion 和 Visual 状态使用 `SPC` leader。
- Insert 或 Emacs 状态使用 `M-m` 进入同一套 leader。
- Insert 状态快速按 `fd` 返回 Normal 状态。
- Org 模式使用 `,` 作为简短的 local leader。

完整列表见[快捷键](doc/KEYBINDINGS.md)。

## Org 文件

Org 目录包含：

```text
tasks.org     活动任务
ideas.org     想法和笔记
archive.org   已完成内容
init.org      可选的 beorg 配置
```

`tasks.org` 和 `ideas.org` 都是平铺结构。每个条目都是一级标题。这样可以让
桌面端捕获和 beorg 捕获保持一致。

修改 Capture、Refile 或 Archive 规则前，请先阅读 [Org 工作流](doc/ORG-WORKFLOW.md)。

## 检查环境

运行：

```text
M-x my/check-environment
```

报告会检查本地路径和工具，但不会修改文件。它无法证明 Dropbox 已经完成同步，
也无法读取手机上的 beorg 设置。

## 其他文档

- [项目结构](doc/ARCHITECTURE.md)
- [快捷键](doc/KEYBINDINGS.md)
- [Org 工作流](doc/ORG-WORKFLOW.md)
- [配套软件](doc/COMPANION-TOOLS.md)
- [维护指南](doc/MAINTENANCE.md)
