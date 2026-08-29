;;; my-packages.el --- Package management -*- lexical-binding: t; -*-

(require 'package)

(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa" . "https://melpa.org/packages/"))
      package-archive-priorities
      '(("gnu" . 3)
        ("nongnu" . 2)
        ("melpa" . 1)))

(package-initialize)

(unless (require 'use-package nil t)
  (error "use-package is unavailable; Emacs 29 or newer is required"))

(setq use-package-always-ensure nil)

(defconst my/packages
  '(exec-path-from-shell
    solarized-theme
    vertico
    orderless
    marginalia
    consult
    embark
    embark-consult
    evil
    evil-escape
    org-superstar
    markdown-mode
    dired-sidebar)
  "Third-party packages used by this configuration.")

(defun my/package-sync-selected ()
  "Make package.el use the tracked package list."
  (setq package-selected-packages my/packages))

(my/package-sync-selected)

(defun my/install-missing-packages ()
  "Install all missing packages, then ask the user to restart Emacs."
  (interactive)
  (package-refresh-contents)
  (package-install-selected-packages t)
  (message "Packages installed. Restart Emacs to load them."))

(defun my/upgrade-packages ()
  "Upgrade installed packages, then ask the user to restart Emacs."
  (interactive)
  (package-refresh-contents)
  (package-upgrade-all)
  (message "Packages upgraded. Restart Emacs to load them."))

(provide 'my-packages)
;;; my-packages.el ends here
