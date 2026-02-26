# Project Requirements and Collaboration Guide

This document records the working rules and project expectations for this repository.
It is intended for both human contributors and AI agents.

## 1. Project Goal

- Keep this Emacs config lightweight and stable.
- Primary use cases:
- `org-mode`
- `markdown-mode`
- Occasional Python/C++ code reading
- Editing style is Vim-first (`evil`), not VSCode-style.

## 2. Current Technical Baseline

- Entry point: `init.el`
- Main config: `config.org` (literate config, tangled to `config.el`)
- Tests: `tests/config-tests.el` (ERT)
- Platform focus: macOS

## 3. Keybinding Strategy (Space-style)

- Global leader key: `SPC`
- Local leader key: `,`
- Do not replace this with a VSCode shortcut scheme.
- Keep common mappings under `SPC` groups (`f`, `b`, `p`, `w`, `q`, `h`).
- Recent files must be available at `SPC f r`.

## 4. org-mode and markdown Requirements

- `org-mode` and `markdown-mode` are first-class workflows.
- In `org-mode`, `TAB` must work for folding (`org-cycle`).
- In `org-mode`, `S-TAB`/`<backtab>` must work for global cycling (`org-shifttab`).
- Keep local leader commands for org and markdown.

## 5. macOS Requirements

- On macOS:
- `Command -> Super`
- `Option -> Meta`
- New keybinding changes must be validated for macOS behavior.

## 6. Development Workflow (Mandatory)

- Use Red/Green TDD for future changes:
- Red: add or update tests first, and ensure they fail for the target behavior.
- Green: implement the smallest possible change to pass tests.
- Refactor: clean up while keeping tests green.
- In every change summary, explicitly report:
- what tests were added/changed
- what failed in Red
- what was changed for Green
- final test status

## 7. Change Scope Rules

- Prefer minimal, local edits over large rewrites.
- Keep the configuration lightweight; avoid heavy IDE stacks unless explicitly requested.
- Preserve existing project direction unless the user explicitly changes it.

## 8. Validation Checklist for Contributors

- Config loads without startup errors.
- ERT tests pass:
- `emacs --batch -l tests/config-tests.el -f ert-run-tests-batch-and-exit`
- `SPC` leader still works.
- `,` local leader still works in org/markdown/prog buffers.
- `org-mode` tab behavior still works.

## 9. Documentation Practice

- If requirements or workflow change, update this file in the same PR/commit.
- Keep this file as the source of truth for collaboration behavior.
