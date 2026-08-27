# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal Emacs configuration (macOS, Emacs 29+) written as an Org literate program. It is tuned for Org/GTD, capture, and prose writing — not as an IDE. `doc/DEVELOPER.md` states the project direction, package policy, and explicit non-goals (no LSP, no modal editing, no Doom-style modules); read it before proposing structural changes. `README.md` is the Chinese-language user cheatsheet and the canonical keybinding reference.

## Source of truth

`config.org` is the only file to edit for Emacs behavior. Everything else is generated or local:

- `config.el` — tangled from `config.org`, gitignored. **Never edit by hand**; it will be overwritten.
- `custom.el` — written by Customize, gitignored.
- `user-settings.el` — machine-local, gitignored. Change `user-settings.example.el` when adding a new knob.

Tracked files are only: `config.org`, `init.el`, `early-init.el`, `user-settings.example.el`, `beorg-init.sample.org`, `README.md`, `doc/DEVELOPER.md`, `.gitignore`, `LICENSE`.

## Verifying a change

```sh
emacs --batch -l init.el          # tangles config.org, loads it; must end with "✅ Emacs 配置加载完成！"
```

`init.el` calls `org-babel-load-file`, which **only re-tangles when `config.org` is newer than `config.el`**. If a change seems not to take effect, `touch config.org` or tangle explicitly:

```sh
emacs --batch --eval '(progn (require (quote org)) (org-babel-tangle-file "config.org"))'
```

There is no test suite. `tests/config-tests.el` existed once (removed in commit `a7a688f`) and is still referenced by stale entries in `.claude/settings.local.json`; do not assume it exists.

## Load order

1. `early-init.el` — sets `package-enable-at-startup` nil (packages are activated explicitly later) and raises `gc-cons-threshold`, lowering it on `emacs-startup-hook`.
2. `init.el` — one line: `org-babel-load-file` on `config.org`.
3. `config.org` §用户设置 — loads `user-settings.el` if present, then `defvar`s defaults via `(or (bound-and-true-p my/x) default)`. GTD paths (`my/org-inbox`, `my/org-tasks`, `my/org-ideas`, `my/org-archive`) are derived from `my/org-dir`.
4. Remaining sections: package.el setup, macOS keys, UI, completion stack, Org/GTD, keybindings, capture-llm, then `custom.el`.

Adding a user-facing setting means three edits: the `defvar` fallback in §用户设置, an entry in `user-settings.example.el`, and (if user-visible) `README.md`.

## config.org conventions

- File-level `#+PROPERTY: header-args:emacs-lisp :tangle yes`. Illustrative blocks must carry `:tangle no` or they land in `config.el`.
- Third-party packages: add the symbol to `my/packages` (archives) or `my/vc-packages` (Git-only, installed with the built-in `package-vc-install`), and declare with `use-package … :ensure nil :if (package-installed-p 'pkg)`. `use-package-always-ensure` is nil on purpose — a missing package must never break a batch load, and nothing installs or hits the network during startup; `my/install-missing-packages` does that, and Emacs must be restarted afterwards for the `:if` guards to re-evaluate.
- `my/selected-packages` (= both lists) is assigned to `package-selected-packages` in §包管理 **and again in §收尾 after `custom.el` loads**, because interactive `M-x package-install` writes that variable into `custom.el`, which loads last. Do not drop the second assignment: when it was absent the value ended up nil and `M-x package-autoremove` treated every installed package as an orphan.
- `package-archive-priorities` ranks GNU > NonGNU > MELPA so stable releases win over MELPA's date-versioned snapshots. `which-key` and `use-package` are built into Emacs 30 and must not be re-added to `my/packages`.
- Commands bound to keys wrap optional packages in a fallback (`my/search-ripgrep`, `my/find-file-by-name`, `my/jump-outline`, `my/switch-buffer`, `my/toggle-file-sidebar`) so bindings work on a bare Emacs. Follow that pattern for new bindings that depend on `consult`/`embark`/`dired-sidebar`.
- Keybinding policy: personal globals under `C-c`, GTD file/workflow commands under `C-c g`. All `global-set-key` calls live in the §快捷键总览 section — keep them there rather than scattering them into package sections.
- `capture-llm` comes from GitHub (`danliustc/capture-llm`) via `my/vc-packages`. Startup only does `(require 'capture-llm nil t)` and configures the DeepSeek provider (which needs `my/deepseek-api-key` in `user-settings.el`) inside that `when` — keep it non-fatal.
- macOS: Option is Meta, Command is Super (`mac-command-modifier 'super`). Terminal Emacs gets pbcopy/pbpaste bridges; GUI uses the system clipboard directly.

## Org data lives outside this repo

Agenda/capture targets are under `my/org-dir` (typically `~/Dropbox/orgfiles`), not in `.emacs.d`. `my/gtd-initialize` runs on `emacs-startup-hook` and creates `inbox.org`, `tasks.org`, `ideas.org`, `archive.org` with their top-level headings if missing — so a config change can create or modify files in the user's Dropbox. Batch runs do this too.

The GTD model: capture → `inbox.org` → refile → `tasks.org`. Everything actionable lives in `tasks.org`; personal/work/health are **tags, not files**. TODO states are `TODO → NEXT → DONE` plus `WAITING`/`SOMEDAY`/`CANCELLED`. Do not introduce parallel file-based categorization. The iOS app beorg reads the same directory (`beorg-init.sample.org` is the template for its `init.org`), so keep TODO keywords and capture templates consistent between the two.

## Docs to keep in sync

Behavior changes that touch keybindings, capture templates, agenda views, or user settings should update `README.md` (user-facing tables, Chinese) and, when they change policy or layout, `doc/DEVELOPER.md`.
