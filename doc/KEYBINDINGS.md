# 快捷键

这套配置使用一小部分 Spacemacs 风格的快捷键约定。

## 人体工学原则

选择延续 Spacemacs，是因为认可它的人体工学设计。快捷键调整应保留这套设计的使用体验：

- 优先使用 `SPC` leader 和按顺序输入的键序列，减少频繁同时按住多个修饰键的负担。
- 沿用有助记意义的功能分组，让相近功能的位置容易记忆和发现。
- 保持通用操作与模式内操作的一致性，保留已有的 Spacemacs 肌肉记忆。
- 评估高频操作时，同时考虑按键舒适度、记忆成本和操作步数，不单独追求键序列最短。

调整前先核对 Spacemacs 上游行为，优先在现有约定中解决需求。

## Leader 规则

- Evil 的 Normal、Motion 和 Visual 状态使用 `SPC`。
- Insert 或 Emacs 状态使用 `M-m`。
- 当前 major mode 的命令放在 `SPC m` 下。
- Org 和 Agenda 使用 `,` 作为 `SPC m` 的简写。
- Insert／Emacs 状态下，GUI 使用 Option＋Return（`M-<return>`），终端使用 `C-M-m` 进入 local map。
- 输入前缀后稍等，which-key 会显示后续按键。
- 未安装 Evil 时，仍可使用 `M-m` 和上述 Org／Agenda local leader 入口。

## 全局 Leader

| Normal 或 Motion | Insert 或 Emacs | 功能 |
| --- | --- | --- |
| `SPC SPC` | `M-m SPC` | 运行命令 |
| `SPC TAB` | `M-m TAB` | 在最近两个 buffer 间往返 |
| `SPC f f` | `M-m f f` | 打开文件 |
| `SPC f r` | `M-m f r` | 打开最近文件 |
| `SPC f s` | `M-m f s` | 保存当前文件 |
| `SPC f t` | `M-m f t` | 开关文件侧边栏 |
| `SPC b b` | `M-m b b` | 切换 buffer 或最近文件 |
| `SPC b d` | `M-m b d` | 关闭当前 buffer，但不删除文件 |
| `SPC s p` | `M-m s p` | 搜索项目内容 |
| `SPC s s` | `M-m s s` | 搜索当前 buffer |
| `SPC p p` | `M-m p p` | 切换已知项目 |
| `SPC p f` | `M-m p f` | 查找当前项目中的文件 |
| `SPC j i` | `M-m j i` | 跳转到标题或符号 |
| `SPC a o c` | `M-m a o c` | 打开 Org Capture |
| `SPC a o o` | `M-m a o o` | 打开 Org Agenda |
| `SPC a u s` | `M-m a u s` | 查看累计命令使用次数 |
| `SPC a u e` | `M-m a u e` | 导出带日期的本地统计快照 |
| `SPC w h/j/k/l` | `M-m w h/j/k/l` | 切换到左／下／上／右窗口 |
| `SPC w v` | `M-m w v` | 左右分屏，光标留在原窗口 |
| `SPC w s` | `M-m w s` | 上下分屏，光标留在原窗口 |
| `SPC w d` | `M-m w d` | 关闭当前窗口，保留 buffer |
| `SPC w =` | `M-m w =` | 均衡窗口面积 |
| `SPC w u` | `M-m w u` | 撤销窗口布局变化 |
| `SPC h d k` | `M-m h d k` | 查看按键说明 |
| `SPC h d f` | `M-m h d f` | 查看函数说明 |
| `SPC h d v` | `M-m h d v` | 查看变量说明 |

`SPC p p` 使用 Emacs 内置的 `project.el`。第一次使用时选择项目目录，Emacs 会将它
保存在本机的 `projects` 文件中。

`SPC s s` 使用现有的 `consult-line`；未安装 Consult 时降级为原生增量搜索。

`SPC a u` 是本配置自定义的使用统计分组，需要 `keyfreq`；未安装时会提示安装入口。
快照和每周回顾方法见[使用统计](USAGE.md)。Insert 或 Emacs 状态下，
`C-u M-m a u s` 只显示当前 major mode 的统计。

窗口布局历史由内置的 `winner-mode` 记录，`SPC w u` 不会撤销文字编辑。
窗口操作使用内置功能。Spacemacs 风格键位参考
[Spacemacs 默认绑定](https://github.com/syl20bnr/spacemacs/blob/develop/layers/%2Bspacemacs/spacemacs-defaults/keybindings.el)
及[官方文档](https://www.spacemacs.org/doc/DOCUMENTATION.html)。

## Org Local Leader

| Normal 或 Motion | Insert 或 Emacs | 功能 |
| --- | --- | --- |
| `, T T` 或 `SPC m T T` | `M-RET T T` | 切换 TODO 状态 |
| `, d s` 或 `SPC m d s` | `M-RET d s` | 设置排期 |
| `, d d` 或 `SPC m d d` | `M-RET d d` | 设置截止日期 |
| `, s r` 或 `SPC m s r` | `M-RET s r` | Refile，将条目移动到其他文件 |
| `, s A` 或 `SPC m s A` | `M-RET s A` | 归档当前子树到配置的归档位置 |
| `, s n` 或 `SPC m s n` | `M-RET s n` | 只显示当前子树 |
| `, s w` 或 `SPC m s w` | `M-RET s w` | 恢复显示全文 |

表中的 `M-RET` 指 GUI 的 Option＋Return；终端将此前缀替换为 `C-M-m`。
Agenda 对光标所在条目使用相同的状态、排期、截止日期和 Refile 路径。
归档和子树显示范围的上述快捷键仅用于 Org 编辑 buffer。
Refile 和归档沿用[现有的平铺文件规则](ORG-WORKFLOW.md#refile)。
只显示子树不会删除内容，使用 `, s w` 即可恢复全文。

Org 编辑中，GUI 连续按两次 Option＋Return 执行 `org-meta-return`，按上下文新建
标题或列表项；终端使用 `C-M-m M-RET`。`C-M-m` 与 `M-RET` 是同一个按键事件，
因此单独按 `M-RET` 会进入 local leader，不再直接新建条目。
Agenda 默认的 Motion 状态下，Option＋Return 执行 `org-agenda-show-and-scroll-up`，
显示并滚动对应条目；local leader 仍可使用 `,` 或 `SPC m`。

这些约定参考 [Spacemacs 核心设置](https://github.com/syl20bnr/spacemacs/blob/develop/core/core-dotspacemacs.el)
及 [Org layer](https://www.spacemacs.org/layers/+emacs/org/README.html)。

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
和用户。加载或重载本配置也不会清除用户已有的 `C-c` 绑定。
