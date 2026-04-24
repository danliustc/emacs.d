# Emacs 配置

Emacs 原生按键，轻量，偏写作和轻量代码阅读。

## 常用按键

```
C-x C-f    打开文件
C-x b      切换 buffer
C-s        当前文件搜索
M-x        执行命令（如 my/reload-config）
```

`C-c` 前缀下：

```
C-c s      搜索入口（文件内 / 项目全文 / 符号 / 最近文件）
C-c g      项目全文搜索（consult-ripgrep）
C-c p      切换项目
C-c f      项目内找文件
C-c d      项目根目录 dired
C-c a      agenda
C-c c      capture 菜单（todo / idea / journal / brainstorm / meeting）
C-c t      快速 TODO
C-c T      TODO 列表
C-c +-0    字号 + / - / 重置
C-c q      关窗
```

终端下 `C-c w` 复制（有选区复制内容，否则复制整行）。GUI 下 `Cmd-c/v/x` 走系统剪贴板。

搜索/补全时 `C-.` 对候选项执行动作，`C-c C-o` 导出到可编辑列表。

## 笔记

根目录 `~/Documents/orgfiles/`，可通过 `ORGFILES_ROOT` 环境变量或 `~/.emacs.d/local.el` 覆盖。

- inbox.org — 快速捕获的 TODO
- ideas.org — 想法
- YYYY-MM-DD.org — 日记
- YYYY-MM-DD-HHMM-<title>.org — 头脑风暴 / 会议记录
- projects/<name>.org — 需要长期跟的项目

Agenda 启动时从根目录下除 `init.org` 以外的 `.org` 文件和 `projects/` 初始化。会话中新建的日记、会议或头脑风暴文件不会自动进入 agenda；需要长期跟踪时 refile 到项目文件，或重载配置。

Capture 五种类型统一从 `C-c c` 进入。refile 用 Org 默认的 `C-c C-w`。

## 新机器

```sh
git clone <repo-url> ~/.emacs.d
mkdir -p ~/Documents/orgfiles
# 或 export ORGFILES_ROOT="$HOME/Dropbox/orgfiles"
```

启动时自动安装缺失的包。

## 参考

[config.org](config.org) · [doc/KEYMAPS.org](doc/KEYMAPS.org) · [doc/PROJECT_REQUIREMENTS.md](doc/PROJECT_REQUIREMENTS.md)

```sh
emacs --batch -l tests/config-tests.el -f ert-run-tests-batch-and-exit
```
