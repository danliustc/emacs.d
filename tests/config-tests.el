;;; config-tests.el --- Tests for the Emacs configuration -*- lexical-binding: t; -*-

(require 'ert)
(require 'cl-lib)

(defconst my/test-root
  (file-name-directory
   (directory-file-name
    (file-name-directory (or load-file-name buffer-file-name)))))
(defconst my/test-user-dir (make-temp-file "emacs-config-test-" t))
(defconst my/test-org-dir (expand-file-name "org" my/test-user-dir))

(setq user-emacs-directory (file-name-as-directory my/test-user-dir)
      package-user-dir (expand-file-name "elpa" my/test-root)
      my/org-dir my/test-org-dir)

(load (expand-file-name "init.el" my/test-root) nil 'nomessage)

(add-hook 'kill-emacs-hook
          (lambda ()
            (when (file-directory-p my/test-user-dir)
              (delete-directory my/test-user-dir t)))
          t)

(ert-deftest my/modules-are-loaded ()
  (dolist (feature '(my-settings my-packages my-environment my-ui my-editing
                    my-completion my-org my-writing my-files my-keybindings))
    (should (featurep feature))))

(ert-deftest my/scratch-buffer-is-a-minimal-home-page ()
  (should inhibit-startup-message)
  (should (string-prefix-p ";; Welcome back." initial-scratch-message))
  (dolist (shortcut '("SPC b b" "SPC p p" "SPC f f"
                      "SPC a o o" "SPC a o c"))
    (should (string-match-p (regexp-quote shortcut)
                            initial-scratch-message))))

(ert-deftest my/package-list-is-authoritative ()
  (should (equal package-selected-packages my/packages))
  (setq package-selected-packages nil)
  (my/package-sync-selected)
  (should (equal package-selected-packages my/packages)))

(ert-deftest my/settings-derive-org-paths ()
  (should (equal my/org-dir my/test-org-dir))
  (should (equal my/org-tasks (expand-file-name "tasks.org" my/test-org-dir)))
  (should (equal my/org-ideas (expand-file-name "ideas.org" my/test-org-dir)))
  (should (equal my/org-archive (expand-file-name "archive.org" my/test-org-dir))))

(ert-deftest my/global-leader-bindings-match-the-contract ()
  (should (eq (lookup-key my/leader-map (kbd "SPC")) #'execute-extended-command))
  (should (eq (lookup-key my/leader-map (kbd "f f")) #'find-file))
  (should (eq (lookup-key my/leader-map (kbd "f r")) #'my/open-recent-file))
  (should (eq (lookup-key my/leader-map (kbd "f t")) #'my/toggle-file-sidebar))
  (should (eq (lookup-key my/leader-map (kbd "b b")) #'my/switch-buffer))
  (should (eq (lookup-key my/leader-map (kbd "b d")) #'kill-current-buffer))
  (should-not (lookup-key my/leader-map (kbd "b k")))
  (should (eq (lookup-key my/leader-map (kbd "s p")) #'my/search-ripgrep))
  (should (eq (lookup-key my/leader-map (kbd "p p")) #'project-switch-project))
  (should (eq (lookup-key my/leader-map (kbd "j i")) #'my/jump-outline))
  (should (eq (lookup-key my/leader-map (kbd "a o c")) #'org-capture))
  (should (eq (lookup-key my/leader-map (kbd "a o o")) #'org-agenda))
  (should (eq (lookup-key global-map (kbd "M-m")) my/leader-map)))

(ert-deftest my/org-local-leader-bindings-match-the-contract ()
  (should (eq (lookup-key my/org-local-leader-map (kbd "T T")) #'org-todo))
  (should (eq (lookup-key my/org-local-leader-map (kbd "d s")) #'org-schedule))
  (should (eq (lookup-key my/org-agenda-local-leader-map (kbd "T T"))
              #'org-agenda-todo))
  (should (eq (lookup-key my/org-agenda-local-leader-map (kbd "d s"))
              #'org-agenda-schedule)))

(ert-deftest my/evil-escape-uses-fd-when-installed ()
  (when (package-installed-p 'evil-escape)
    (should (equal evil-escape-key-sequence "fd")))
  (when (package-installed-p 'evil)
    (should (eq (lookup-key evil-normal-state-map (kbd "SPC f r"))
                #'my/open-recent-file))))

(ert-deftest my/old-global-c-c-bindings-are-absent ()
  (dolist (key '("C-c c" "C-c a" "C-c l" "C-c s" "C-c f"
                 "C-c o" "C-c t" "C-c b" "C-c m" "C-c e" "C-c g"))
    (should-not (lookup-key global-map (kbd key)))))

(ert-deftest my/org-capture-and-agenda-stay-small ()
  (should (equal (mapcar #'car org-capture-templates) '("t" "n")))
  (should (equal (nth 1 (assoc "t" org-capture-templates)) "✅ 任务"))
  (should (equal (nth 1 (assoc "n" org-capture-templates)) "💭 想法 / 笔记"))
  (require 'org-agenda)
  (should (equal (mapcar #'car org-agenda-custom-commands) '("d"))))

(ert-deftest my/org-tag-list-stays-small ()
  (should (equal org-tag-alist
                 '(("personal" . ?p)
                   ("work" . ?w)))))

(ert-deftest my/org-refile-keeps-flat-files-flat ()
  (should (eq org-refile-use-outline-path 'file))
  (should-not org-refile-allow-creating-parent-nodes)
  (should (equal org-refile-targets
                 `((,my/org-tasks :regexp . "\\`\\'")
                   (,my/org-ideas :regexp . "\\`\\'")
                   (,my/org-archive :level . 1)))))

(ert-deftest my/gtd-initialize-creates-only-the-required-shape ()
  (my/gtd-initialize)
  (dolist (path (list my/org-tasks my/org-ideas my/org-archive))
    (should (file-exists-p path)))
  (with-temp-buffer
    (insert-file-contents my/org-archive)
    (should (re-search-forward "^\\* Archived$" nil t)))
  (with-temp-buffer
    (insert-file-contents my/org-tasks)
    (should-not (re-search-forward "^\\* " nil t))))

(ert-deftest my/environment-check-is-read-only-and-clear ()
  (make-directory my/test-org-dir t)
  (let ((before (directory-files-recursively my/test-org-dir ".")))
    (cl-letf (((symbol-function 'pop-to-buffer) #'get-buffer))
      (my/check-environment))
    (should (equal before (directory-files-recursively my/test-org-dir ".")))
    (with-current-buffer "*Emacs Config Check*"
      (should (string-match-p "cannot prove that Dropbox" (buffer-string)))
      (should buffer-read-only))))

(ert-deftest my/beorg-sample-matches-the-desktop-contract ()
  (let ((sample (expand-file-name "beorg-init.sample.org" my/test-root)))
    (with-temp-buffer
      (insert-file-contents sample)
      (dolist (text '("org-todo-action-keywords"
                      "TODO" "WAITING" "SOMEDAY"
                      "org-todo-done-keywords" "DONE" "CANCELLED"
                      "org-log-into-drawer \"LOGBOOK\""
                      "org-todo-repeat-to-state \"TODO\""
                      "agenda-exclude-files '(\"init.org\" \"archive.org\")"
                      "todo-exclude-files   '(\"init.org\" \"archive.org\")"
                      "todo-default-filter \"/(state:TODO OR state:WAITING) group:state order:>priority\""
                      "beorg 3.39.0" "Save To：=tasks.org=" "Save To：=ideas.org="))
        (goto-char (point-min))
        (should (search-forward text nil t)))
      (goto-char (point-min))
      (should-not (search-forward "(set! item-templates" nil t)))))

(ert-deftest my/beorg-docs-use-the-current-official-domain ()
  (dolist (path '("beorg-init.sample.org" "doc/COMPANION-TOOLS.md"))
    (with-temp-buffer
      (insert-file-contents (expand-file-name path my/test-root))
      (should (search-forward "https://www.beorgapp.com/" nil t))
      (goto-char (point-min))
      (should-not (search-forward "https://www.beorg.app/" nil t)))))

;;; config-tests.el ends here
