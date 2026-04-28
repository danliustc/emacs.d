# Emacs 配置 — 快速上手

基于 org-mode 文学编程的 Emacs 配置，专为 GTD 任务管理和写作设计。 配置文件通过 Dropbox 同步，手机端用 beorg 配合使用。

------

## 文件结构

```
~/.emacs.d/
├── init.el              # 一行引导，不用动
├── early-init.el        # 启动早期设置
├── config.org           # 配置主体，不用动
├── user-settings.example.el # 个人设置模板
└── user-settings.el     # 本机个人设置，Git 不跟踪

~/Dropbox/orgfiles/
├── inbox.org            # 收集箱
├── tasks.org            # 所有已明确的行动任务
├── ideas.org            # 碎碎念 / 想法
└── init.org             # beorg（手机）配置
```

------

## 安装

```bash
# 1. 安装依赖
brew install ripgrep aspell pandoc

# 2. 放置配置文件
cp init.el ~/.emacs.d/init.el
cp early-init.el ~/.emacs.d/early-init.el
cp config.org ~/.emacs.d/config.org
cp user-settings.example.el ~/.emacs.d/user-settings.el

# 3. 首次安装第三方包
# 启动 Emacs 后运行：M-x my/install-missing-packages
```

------

## 个人设置

只需编辑 `user-settings.el`，其他文件不用动。

```elisp
(setq my/org-dir "~/Dropbox/orgfiles")  ; org 文件夹路径
(setq my/font "Iosevka")                 ; 字体
(setq my/font-size 150)                  ; 字号（150 = 15pt）
(setq my/theme 'modus-operandi-tinted)   ; 主题

; 有复杂项目时，取消注释加入额外文件
; (setq my/org-extra-agenda-files
;       '("~/Dropbox/orgfiles/project-x.org"))
```

------

## 日常工作流

### 收集想法

随时用 `C-c c` 打开捕获菜单：

| 按键             | 动作                 |
| ---------------- | -------------------- |
| `C-c c` 然后 `i` | 扔进 Inbox（最常用） |
| `C-c c` 然后 `p` | 个人任务，写入 tasks.org 并加 `:personal:` |
| `C-c c` 然后 `w` | 工作任务，写入 tasks.org 并加 `:work:`     |
| `C-c c` 然后 `s` | 放入 Someday / Maybe |
| `C-c c` 然后 `n` | 记一条碎碎念 / 想法  |

### 每日回顾

```
C-c a d      打开今日仪表盘
  → 显示今天的日程、NEXT 任务、等待中的事、待处理 Inbox
C-c a n      Anytime / 下一步行动
C-c a i      Inbox
C-c a s      Someday / Maybe
C-c a u      Upcoming（未来 14 天）
C-c a W      本周概览
C-c a p      个人任务列表
C-c a k      工作任务列表
```

### 处理 Inbox

```
C-c g n      打开 inbox.org
C-c C-t      切换 TODO 状态（TODO → NEXT → DONE；WAITING/SOMEDAY 可用快捷键直接选）
C-c C-w      Refile 到 tasks.org
C-c C-s      设置 Scheduled 时间
C-c C-d      设置 Deadline
C-c C-c      打标签（personal work health computer 等）
```

### 任务与搜索

所有已明确要做的任务统一放在 `tasks.org`。个人、工作、健康、学习等维度用标签表达，不再按文件硬分类。

```org
* Tasks
** NEXT 预约体检 :personal:health:
SCHEDULED: <2026-04-29 Wed>

** NEXT 写项目周报 :work:

** WAITING 等朋友确认旅行日期 :personal:travel:

** SOMEDAY 学摄影 :personal:learning:
```

项目很大时，可以在 `tasks.org` 里建一个普通标题组织子任务；真的需要单独文件时，再加到 `user-settings.el` 的 `my/org-extra-agenda-files` 里。

------

## 快捷键总览

### 命令搜索（最重要）

| 按键                | 功能                                   |
| ------------------- | -------------------------------------- |
| `Option+x`（即 `M-x`） | 搜索所有命令，模糊匹配，输入任意关键词 |
| `C-h B`             | 列出当前所有可用快捷键                 |
| `C-h k`             | 查某个快捷键是什么命令                 |

> `M-x` 支持空格分隔的多词匹配：输入 `org cap` 找到 `org-capture`，输入 `buf sw` 找到 `switch-to-buffer`，顺序不限。

### GTD 核心

| 按键      | 功能                          |
| --------- | ----------------------------- |
| `C-c c`   | 捕获任务 / 笔记               |
| `C-c a d` | 今日仪表盘                    |
| `C-c a n` | 下一步行动 / Anytime          |
| `C-c a i` | Inbox                         |
| `C-c a s` | Someday / Maybe               |
| `C-c a u` | Upcoming                      |
| `C-c a`   | Agenda 菜单（再按字母选视图） |
| `C-c g i` | 打开 inbox.org                |
| `C-c g t` | 打开 tasks.org                |
| `C-c g e` | 打开 ideas.org                |
| `C-c g d` | 今日 Agenda（同 `C-c a d`）   |
| `C-c g n` | 处理 Inbox                    |

### Org 文件内操作

| 按键        | 功能                     |
| ----------- | ------------------------ |
| `C-c C-t`   | 切换 TODO 状态           |
| `C-c C-w`   | Refile 到其他文件 / 标题 |
| `C-c C-s`   | 设置 Scheduled 时间      |
| `C-c C-d`   | 设置 Deadline            |
| `C-c C-c`   | 打标签 / 确认            |
| `C-c C-o`   | 打开链接                 |
| `Tab`       | 展开 / 折叠当前标题      |
| `Shift+Tab` | 全局展开 / 折叠          |

### 搜索与导航

| 按键    | 功能                                     |
| ------- | ---------------------------------------- |
| `C-s`   | 当前文件实时搜索                         |
| `C-c s` | 全局内容搜索（ripgrep，跨所有 org 文件） |
| `C-c f` | 文件名搜索                               |
| `C-c o` | 跳转到 org 大纲标题                      |
| `C-c b` | 切换 Buffer                              |
| `M-y`   | 粘贴历史（选择之前复制过的内容）         |

### 界面

| 按键      | 功能                                    |
| --------- | --------------------------------------- |
| `C-c t`   | 侧边栏文件树                            |
| `C-.`     | Embark 动作菜单（对光标处内容触发操作） |
| `C-c g c` | 打开配置文件（config.org）              |

### 剪贴板

| 按键             | 功能             |
| ---------------- | ---------------- |
| `Cmd+C` 或 `M-w` | 复制到系统剪贴板 |
| `Cmd+V` 或 `C-y` | 从系统剪贴板粘贴 |
| `M-y`            | 弹出粘贴历史列表 |

------

## 主题切换

在 `user-settings.el` 里改 `my/theme`：

| 值                      | 外观             |
| ----------------------- | ---------------- |
| `modus-operandi`        | 标准亮色         |
| `modus-operandi-tinted` | 暖调亮色（默认） |
| `modus-vivendi`         | 标准暗色         |
| `modus-vivendi-tinted`  | 暖调暗色         |

------

## 手机端（beorg）

将 `init.org` 放入 `~/Dropbox/orgfiles/`，beorg 启动时自动读取。 配置了和 Emacs 一致的 TODO 关键词（`TODO → NEXT → WAITING → SOMEDAY → DONE`）、捕获模板、以及排除 `init.org` 本身不出现在任务列表里。

修改后在 beorg 的 REPL 里输入 `(load 'init)` 立即生效，无需重启。
