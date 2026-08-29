;;; my-editing.el --- Editing and Evil -*- lexical-binding: t; -*-

(electric-pair-mode 1)
(show-paren-mode 1)
(global-auto-revert-mode 1)

(setq-default indent-tabs-mode nil
              tab-width 4)

(add-hook 'text-mode-hook #'visual-line-mode)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

(use-package evil
  :ensure nil
  :if (package-installed-p 'evil)
  :init
  (setq evil-want-C-u-scroll t
        evil-want-C-i-jump nil
        evil-respect-visual-line-mode t
        evil-undo-system 'undo-redo)
  :config
  (evil-mode 1)
  (dolist (mode '(special-mode dired-mode dired-sidebar-mode help-mode org-agenda-mode))
    (evil-set-initial-state mode 'motion))
  (with-eval-after-load 'dired
    (evil-define-key 'motion dired-mode-map
      (kbd "j") #'dired-next-line
      (kbd "k") #'dired-previous-line
      (kbd "RET") #'dired-find-file
      (kbd "q") #'quit-window))
  (with-eval-after-load 'dired-sidebar
    (evil-define-key 'motion dired-sidebar-mode-map
      (kbd "j") #'dired-next-line
      (kbd "k") #'dired-previous-line
      (kbd "RET") #'dired-sidebar-find-file
      (kbd "q") #'dired-sidebar-hide-sidebar))
  (with-eval-after-load 'help-mode
    (evil-define-key 'motion help-mode-map
      (kbd "j") #'next-line
      (kbd "k") #'previous-line
      (kbd "RET") #'push-button
      (kbd "q") #'quit-window))
  (with-eval-after-load 'org-agenda
    (evil-define-key 'motion org-agenda-mode-map
      (kbd "j") #'org-agenda-next-line
      (kbd "k") #'org-agenda-previous-line
      (kbd "RET") #'org-agenda-switch-to
      (kbd "q") #'org-agenda-quit)))

(use-package evil-escape
  :ensure nil
  :if (package-installed-p 'evil-escape)
  :after evil
  :init
  (setq-default evil-escape-key-sequence "fd")
  :config
  (evil-escape-mode 1))

(defun my/enable-delete-trailing-whitespace ()
  "Delete trailing whitespace when this buffer is saved."
  (add-hook 'before-save-hook #'delete-trailing-whitespace nil t))

(add-hook 'prog-mode-hook #'my/enable-delete-trailing-whitespace)
(add-hook 'conf-mode-hook #'my/enable-delete-trailing-whitespace)

(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups" user-emacs-directory)))
      auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-saves/" user-emacs-directory) t))
      create-lockfiles nil
      confirm-kill-emacs #'y-or-n-p
      use-short-answers t)

(make-directory (expand-file-name "backups" user-emacs-directory) t)
(make-directory (expand-file-name "auto-saves" user-emacs-directory) t)

(provide 'my-editing)
;;; my-editing.el ends here
