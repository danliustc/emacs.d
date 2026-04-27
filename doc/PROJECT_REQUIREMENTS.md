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
  - Emacs-native keybindings first
  - Personal workflow shortcuts under `C-c`
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
- Keep docs consistent across: `README.md`, `doc/PROJECT_REQUIREMENTS.md`, `doc/KEYMAPS.org`.
- Avoid duplication: detailed descriptions belong in one place; other docs should reference rather than repeat.
  - Workflow details → `README.md` (user-facing)
  - Design rules and baselines → `PROJECT_REQUIREMENTS.md` (collaboration contract)
  - Full keybindings → `doc/KEYMAPS.org` (source of truth for current bindings)

## 2. Testing Standards

### 2.1 Delivery Workflow

Behavior changes should follow Red/Green/Refactor when there is an existing
test harness or when the behavior is non-trivial enough to justify adding one:

1. Red
   - add/update tests first
   - verify expected failure against current behavior
2. Green
   - implement minimal code change to pass tests
3. Refactor
   - cleanup without changing behavior
   - keep all tests green

Every behavior-change summary should include:

- tests added/changed
- red failure point, when applicable
- green implementation summary
- final test result

### 2.2 Validation Checklist

Before declaring done:

- config loads:
  - `emacs --batch -l init.el`
- regression tests pass, if `tests/config-tests.el` exists:
  - `emacs --batch -l tests/config-tests.el -f ert-run-tests-batch-and-exit`
- key workflow sanity:
  - `C-c` workflow keys work
  - Org `TAB` fold works
  - Org agenda exits with `q`

### 2.3 Test Design Rules

- Tests should live in `tests/config-tests.el` once the repository has a test suite.
- Behavioral changes should add or update tests when the behavior can be validated in batch mode without brittle UI assumptions.
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
  - optional repository-level regression checks; create this file before making the test command mandatory

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
  - Keybindings
  - Project Workflow
  - Org/Markdown
- Put related settings close together.
- Prefer small named helper functions when behavior is non-trivial.

### 3.4 Keybinding Standards

- Global interaction model:
  - built-in Emacs keys remain available (`M-x`, `C-x C-f`, `C-x C-s`, `C-x b`)
  - personal workflow shortcuts use `C-c` mnemonic keys
  - Org mode keeps standard `C-c C-*` bindings where practical
- New keybindings must:
  - stay mnemonic and easy to inspect with `C-h k`
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
- Keep mode-local commands available through Emacs-native `C-c C-*` keys.
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

### 3.8 Current Baseline (2026-04-27)

> ⚠️ This section is a snapshot as of the date above. For the current actual keybindings,
> see `doc/KEYMAPS.org`. Completion stack and keybindings may have evolved since this was written.

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
  - `C-. -> embark-act` (global; also available in minibuffer)
  - `C-; -> embark-dwim`
  - `M-y -> consult-yank-pop`
  - `C-h B -> embark-bindings`
- Search/file/buffer bindings:
  - `C-x C-f -> find-file`
  - `C-c s -> consult-ripgrep`
  - `C-c f -> consult-find`
  - `C-c o -> consult-outline`; in `org-mode`, `consult-org-heading`
  - `C-c b -> consult-buffer`
  - `C-c t -> dired-sidebar-toggle-sidebar`
- Ergonomics baseline:
  - line numbers are enabled via `prog-mode-hook`, not globally
  - Evil/Vim modal editing is disabled
  - there is no insert-state escape chord
- Org application prefix:
  - `C-c a -> org-agenda`
  - `C-c c -> org-capture`
  - `C-c l -> org-store-link`
  - `C-c g i/p/w/c/d/n -> open inbox, personal, work, config, daily review, process inbox`
- Org files are derived from `my/org-dir`: `inbox.org`, `personal.org`, `work.org`, and `journal.org`.

### 3.9 Org Capture Workflows

Capture uses the built-in `org-capture` dispatcher on `C-c c`.

**Inbox**: key `i`, captures a `TODO` entry directly into `my/org-inbox`.

**Personal Task**: key `p`, captures a `TODO` entry under the `Tasks` headline in `my/org-personal`.

**Work Task**: key `w`, captures a `TODO` entry under the `Tasks` headline in `my/org-work`.

**Note**: key `n`, captures a non-task note under the `Notes` headline in `my/org-inbox`.

**Journal**: key `j`, captures into the datetree in `my/org-journal`.

**Reading Note**: key `r`, captures under the `Reading` headline in `my/org-personal`.

### 3.10 Agenda Scope and Refile

- At startup, `org-agenda-files` is initialized from `my/org-inbox`, `my/org-personal`, `my/org-work`, plus optional `my/org-extra-agenda-files`.
- `my/gtd-initialize` creates the core org files if they do not exist.
- Flow: capture lands in `inbox.org`, `personal.org`, `work.org`, or `journal.org`; review and refile actionable items via Org default `C-c C-w`.
- Refile completion is flat (`org-outline-path-complete-in-steps nil`) and includes the file prefix (`org-refile-use-outline-path 'file`) so vertico/orderless can fuzzy-match across files.
- Larger projects can be kept in separate org files and added through `my/org-extra-agenda-files`.
- Full-text search across notes remains available via `C-c s` (`consult-ripgrep`).
