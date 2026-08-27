# Emacs 配置 — 快速上手

基于 org-mode 文学编程的 Emacs 配置，专为任务管理和写作设计。配置文件通过 Dropbox 同步，手机端用 beorg 配合使用。

日常只有两个动作：**记一笔 `C-c c`，看一眼 `C-c a d`。**

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
├── tasks.org            # 要做的（* Tasks 一次性任务 / * Routines 日常杂务）
├── ideas.org            # 只是记的：想法、碎碎念、笔记
├── archive.org          # 完事的
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
# 装完重启一次 Emacs，配置才会生效
```

之后升级所有包用 `M-x my/upgrade-packages`，清理不再需要的包用 `M-x package-autoremove`。

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

### 记一笔

`C-c c` 只有两个选项，捕获时只需回答一个问题：**这需要我做点什么吗？**

| 按键             | 动作                          |
| ---------------- | ----------------------------- |
| `C-c c` 然后 `t` | 要做的事 → `tasks.org`        |
| `C-c c` 然后 `n` | 想法 / 笔记 → `ideas.org`     |

不选文件、不选标签、不填时间。

### 看一眼

```
C-c a d      今天
  → 第一块：今天到期的（含日常杂务）
  → 第二块：所有没排期的待办
C-c a t      内置的全部待办列表（含 SOMEDAY）
```

只有这一个自定义视图。想整理的时候再整理，不整理也照样能用。

### 想整理的时候

```
C-c C-t      切换 TODO 状态（TODO → DONE；WAITING/SOMEDAY 按首字母直接选）
C-c C-s      排期（这是让任务出现在「今天」的唯一方式）
C-c C-c      打标签
C-c C-w      挪到别处（Tasks ↔ Routines，或归档）
C-c C-x C-a  归档到 archive.org
```

### tasks.org 的结构

```org
* Tasks
** TODO 第三次整牙 :personal:health:
** TODO 和法务制定与kimi合作的合同 :work:
** WAITING 等对方确认 :work:
** SOMEDAY 学摄影 :personal:

* Routines
** TODO 查看公司邮箱 :work:
SCHEDULED: <2026-08-27 Thu .+1d>
** TODO 填写项目工时 :work:
SCHEDULED: <2026-08-28 Fri .+1w>
```

`* Routines` 放每天/每周重复的杂务，靠 `.+1d` / `.+1w` 这样的 repeater 到期才冒出来，
平时不占待办列表。做完按 `C-c C-t` 标 DONE，它会自动排到下一次。

个人、工作、健康等维度用标签表达，不按文件分。真的需要单独文件时，加到
`user-settings.el` 的 `my/org-extra-agenda-files` 里。

------

## 快捷键总览

### 命令搜索（最重要）

| 按键                | 功能                                   |
| ------------------- | -------------------------------------- |
| `Option+x`（即 `M-x`） | 搜索所有命令，模糊匹配，输入任意关键词 |
| `C-h B`             | 列出当前所有可用快捷键                 |
| `C-h k`             | 查某个快捷键是什么命令                 |

> `M-x` 支持空格分隔的多词匹配：输入 `org cap` 找到 `org-capture`，输入 `buf sw` 找到 `switch-to-buffer`，顺序不限。

### 核心（只有这两个要记）

| 按键        | 功能                        |
| ----------- | --------------------------- |
| `C-c c t`   | 记一件要做的事              |
| `C-c c n`   | 记一个想法                  |
| `C-c a d`   | 看今天                      |

其余的：

| 按键      | 功能                          |
| --------- | ----------------------------- |
| `C-c a t` | 内置全部待办列表（含 SOMEDAY）|
| `C-c a`   | Agenda 菜单                   |
| `C-c g t` | 打开 tasks.org                |
| `C-c g e` | 打开 ideas.org                |
| `C-c g d` | 看今天（同 `C-c a d`）        |

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

| 值                              | 外观               |
| ------------------------------- | ------------------ |
| `solarized-light`               | 标准亮色（默认）   |
| `solarized-light-high-contrast` | 高对比亮色         |
| `solarized-dark`                | 标准暗色           |
| `solarized-dark-high-contrast`  | 高对比暗色         |

------

## 手机端（beorg）

将 `init.org` 放入 `~/Dropbox/orgfiles/`，beorg 启动时自动读取。和 Emacs 两端保持一致：

- 同样的 TODO 关键词（`TODO / DONE`，加上按需使用的 `WAITING`、`SOMEDAY`、`CANCELLED`）
- 同样的两个捕获模板（任务 → `tasks.org`，想法 → `ideas.org`）
- 排除 `init.org` 和 `archive.org`，两端看到的文件一致
- 默认打开 todo 页（排期还不多的时候，agenda 页会是空的）

修改后在 beorg 的 REPL 里输入 `(load 'init)` 立即生效，无需重启。
