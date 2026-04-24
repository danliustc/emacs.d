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
- Keep docs consistent across: `README.md`, `doc/PROJECT_REQUIREMENTS.md`, `doc/KEYMAPS.org`.
- Avoid duplication: detailed descriptions belong in one place; other docs should reference rather than repeat.
  - Workflow details → `README.md` (user-facing)
  - Design rules and baselines → `PROJECT_REQUIREMENTS.md` (collaboration contract)
  - Full keybindings → `doc/KEYMAPS.org` (source of truth for current bindings)

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
  - `a` actions
  - `f` files
  - `b` buffers
  - `p` projects
  - `w` windows
  - `z` zoom
  - `h` help
  - `q` quit
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

### 3.8 Current Baseline (2026-02-28)

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
  - `C-, -> embark-dwim` (global; also available in minibuffer)
  - `C-c C-o -> embark-export` (inside minibuffer)
  - `C-h B -> embark-bindings`
  - `SPC a d -> my/orgfiles-capture-dispatch` (shortcut for `SPC a o c c`)
- File/project bindings:
  - `SPC f f -> find-file`
  - `SPC f g -> my/consult-ripgrep` (`consult-ripgrep`, fallback `rgrep`)
  - `SPC f l -> my/consult-line` (`consult-line`, fallback `isearch-forward`)
  - `SPC f r -> my/consult-recent-file` (`consult-recent-file`, fallback `recentf-open-files`)
  - `SPC p p -> projectile-switch-project`
  - `SPC p f -> projectile-find-file`
  - `SPC p d -> projectile-dired`
  - `SPC w h/j/k/l -> windmove-left/down/up/right`
  - `SPC w / -> split-window-right`
  - `SPC w - -> split-window-below`
  - `SPC w d -> delete-window`
- Ergonomics baseline:
  - line numbers are enabled via `prog-mode-hook`, not globally
  - insert-state escape chord is `fd` with `key-chord-two-keys-delay 0.2`
  - font size is adaptive by display width and adjustable with:
    - `SPC z = -> my/font-size-increase`
    - `SPC z - -> my/font-size-decrease`
    - `SPC z 0 -> my/font-size-reset`
- Org application prefix:
  - `SPC a o a -> org-agenda`
  - `SPC a o c -> capture prefix`
  - `SPC a o c b -> my/orgfiles-capture-brainstorm`
  - `SPC a o c c -> my/orgfiles-capture-dispatch`
  - `SPC a o c i -> my/orgfiles-capture-idea`
  - `SPC a o c j -> my/orgfiles-capture-journal`
  - `SPC a o c m -> my/orgfiles-capture-meeting`
  - `SPC a o c t -> my/orgfiles-capture-todo`
  - `SPC a o l -> org-store-link`
  - `SPC a o t -> org-todo-list`
  - `SPC a d -> my/orgfiles-capture-dispatch` (shortcut; same as `SPC a o c c`)
- Brainstorm draft workflow: default target `~/Documents/orgfiles/`, file naming `YYYY-MM-DD-HHMM-<title>.org`. Override via `ORGFILES_ROOT` or `~/.emacs.d/local.el`. See Section 3.9 below for details.
- Todo capture workflow: target file `~/Documents/orgfiles/inbox.org`, headline `Tasks`, direct keybinding `SPC a o c t`. See Section 3.9 below for details.
- Meeting note capture workflow: default root `~/Documents/orgfiles/`, file naming `YYYY-MM-DD-HHMM-<meeting-name>.org`. See Section 3.9 below for details.

### 3.9 Org Capture Workflows

**Brainstorm**: Create a new file each time (no org-capture template entry). File path: `~/Documents/orgfiles/YYYY-MM-DD-HHMM-<title>.org`. Override: `ORGFILES_ROOT` or `~/.emacs.d/local.el`.

**Todo**: Capture to `~/Documents/orgfiles/inbox.org` under the `Tasks` headline. Direct keybinding: `SPC a o c t`. Dispatch option: `todo`.

**Meeting**: Creates new file at `~/Documents/orgfiles/YYYY-MM-DD-HHMM-<meeting-name>.org`. Prompt order: capture key → meeting name → meeting time (defaults to now). First-create instantiates template sections: 背景/结论/待办/风险/下次会议前要准备.

**Journal**: Capture to `~/Documents/orgfiles/YYYY-MM-DD.org`.

**Idea**: Capture to `~/Documents/orgfiles/ideas.org`.

**Dispatch**: Menu-driven entry point for all capture types.

### 3.10 Agenda Scope and Refile

- `org-agenda-files` is an explicit list: `inbox.org`, `ideas.org`, and the `projects/` subdirectory under `my/orgfiles-root`. Meeting/brainstorm/journal files in the root are deliberately excluded so the agenda stays small and stable as those files accumulate over time.
- Flow: capture lands in `inbox.org` (todo) or meeting notes; review and refile actionable items into `projects/<name>.org` via `, r` / `C-c C-w`.
- Refile completion is flat (`org-outline-path-complete-in-steps nil`) and includes the file prefix (`org-refile-use-outline-path 'file`) so vertico/orderless can fuzzy-match across files.
- New project files: put a top-level `* Tasks` (or similar) heading in a new `projects/<name>.org`; `org-refile-allow-creating-parent-nodes 'confirm` lets you create missing parents on the fly.
- Full-text search across every note (including meetings/journals) remains available via `SPC f g` (`consult-ripgrep`).
- Consult-backed leader commands must use local wrapper commands with built-in fallbacks, so startup remains usable if package bootstrap cannot install `consult`.
