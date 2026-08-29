;;; my-environment.el --- macOS and companion tools -*- lexical-binding: t; -*-

(require 'seq)

(setq mac-command-modifier 'super
      mac-option-modifier 'meta
      mac-right-option-modifier nil
      ns-command-modifier 'super
      ns-option-modifier 'meta
      ns-right-option-modifier nil
      ns-use-native-fullscreen t
      delete-by-moving-to-trash t
      select-enable-clipboard t
      select-enable-primary nil)

(use-package exec-path-from-shell
  :ensure nil
  :if (package-installed-p 'exec-path-from-shell)
  :config
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))

(when (display-graphic-p)
  (context-menu-mode -1))

(unless (display-graphic-p)
  (defun my/pbcopy ()
    "Copy the newest kill to the macOS clipboard."
    (interactive)
    (let ((text (current-kill 0 t)))
      (with-temp-buffer
        (insert text)
        (call-process-region (point-min) (point-max) "pbcopy"))))

  (defun my/pbpaste ()
    "Insert the macOS clipboard and add it to the kill ring."
    (interactive)
    (let ((text (shell-command-to-string "pbpaste")))
      (kill-new text)
      (insert text)))

  (global-set-key (kbd "M-w")
                  (lambda ()
                    (interactive)
                    (call-interactively #'kill-ring-save)
                    (my/pbcopy)))
  (global-set-key (kbd "C-w")
                  (lambda ()
                    (interactive)
                    (call-interactively #'kill-region)
                    (my/pbcopy)))
  (global-set-key (kbd "C-y") #'my/pbpaste))

(defun my/environment--file-digest (path)
  "Return a SHA-256 digest for PATH, or nil when PATH is absent."
  (when (file-readable-p path)
    (with-temp-buffer
      (insert-file-contents-literally path)
      (secure-hash 'sha256 (current-buffer)))))

(defun my/environment--conflict-files ()
  "Return likely sync conflict files below `my/org-dir'."
  (when (file-directory-p my/org-dir)
    (condition-case nil
        (directory-files-recursively
         my/org-dir
         "\\(conflicted copy\\|conflict copy\\|冲突\\)"
         nil nil)
      (file-error nil))))

(defun my/environment--insert-check (state name detail)
  "Insert one environment check with STATE, NAME, and DETAIL."
  (insert (format "%-7s %-24s %s\n" state name detail)))

(defun my/check-environment ()
  "Show a read-only report for Emacs and its companion tools."
  (interactive)
  (let* ((buffer (get-buffer-create "*Emacs Config Check*"))
         (beorg-file (expand-file-name "init.org" my/org-dir))
         (sample-file (expand-file-name "beorg-init.sample.org" my/config-root))
         (conflicts (my/environment--conflict-files)))
    (with-current-buffer buffer
      (let ((inhibit-read-only t))
        (erase-buffer)
        (insert "Emacs configuration check\n\n")
        (my/environment--insert-check
         (if (version<= "30" emacs-version) "PASS" "FAIL")
         "Emacs version" emacs-version)
        (dolist (tool '("rg" "pandoc" "pbcopy" "pbpaste"))
          (let ((path (executable-find tool)))
            (my/environment--insert-check
             (if path "PASS" "WARN") tool (or path "not found"))))
        (let ((spell (or (executable-find "aspell")
                         (executable-find "ispell"))))
          (my/environment--insert-check
           (if spell "PASS" "WARN") "spell checker" (or spell "not found")))
        (if (not (display-graphic-p))
            (my/environment--insert-check
             "MANUAL" "font" "Run this check in a graphical Emacs frame.")
          (let* ((configured
                  (and my/font
                       (not (string-empty-p my/font))
                       (find-font (font-spec :name my/font))
                       my/font))
                 (fallback
                  (seq-find (lambda (font) (find-font (font-spec :name font)))
                            '("JetBrains Mono" "SF Mono" "Menlo")))
                 (selected (or configured fallback)))
            (my/environment--insert-check
             (if selected "PASS" "WARN")
             "font" (or selected "no configured or fallback font found"))))
        (my/environment--insert-check
         (if (file-directory-p my/org-dir) "PASS" "WARN")
         "Org directory" my/org-dir)
        (my/environment--insert-check
         (if (and (file-directory-p my/org-dir)
                  (file-writable-p my/org-dir))
             "PASS" "WARN")
         "Org directory write" "This checks access, not sync status.")
        (dolist (path (list my/org-tasks my/org-ideas my/org-archive beorg-file))
          (my/environment--insert-check
           (if (file-exists-p path) "PASS" "WARN")
           (file-name-nondirectory path) path))
        (let ((actual (my/environment--file-digest beorg-file))
              (sample (my/environment--file-digest sample-file)))
          (my/environment--insert-check
           (cond ((not actual) "MANUAL")
                 ((equal actual sample) "PASS")
                 (t "INFO"))
           "beorg sample"
           (cond ((not actual) "Copy and review the sample if you use beorg.")
                 ((equal actual sample) "init.org matches the tracked sample.")
                 (t "init.org differs; review it, but do not overwrite it blindly."))))
        (my/environment--insert-check
         (if conflicts "WARN" "PASS")
         "Sync conflict files"
         (if conflicts
             (mapconcat #'abbreviate-file-name conflicts ", ")
           "none found"))
        (insert "\nMANUAL checks\n")
        (insert "- Check the beorg app version and Dropbox account on the phone.\n")
        (insert "- Check the beorg sync folder and default capture template.\n")
        (insert "- This report cannot prove that Dropbox has finished syncing.\n")
        (goto-char (point-min))
        (special-mode)))
    (pop-to-buffer buffer)))

(provide 'my-environment)
;;; my-environment.el ends here
