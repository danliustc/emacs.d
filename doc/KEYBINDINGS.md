# 快捷键

这套配置使用一小部分 Spacemacs 风格的快捷键约定。

## Leader 规则

- Evil 的 Normal、Motion 和 Visual 状态使用 `SPC`。
- Insert 或 Emacs 状态使用 `M-m`。
- 当前 major mode 的命令放在 `SPC m` 下。
- Org 和 Agenda 使用 `,` 作为 `SPC m` 的简写。
- 在非 Normal 状态下，Org 和 Agenda 使用 `M-RET` 进入同一套 local map。
- 输入前缀后稍等，which-key 会显示后续按键。

## 全局 Leader

| Normal 或 Motion | Insert 或 Emacs | 功能 |
| --- | --- | --- |
| `SPC SPC` | `M-m SPC` | 运行命令 |
| `SPC f f` | `M-m f f` | 打开文件 |
| `SPC f r` | `M-m f r` | 打开最近文件 |
| `SPC f t` | `M-m f t` | 开关文件侧边栏 |
| `SPC b b` | `M-m b b` | 切换 buffer 或最近文件 |
| `SPC b k` | `M-m b k` | 关闭当前 buffer |
| `SPC s p` | `M-m s p` | 搜索项目内容 |
| `SPC p p` | `M-m p p` | 切换已知项目 |
| `SPC j i` | `M-m j i` | 跳转到标题或符号 |
| `SPC a o c` | `M-m a o c` | 打开 Org Capture |
| `SPC a o o` | `M-m a o o` | 打开 Org Agenda |

`SPC p p` 使用 Emacs 内置的 `project.el`。第一次使用时选择项目目录，Emacs 会将它
保存在本机的 `projects` 文件中。

## Org Local Leader

| Normal 或 Motion | Insert 或 Emacs | 功能 |
| --- | --- | --- |
| `, T T` 或 `SPC m T T` | `M-RET T T` | 切换 TODO 状态 |
| `, d s` 或 `SPC m d s` | `M-RET d s` | 设置排期 |

Agenda 对光标所在条目使用相同的路径。

## Evil Escape

Insert 状态快速按 `fd` 可以返回 Normal 状态。没有在规定时间内按完整的组合时，
普通的 `f` 或 `d` 仍会正常输入。

## 保留的原生快捷键

| 按键 | 功能 |
| --- | --- |
| `M-x` | 运行命令 |
| `C-s` | 搜索当前 buffer |
| `C-x b` | 切换 buffer 或最近文件 |
| `C-.` | 打开 Embark 动作 |
| `C-h B` | 显示当前快捷键 |
| `C-h k` | 查看某个按键的说明 |
| `C-c C-t` | Org 原生 TODO 命令 |
| `C-c C-s` | Org 原生排期命令 |
| `C-c C-w` | Org 原生 Refile 命令 |
| `C-c C-c` | Org 原生确认命令 |
| `M-y` | 从 kill ring 中选择内容 |

不要增加自定义的全局 `C-c` 快捷键。按照 Emacs 约定，这个前缀应留给 major mode
和用户。
