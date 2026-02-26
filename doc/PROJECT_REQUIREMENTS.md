# Project Requirements and Collaboration Guide

This file defines the mandatory collaboration rules for this repository.
It is the source of truth for both human contributors and AI agents.

## 1. Product Direction

- Keep the config lightweight, stable, and easy to maintain.
- Primary workloads:
  - `org-mode` writing/planning
  - `markdown-mode` writing
  - occasional Python/C++ reading
- Editing paradigm:
  - Vim-first (`evil`)
  - Space-style key system (`SPC` + `,`)
- Explicit non-goal:
  - Do not turn this repo into a heavy full-IDE distribution unless requested.

## 2. Architecture Baseline

- `init.el`
  - bootstrap only
  - loads `config.org` via org-babel
- `config.org`
  - single source of behavior
  - tangled output is `config.el`
- `tests/config-tests.el`
  - repository-level regression checks

## 3. Platform Policy

- Primary platform is macOS.
- Modifier mapping on macOS must remain:
  - `Command -> Super`
  - `Option -> Meta`
- Any keymap change must be checked for macOS compatibility.

## 4. Keybinding Policy

- Global leader: `SPC`
- Local leader: `,`
- Keep discoverability through `which-key`.
- Keep these guaranteed entries:
  - `SPC f r` recent files
  - `SPC p p` recent project switch flow
  - `SPC p f` project file find
  - `SPC p d` project dired
- Avoid introducing conflicting global keymaps that break leader prefixes.

## 5. Org/Markdown Policy

- Org and Markdown are first-class modes and must not regress.
- Org fold keys must remain functional:
  - `TAB -> org-cycle`
  - `<backtab> -> org-shifttab`
- Keep local-leader commands for Org and Markdown.

## 6. Theme/UI Policy

- Theme direction currently uses Ayu (`ayu-light`).
- Font size is intentionally one step larger than default.
- Keep UI minimal:
  - no mandatory heavy modeline packages
  - no unnecessary visual plugin bloat

## 7. Delivery Workflow (Mandatory TDD)

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

## 8. Scope and Change Control

- Prefer small, local patches.
- Do not rewrite unrelated areas while fixing one issue.
- Do not silently change project direction (style/workflow) without explicit user request.

## 9. Validation Checklist

Before declaring done:

- config loads:
  - `emacs --batch -l init.el`
- regression tests pass:
  - `emacs --batch -l tests/config-tests.el -f ert-run-tests-batch-and-exit`
- key workflow sanity:
  - `SPC` leader works
  - `,` local leader works
  - Org `TAB` fold works

## 10. Implementation Design Standards

Use the following standards when modifying `config.org` and tests.

### 10.1 Design Principles

- Minimalism first
  - prefer built-in Emacs capability where practical
  - add packages only when they provide clear daily value
- Predictability
  - keybindings should be stable and mnemonic
  - avoid surprising mode-specific overrides
- Low maintenance
  - keep configuration understandable in one pass
  - avoid clever abstractions that hide simple behavior

### 10.2 Configuration Organization

- Keep behavior sections explicit in `config.org`:
  - Core
  - Packages
  - Theme/Font
  - Evil/Keybindings
  - Project Workflow
  - Org/Markdown
- Put related settings close together.
- Prefer small named helper functions when behavior is non-trivial.

### 10.3 Keybinding Standards

- Global interaction model:
  - `SPC` for global workflows
  - `,` for mode-local workflows
- Group naming should stay consistent:
  - `f` files
  - `b` buffers
  - `p` projects
  - `w` windows
  - `h` help
  - `q` quit/session
- New keybindings must:
  - match existing group semantics
  - avoid conflicts with Org critical keys (`TAB`, `<backtab>`)
  - remain discoverable through `which-key`

### 10.4 Package Standards

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

### 10.5 Org/Markdown UX Standards

- Org behavior prioritizes writing flow and fold reliability.
- Markdown behavior remains lightweight (edit/preview/header insert).
- Keep mode-local actions on `,` prefixes.
- Avoid noisy UI changes in writing buffers.

### 10.6 Theme/Visual Standards

- Use one active theme at startup.
- Font changes should be intentional and documented.
- If theme symbols differ by package version, choose stable names and fallback.

### 10.7 Project Navigation Standards

- Optimize common flows:
  - switch project
  - find file
  - inspect file list/tree
- For recent-project UX:
  - present constrained candidate sets when requested
  - fallback to standard Projectile behavior if list is empty

### 10.8 Testing Standards

- Tests live in `tests/config-tests.el`.
- Behavioral changes require test updates.
- Keep tests focused and avoid overfitting to unrelated formatting.

### 10.9 Error Handling Standards

- Prefer safe fallbacks over startup hard-fail.
- Typical fallback cases:
  - package missing -> skip feature with default behavior
  - empty recent list -> fallback to default selector
- Startup must remain robust in fresh environments.

## 11. Documentation Governance

- If behavior or collaboration rules change, update docs in the same change set.
- Keep docs consistent across:
  - `README.org`
  - `doc/PROJECT_REQUIREMENTS.md`
