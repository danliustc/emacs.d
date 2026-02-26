(require 'ert)

(defconst repo-root
  (file-name-directory
   (directory-file-name
    (file-name-directory (or load-file-name buffer-file-name)))))

(defun repo-file (name)
  (expand-file-name name repo-root))

(defun file-content (name)
  (with-temp-buffer
    (insert-file-contents (repo-file name))
    (buffer-string)))

(ert-deftest config-org-should-exist ()
  (should (file-exists-p (repo-file "config.org"))))

(ert-deftest init-should-load-config-org ()
  (let ((content (file-content "init.el")))
    (should (string-match-p "org-babel-load-file" content))
    (should (string-match-p "config\\.org" content))))

(ert-deftest config-should-enable-evil-and-jk-escape ()
  (let ((content (file-content "config.org")))
    (should (string-match-p "evil-mode" content))
    (should (or (string-match-p "key-chord-define" content)
                (string-match-p "jk.*escape\\|escape.*jk" content)))))

(ert-deftest config-should-have-project-and-statusline ()
  (let ((content (file-content "config.org")))
    (should (or (string-match-p "projectile-mode" content)
                (string-match-p "project-switch-project" content)
                (string-match-p "project\\.el" content)))
    (should (string-match-p "mode-line-format" content))
    (should-not (string-match-p "doom-modeline-mode" content))))

(ert-deftest config-should-support-org-and-markdown ()
  (let ((content (file-content "config.org")))
    (should (string-match-p "org-mode" content))
    (should (string-match-p "org-cycle" content))
    (should (or (string-match-p "markdown" content)
                (string-match-p "\\.md\\'" content)))))

(ert-deftest legacy-lisp-modules-should-be-removed ()
  (should-not (file-directory-p (repo-file "lisp"))))

(ert-deftest config-should-auto-install-missing-packages ()
  (let ((content (file-content "config.org")))
    (should (string-match-p "my/install-missing-packages" content))
    (should (string-match-p "my/auto-install-packages" content))
    (should (string-match-p "when my/auto-install-packages" content))))

(ert-deftest config-should-enable-space-style-keybindings ()
  (let ((content (file-content "config.org")))
    (should (string-match-p "general" content))
    (should (string-match-p "which-key" content))
    (should (string-match-p ":prefix \"SPC\"" content))
    (should (string-match-p ":prefix \",\"" content))
    (should (string-match-p "\"f f\" #'find-file" content))
    (should (string-match-p "\"f r\" #'recentf-open-files" content))
    (should (string-match-p "\"p p\" #'my/projectile-switch-project-recent" content))
    (should (string-match-p "\"p d\" #'projectile-dired" content))
    (should (string-match-p "\"w /\" #'split-window-right" content))))

(ert-deftest config-should-limit-recent-project-list-to-five ()
  (let ((content (file-content "config.org")))
    (should (string-match-p "defun my/projectile-switch-project-recent" content))
    (should (string-match-p "seq-take ordered-projects 5" content))
    (should (string-match-p "minibuffer-with-setup-hook" content))
    (should (string-match-p "minibuffer-completion-help" content))))

(ert-deftest config-should-prompt-recent-files-after-project-selection ()
  (let ((content (file-content "config.org")))
    (should (string-match-p "defun my/projectile-find-recent-file-in-project" content))
    (should (string-match-p "seq-take (projectile-recently-active-files) 8" content))
    (should (string-match-p "my/projectile-find-recent-file-in-project project-root" content))
    (should (string-match-p "let ((projectile-switch-project-action #'ignore))" content))))

(ert-deftest config-should-have-local-leader-for-main-modes ()
  (let ((content (file-content "config.org")))
    (should (string-match-p ":keymaps 'org-mode-map" content))
    (should (string-match-p ":keymaps 'markdown-mode-map" content))
    (should (string-match-p ":keymaps 'prog-mode-map" content))
    (should (string-match-p "\"t\" #'org-todo" content))
    (should (string-match-p "\"h\" #'markdown-insert-header-dwim" content))
    (should (string-match-p "\"g\" #'xref-find-definitions" content))))

(ert-deftest config-should-set-macos-modifiers ()
  (let ((content (file-content "config.org")))
    (should (string-match-p "mac-command-modifier" content))
    (should (string-match-p "mac-option-modifier" content))))

(ert-deftest config-should-set-ayu-theme-and-larger-font ()
  (let ((content (file-content "config.org")))
    (should (string-match-p "ayu-theme" content))
    (should (string-match-p "load-theme 'ayu-light t" content))
    (should (string-match-p "set-face-attribute 'default nil :height 130" content))))
