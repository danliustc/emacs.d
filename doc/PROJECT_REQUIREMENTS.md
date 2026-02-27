# Project Requirements and Collaboration Guide

This document is the source of truth for contributors and AI agents in this repository.
It is organized as:
1. Design Philosophy
2. Testing Standards
3. Concrete Design Details

## 1. Design Philosophy

### 1.1 Product Direction

- Keep the config lightweight, stable, and easy to maintain.
- Primary workloads:
  - `org-mode` writing/planning
  - `markdown-mode` writing
  - occasional Python/C++ reading
- Editing paradigm:
  - Vim-first (`evil`)
  - Space-style key system (`SPC` + `,`)
- Explicit non-goal:
  - Do not turn this repo into a heavy full-IDE distribution unless explicitly requested.

### 1.2 Core Principles

- Minimalism first:
  - prefer built-in Emacs capability where practical
  - add packages only when they provide clear daily value
- Predictability:
  - keybindings should be stable and mnemonic
  - avoid surprising mode-specific overrides
- Low maintenance:
  - keep configuration understandable in one pass
  - avoid unnecessary abstractions

### 1.3 Scope and Change Control

- Prefer small, local patches.
- Do not rewrite unrelated areas while fixing one issue.
- Do not silently change project direction (style/workflow) without explicit user request.

### 1.4 Documentation Governance

- If behavior or collaboration rules change, update docs in the same change set.
- Keep docs consistent across:
  - `README.org`
  - `doc/PROJECT_REQUIREMENTS.md`

## 2. Testing Standards

### 2.1 Mandatory Delivery Workflow (TDD)

All behavior changes follow Red/Green/Refactor:

1. Red
   - add/update tests first
   - verify expected failure against current behavior
2. Green
   - implement minimal code change to pass tests
3. Refactor
   - cleanup without changing behavior
   - keep all tests green

Every change summary must include:

- tests added/changed
- red failure point
- green implementation summary
- final test result

### 2.2 Validation Checklist

Before declaring done:

- config loads:
  - `emacs --batch -l init.el`
- regression tests pass:
  - `emacs --batch -l tests/config-tests.el -f ert-run-tests-batch-and-exit`
- key workflow sanity:
  - `SPC` leader works
  - `,` local leader works
  - Org `TAB` fold works

### 2.3 Test Design Rules

- Tests live in `tests/config-tests.el`.
- Behavioral changes require test updates.
- Keep tests focused and avoid overfitting to unrelated formatting.
- Prefer assertions on meaningful behavior contracts and stable symbols.

## 3. Concrete Design Details

### 3.1 Architecture Baseline

- `init.el`
  - bootstrap only
  - loads `config.org` via org-babel
- `config.org`
  - single source of behavior
  - tangled output is `config.el`
- `tests/config-tests.el`
  - repository-level regression checks

### 3.2 Platform Policy

- Primary platform is macOS.
- Modifier mapping on macOS must remain:
  - `Command -> Super`
  - `Option -> Meta`
- Any keymap change must be checked for macOS compatibility.

### 3.3 Configuration Organization

- Keep behavior sections explicit in `config.org`:
  - Core
  - Packages
  - Theme/Font
  - Completion
  - Notes
  - Evil/Keybindings
  - Project Workflow
  - Org/Markdown
- Put related settings close together.
- Prefer small named helper functions when behavior is non-trivial.

### 3.4 Keybinding Standards

- Global interaction model:
  - `SPC` for global workflows
  - `,` for mode-local workflows
- Group naming should stay consistent:
  - `a` applications
  - `f` files
  - `b` buffers
  - `p` projects
  - `w` windows
  - `h` help
  - `q` quit/session
- Org global workflows should be grouped under `SPC a o`.
- New keybindings must:
  - match existing group semantics
  - avoid conflicts with Org critical keys (`TAB`, `<backtab>`)
  - remain discoverable through `which-key`

### 3.5 Package and UI Standards

- Allowed reasons to add a package:
  - clear user-facing workflow improvement
  - difficult to achieve with built-ins
- Avoid by default:
  - cosmetic-only additions
  - heavy IDE stacks not aligned with workload
- When adding a package:
  - add it to `my/packages`
  - guard feature usage with `(require 'pkg nil t)` where needed
  - provide graceful fallback when package is unavailable
- Theme/UI constraints:
  - use one active theme at startup
  - keep font changes intentional and documented
  - avoid mandatory heavy modeline/visual bloat

### 3.6 Org/Markdown and Project Standards

- Org and Markdown are first-class modes and must not regress.
- Org fold keys must remain functional:
  - `TAB -> org-cycle`
  - `<backtab> -> org-shifttab`
- Keep local-leader commands for Org/Markdown.
- Project navigation should prioritize:
  - switch project
  - find file
  - inspect project files/tree
- Keep project switching close to Projectile default behavior unless explicitly requested otherwise.

### 3.7 Error Handling Standards

- Prefer safe fallbacks over startup hard-fail.
- Typical fallback cases:
  - package missing -> skip feature with default behavior
- Startup must remain robust in fresh environments.

### 3.8 Current Baseline (2026-02-27)

- Completion stack:
  - `vertico`
  - `orderless`
  - `consult`
  - `marginalia`
  - `embark`
  - `embark-consult`
- Global completion/search bindings:
  - `C-s -> consult-line`
  - `C-x b -> consult-buffer`
  - `C-. -> embark-act`
  - `C-; -> embark-dwim`
  - `C-h B -> embark-bindings`
- File/project bindings:
  - `SPC f f -> find-file`
  - `SPC f g -> consult-ripgrep`
  - `SPC f l -> consult-line`
  - `SPC f r -> consult-recent-file`
  - `SPC p p -> projectile-switch-project`
  - `SPC p f -> projectile-find-file`
  - `SPC p d -> projectile-dired`
- Org application prefix:
  - `SPC a o a -> org-agenda`
  - `SPC a o c -> org-capture`
  - `SPC a o c i -> my/orgfiles-capture-idea`
  - `SPC a o c j -> my/orgfiles-capture-journal`
  - `SPC a o c m -> my/orgfiles-new-note`
  - `SPC a o l -> org-store-link`
  - `SPC a o t -> org-todo-list`
- Meeting note capture workflow:
  - root directory: `~/code/orgfiles/`
  - meeting directory: `~/code/orgfiles/meetings/`
  - prompt order: note type -> meeting name
  - first-create behavior: instantiate template sections (背景/结论/待办/风险/下次会议前要准备)
