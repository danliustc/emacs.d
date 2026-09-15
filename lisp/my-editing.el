;;; my-editing.el --- Editing and Evil -*- lexical-binding: t; -*-

(declare-function keyfreq-show "keyfreq" (&optional major-mode-symbol))
(declare-function keyfreq-table-load "keyfreq" (table))
(defvar keyfreq-table)
(defvar keyfreq-file)
(defvar keyfreq-file-lock)
(defvar keyfreq-excluded-commands)

(defvar my/usage-directory (expand-file-name "usage/" user-emacs-directory)
  "Directory for local command counts and dated review snapshots.")

(defun my/usage-show (&optional current-mode)
  "Show command counts, restricted to the current mode with CURRENT-MODE."
  (interactive "P")
  (unless (featurep 'keyfreq)
    (user-error "Install keyfreq with M-x my/install-missing-packages and restart Emacs"))
  (keyfreq-show (when current-mode major-mode)))

(defun my/usage-snapshot ()
  "Export cumulative mode and command counts to a dated local JSON file."
  (interactive)
  (unless (featurep 'keyfreq)
    (user-error "Install keyfreq with M-x my/install-missing-packages and restart Emacs"))
  (let ((table (copy-hash-table keyfreq-table))
        (directory (expand-file-name "snapshots/" my/usage-directory))
        rows file complete)
    ;; Merge saved counts into a copy, leaving Keyfreq's unsaved delta untouched.
    (keyfreq-table-load table)
    (maphash (lambda (key count)
               (push `((mode . ,(symbol-name (car key)))
                       (command . ,(symbol-name (cdr key)))
                       (count . ,count))
                     rows))
             table)
    (setq rows (sort rows (lambda (a b)
                           (string< (concat (alist-get 'mode a) "/"
                                            (alist-get 'command a))
                                    (concat (alist-get 'mode b) "/"
                                            (alist-get 'command b))))))
    (make-directory directory t)
    (set-file-modes my/usage-directory #o700)
    (set-file-modes directory #o700)
    (setq file (make-temp-file
                (expand-file-name (format-time-string "%Y%m%dT%H%M%SZ-" nil t)
                                  directory)
                nil ".json"))
    (unwind-protect
        (progn
          (with-temp-file file
            (insert (json-serialize
                     `((schema_version . 1)
                       (captured_at . ,(format-time-string "%FT%TZ" nil t))
                       (kind . "cumulative-command-counts")
                       (counts . ,(vconcat rows)))))
            (insert "\n"))
          (setq complete t)
          (message "Usage snapshot: %s" file)
          file)
      (unless complete (delete-file file)))))

(use-package keyfreq
  :ensure nil
  :if (package-installed-p 'keyfreq)
  :config
  (setq keyfreq-file (expand-file-name "keyfreq" my/usage-directory)
        keyfreq-file-lock (expand-file-name "keyfreq.lock" my/usage-directory)
        keyfreq-excluded-commands '(self-insert-command org-self-insert-command))
  ;; Batch checks and package maintenance must not create usage or timers.
  (unless noninteractive
    (make-directory my/usage-directory t)
    (set-file-modes my/usage-directory #o700)
    (keyfreq-mode 1)
    (keyfreq-autosave-mode 1)))

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
    (evil-set-initial-state mode 'motion)))

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
      backup-by-copying t
      version-control t
      kept-new-versions 10
      kept-old-versions 2
      delete-old-versions t
      create-lockfiles t
      confirm-kill-emacs #'y-or-n-p
      use-short-answers t)

(make-directory (expand-file-name "backups" user-emacs-directory) t)
(make-directory (expand-file-name "auto-saves" user-emacs-directory) t)

(provide 'my-editing)
;;; my-editing.el ends here
