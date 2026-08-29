# 项目指南

这是一套用于 Org、写作和简单文件导航的个人 Emacs 配置。
它使用 Evil 和一小套 Spacemacs 风格的 leader 快捷键。请保持配置简洁。

## 修改前先读

- `doc/ARCHITECTURE.md`：模块和加载顺序。
- `doc/ORG-WORKFLOW.md`：Emacs 与 beorg 共用的数据规则。
- `doc/KEYBINDINGS.md`：唯一完整的快捷键列表。
- `doc/MAINTENANCE.md`：包管理和测试规则。
- `doc/COMPANION-TOOLS.md`：beorg、Dropbox 和命令行工具。

## 主要规则

- 配置源文件在 `lisp/`，没有生成的配置文件。
- 启动过程不能安装软件包。
- `my/packages` 必须与模块实际使用的第三方包保持一致。
- 可选软件包必须有检查或降级路径。
- 不要增加自定义的全局 `C-c` 快捷键。
- `tasks.org` 和 `ideas.org` 必须保持平铺结构。
- 测试不能指向真实的 Dropbox 目录。
- 行为变化必须同时更新对应文档。

## 验证修改

```sh
emacs --batch -Q -l tests/config-tests.el -f ert-run-tests-batch-and-exit
emacs --batch -l init.el
```

第一条命令使用临时 Org 目录。第二条命令会加载真实的本机设置，只有在确实需要
检查正常启动时才运行。
