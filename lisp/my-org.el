;;; my-org.el --- Org and GTD workflow -*- lexical-binding: t; -*-

(defvar org-agenda-custom-commands)
(defvar org-agenda-window-setup)
(defvar org-agenda-block-separator)
(defvar org-agenda-time-grid)
(defvar org-agenda-current-time-string)
(defvar org-agenda-prefix-format)

(use-package org
  :ensure nil
  :config
  (setq org-directory my/org-dir
        org-agenda-files
        (append (list my/org-tasks my/org-ideas)
                my/org-extra-agenda-files)
        org-todo-keywords
        '((sequence "TODO(t)" "|" "DONE(d)")
          (sequence "WAITING(w@/!)" "SOMEDAY(s)" "|" "CANCELLED(c@)"))
        org-todo-keyword-faces
        '(("TODO" . (:foreground "#b45309" :weight bold))
          ("WAITING" . (:foreground "#6d28d9" :weight bold))
          ("SOMEDAY" . (:foreground "#64748b" :weight bold))
          ("DONE" . (:foreground "#15803d"))
          ("CANCELLED" . (:foreground "#6b7280" :strike-through t)))
        org-tag-alist
        '(("personal" . ?p)
          ("work" . ?w))
        org-log-done 'time
        org-log-into-drawer t
        org-archive-location (concat my/org-archive "::")
        ;; Flat files must remain selectable without offering task headings.
        org-refile-targets
        `((,my/org-tasks :regexp . "\\`\\'")
          (,my/org-ideas :regexp . "\\`\\'")
          (,my/org-archive :regexp . "\\`\\'"))
        org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps nil
        org-refile-allow-creating-parent-nodes nil
        org-capture-templates
        `(("t" "✅ 任务" entry
           (file ,my/org-tasks)
           "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n%i\n"
           :empty-lines 1)
          ("n" "💭 想法 / 笔记" entry
           (file ,my/org-ideas)
           "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n%i\n"
           :empty-lines 1))
        org-hide-emphasis-markers t
        org-pretty-entities t
        org-ellipsis " ▾"
        org-startup-indented t
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-confirm-babel-evaluate t))

(with-eval-after-load 'org-agenda
  (setq org-agenda-custom-commands
        '(("d" "📅 今天" agenda ""
           ((org-agenda-span 1)
            (org-agenda-start-day "0d")
            (org-agenda-show-all-dates nil)
            (org-agenda-start-on-weekday nil)
            (org-deadline-warning-days 0)
            (org-agenda-skip-scheduled-if-done t)
            (org-agenda-skip-deadline-if-done t)
            (org-agenda-skip-function
             '(org-agenda-skip-entry-if 'todo '("SOMEDAY" "DONE" "CANCELLED")))))
          ("t" "待办：未排期" todo "TODO"
           ((org-agenda-overriding-header "待办：未排期，已决定做")
            (org-agenda-skip-function
             '(org-agenda-skip-entry-if 'scheduled 'deadline 'timestamp))))
          ("w" "等待：需要回顾" todo "WAITING"
           ((org-agenda-overriding-header "等待：检查进展，必要时安排跟进")))
          ("s" "以后：暂未承诺" todo "SOMEDAY"
           ((org-agenda-overriding-header "以后：暂未承诺，定期回顾"))))
        org-agenda-window-setup 'current-window
        org-agenda-block-separator ?─
        org-agenda-time-grid '((daily today require-timed)
                               (800 1000 1200 1400 1600 1800 2000)
                               " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
        org-agenda-current-time-string "◀── 现在"
        org-agenda-prefix-format
        '((agenda . " %i %-12:c%?-12t% s")
          (todo . " %i %-12:c")
          (tags . " %i %-12:c")
          (search . " %i %-12:c"))))

(use-package org-superstar
  :ensure nil
  :if (package-installed-p 'org-superstar)
  :hook (org-mode . org-superstar-mode)
  :config
  (setq org-superstar-headline-bullets-list '("◉" "○" "◈" "◇" "▷")
        org-superstar-item-bullet-alist '((?- . ?•) (?* . ?◦) (?+ . ?▸))))

(defun my/gtd-file-title (path)
  "Return a readable Org title for PATH."
  (file-name-sans-extension (file-name-nondirectory path)))

(defun my/gtd-create-file (path &optional body)
  "Create PATH with a standard Org header and optional BODY."
  (unless (file-exists-p path)
    (with-temp-file path
      (insert (format "#+TITLE: %s\n#+STARTUP: overview\n\n%s"
                      (my/gtd-file-title path)
                      (or body ""))))))

(defun my/gtd-initialize ()
  "Create the three GTD files when they do not exist."
  (interactive)
  (make-directory my/org-dir t)
  (dolist (path (list my/org-tasks my/org-ideas my/org-archive))
    (my/gtd-create-file path)))

(add-hook 'emacs-startup-hook #'my/gtd-initialize)

(defun my/org-capture-enter-insert-state ()
  "Enter Evil Insert state when an Org capture or log note buffer opens."
  (when (and (bound-and-true-p evil-local-mode)
             (fboundp 'evil-insert-state))
    (evil-insert-state)))

(add-hook 'org-capture-mode-hook #'my/org-capture-enter-insert-state)
(add-hook 'org-log-buffer-setup-hook #'my/org-capture-enter-insert-state)

(provide 'my-org)
;;; my-org.el ends here
