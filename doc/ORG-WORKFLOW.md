# Org 工作流

这套工作流只有一条主要规则：

> 需要行动的内容放进 `tasks.org`，其他内容放进 `ideas.org`。

## 文件

`my/org-dir` 指向的目录包含：

```text
tasks.org     活动任务
ideas.org     想法和普通笔记
archive.org   已完成内容
init.org      可选的 beorg 配置
```

`tasks.org` 和 `ideas.org` 都是平铺结构。每个条目都是一级标题。不要增加
`* Tasks` 或 `* Inbox` 之类的容器标题。

这种结构与 beorg 的捕获方式一致，也省掉了单独整理 inbox 的步骤。

## Capture

使用 `SPC a o c` 打开捕获菜单。

```text
t   在 tasks.org 中创建 TODO 条目
n   在 ideas.org 中创建普通标题
```

两个模板都会将新条目追加到文件末尾，不会询问标签、日期或目标文件。

## 今天视图

使用 `SPC a o o` 打开 Agenda，然后按 `d`。

这个视图包含两部分：

1. 今天到期的项目。
2. 没有排期或截止日期的活动 `TODO` 和 `WAITING` 项目。

`SOMEDAY` 不会出现在这个视图中。需要查看时，使用 Org 自带的全部 TODO 列表。

## 状态

日常状态路径是：

```text
TODO -> DONE
```

需要时可以使用：

```text
WAITING
SOMEDAY
CANCELLED
```

没有 `NEXT` 状态，因为它需要一个实际没有被使用的额外整理步骤。

状态变化写入 `LOGBOOK` 抽屉。重复任务完成后回到 `TODO`。beorg 必须使用相同规则。

## Refile

Refile 的作用是将条目移动到其他文件，不能把条目挂到另一个任务下面。

允许的目标只有：

- `tasks.org` 顶层
- `ideas.org` 顶层
- `archive.org` 顶层
- `archive.org/Archived`

三个设置共同保护平铺结构：

- `org-refile-use-outline-path` 为 `file`，因此可以选择文件根部。
- `tasks.org` 和 `ideas.org` 使用不会返回标题的正则表达式。
- Refile 时不能临时创建父标题。

除非同时补充平铺结构测试，否则不要简化这些设置。

## Archive

归档条目进入 `archive.org` 的 `* Archived` 标题。它是这套工作流唯一需要的容器标题。

## 重复任务

使用普通 Org repeater：

```org
* TODO 查看工作邮箱 :work:
SCHEDULED: <2026-08-29 Sat .+1d>
```

完成后，Org 会计算下一个日期，并将条目恢复为 `TODO`。已排期条目不会出现在
“今天”视图的未排期部分。

## 标签

工作、家庭、健康和旅行等维度使用标签表达。除非有明确需求，不要为每个维度创建
单独文件。

## beorg 契约

桌面 Emacs 和 beorg 必须在以下方面保持一致：

- TODO 与 DONE 状态
- 任务和想法的捕获目标
- `LOGBOOK` 状态记录
- 重复任务恢复状态
- 从任务视图排除的文件

仓库中的样例是 `beorg-init.sample.org`。设置和检查方式见[配套软件](COMPANION-TOOLS.md)。

## 数据安全

不要同时在 Emacs 和 beorg 中编辑同一个文件。在手机上编辑前，先保存桌面 buffer。
如果 Dropbox 产生冲突副本，删除任何一份之前都要先比较两边内容。
