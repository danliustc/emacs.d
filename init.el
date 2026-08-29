;;; init.el --- Load the Emacs configuration -*- lexical-binding: t; -*-

(defconst my/config-root
  (file-name-directory (or load-file-name buffer-file-name))
  "Root directory of this Emacs configuration.")

(add-to-list 'load-path (expand-file-name "lisp" my/config-root))

(dolist (feature '(my-settings
                   my-packages
                   my-environment
                   my-ui
                   my-editing
                   my-completion
                   my-org
                   my-writing
                   my-files
                   my-keybindings))
  (require feature))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file nil 'nomessage))

;; Customize may write its own value. The tracked package list stays in charge.
(my/package-sync-selected)

(message "Emacs configuration loaded.")

;;; init.el ends here
