;;; my-files.el --- Files, projects, and navigation -*- lexical-binding: t; -*-

(require 'winner)
(winner-mode 1)

(use-package dired
  :ensure nil
  :config
  (setq dired-dwim-target t
        dired-recursive-copies 'always
        dired-recursive-deletes 'always))

(use-package dired-sidebar
  :ensure nil
  :if (package-installed-p 'dired-sidebar)
  :defer t
  :config
  (setq dired-sidebar-should-follow-file t))

(defun my/search-ripgrep ()
  "Search with Consult, falling back to the built-in rgrep command."
  (interactive)
  (if (and (fboundp 'consult-ripgrep) (executable-find "rg"))
      (call-interactively #'consult-ripgrep)
    (call-interactively #'rgrep)))

(defun my/open-recent-file ()
  "Open a recent file with Consult or recentf."
  (interactive)
  (if (fboundp 'consult-recent-file)
      (call-interactively #'consult-recent-file)
    (call-interactively #'recentf-open-files)))

(defun my/search-buffer ()
  "Search the current buffer with Consult or built-in incremental search."
  (interactive)
  (if (fboundp 'consult-line)
      (call-interactively #'consult-line)
    (call-interactively #'isearch-forward)))

(defun my/alternate-buffer ()
  "Switch to the most recent other buffer in the current frame."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) t)))

(defun my/jump-outline ()
  "Jump to a heading with Consult or imenu."
  (interactive)
  (if (fboundp 'consult-outline)
      (call-interactively #'consult-outline)
    (call-interactively #'imenu)))

(defun my/switch-buffer ()
  "Switch buffers with Consult or the built-in command."
  (interactive)
  (if (fboundp 'consult-buffer)
      (call-interactively #'consult-buffer)
    (call-interactively #'switch-to-buffer)))

(defun my/toggle-file-sidebar ()
  "Toggle dired-sidebar, or open Dired when it is unavailable."
  (interactive)
  (if (fboundp 'dired-sidebar-toggle-sidebar)
      (call-interactively #'dired-sidebar-toggle-sidebar)
    (call-interactively #'dired)))

(provide 'my-files)
;;; my-files.el ends here
