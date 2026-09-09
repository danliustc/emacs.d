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
      package-user-dir (or (getenv "EMACS_CONFIG_PACKAGE_DIR")
                           (expand-file-name "elpa" my/test-root))
      my/org-dir my/test-org-dir)

(load (expand-file-name "init.el" my/test-root) nil 'nomessage)

;; Tests must never read or overwrite the real system clipboard.
(setq interprogram-cut-function nil
      interprogram-paste-function nil)

(add-hook 'kill-emacs-hook
          (lambda ()
            (when (file-directory-p my/test-user-dir)
              (delete-directory my/test-user-dir t)))
          t)

(ert-deftest my/font-fallbacks-are-shared-between-ui-and-check ()
  (should (consp my/font-fallbacks))
  (should (seq-every-p #'stringp my/font-fallbacks))
  (dolist (path (mapcar (lambda (name) (expand-file-name name my/test-root))
                        '("lisp/my-ui.el" "lisp/my-environment.el")))
    (with-temp-buffer
      (insert-file-contents path)
      (should (string-match-p "my/font-fallbacks" (buffer-string)))
      (should-not (string-match-p "JetBrains Mono" (buffer-string))))))

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
  (should (equal (mapcar #'car org-agenda-custom-commands) '("d" "t" "r" "w" "s"))))

(ert-deftest my/org-tag-list-stays-small ()
  (should (equal org-tag-alist
                 '(("personal" . ?p)
                   ("work" . ?w)))))

(ert-deftest my/org-refile-keeps-flat-files-flat ()
  (should (equal org-archive-location (concat my/org-archive "::")))
  (should (eq org-refile-use-outline-path 'file))
  (should-not org-refile-allow-creating-parent-nodes)
  (should (equal org-refile-targets
                 `((,my/org-tasks :regexp . "\\`\\'")
                   (,my/org-ideas :regexp . "\\`\\'")
                   (,my/org-archive :regexp . "\\`\\'")))))

(ert-deftest my/gtd-initialize-creates-only-the-required-shape ()
  (my/gtd-initialize)
  (dolist (path (list my/org-tasks my/org-ideas my/org-archive))
    (should (file-exists-p path))
    (with-temp-buffer
      (insert-file-contents path)
      (should-not (re-search-forward "^\\* " nil t)))))

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

(ert-deftest my/org-views-separate-action-waiting-and-someday ()
  (require 'org-agenda)
  (let* ((file (make-temp-file "org-views-" nil ".org"))
         (org-agenda-files (list file))
         (org-agenda-sticky nil)
         (org-agenda-buffer-name "*Org Agenda*")
         (today (format-time-string "<%Y-%m-%d %a>"))
         (past (format-time-string "<%Y-%m-%d %a>"
                                   (time-subtract (current-time) (days-to-time 2))))
         (future (format-time-string "<%Y-%m-%d %a>"
                                     (time-add (current-time) (days-to-time 2)))))
    (unwind-protect
        (progn
          (with-temp-file file
            (insert (format
                     "* TODO PoolItem\n* WAITING WaitingItem\n* SOMEDAY LaterItem\n* TODO TodayItem\nSCHEDULED: %s\n* TODO OverdueItem\nDEADLINE: %s\n* TODO FutureItem\nDEADLINE: %s\n* WAITING FollowupItem\nSCHEDULED: %s\n* SOMEDAY StaleItem\nSCHEDULED: %s\n* DONE FinishedItem\nSCHEDULED: %s\n* CANCELLED CancelledItem\nDEADLINE: %s\n* CalendarItem\n%s\n* TODO TimestampItem\n%s\n"
                     today past future today past today today today today))
            (insert (format "* TODO PastActiveItem\n%s\n" past)))
          (dolist (view '(("d" ("TodayItem" "OverdueItem" "FollowupItem" "CalendarItem" "TimestampItem")
                          ("PoolItem" "WaitingItem" "LaterItem" "FutureItem" "StaleItem" "FinishedItem" "CancelledItem"))
                         ("t" ("PoolItem")
                          ("TodayItem" "OverdueItem" "FutureItem" "WaitingItem" "LaterItem" "TimestampItem"))
                         ("r" ("PoolItem" "TodayItem" "OverdueItem" "FutureItem" "TimestampItem" "PastActiveItem")
                          ("WaitingItem" "FollowupItem" "LaterItem" "StaleItem" "FinishedItem" "CancelledItem" "CalendarItem"))
                         ("w" ("WaitingItem" "FollowupItem") ("PoolItem" "LaterItem"))
                         ("s" ("LaterItem" "StaleItem") ("PoolItem" "WaitingItem"))))
            (save-window-excursion
              (org-agenda nil (car view))
              (with-current-buffer org-agenda-buffer-name
                (dolist (item (nth 1 view))
                  (should (string-match-p item (buffer-string))))
                (dolist (item (nth 2 view))
                  (should-not (string-match-p item (buffer-string))))))))
      (when (get-buffer org-agenda-buffer-name)
        (kill-buffer org-agenda-buffer-name))
      (when (get-file-buffer file)
        (kill-buffer (get-file-buffer file)))
      (delete-file file))))

(ert-deftest my/org-repeating-tasks-return-to-todo ()
  (dolist (state '("TODO" "WAITING"))
    (with-temp-buffer
      (org-mode)
      (let ((today (format-time-string "<%Y-%m-%d %a .+1d>"))
            (tomorrow (format-time-string "%Y-%m-%d"
                                        (time-add (current-time) (days-to-time 1)))))
        (insert (format "* %s RepeatingItem\nSCHEDULED: %s\n" state today))
        (goto-char (point-min))
        (let ((org-inhibit-logging t))
          (org-todo "DONE"))
        (should (equal (org-get-todo-state) "TODO"))
        (should (string-prefix-p (concat "<" tomorrow)
                                 (org-entry-get nil "SCHEDULED")))))))

(ert-deftest my/search-falls-back-without-ripgrep ()
  (dolist (available '(nil t))
    (let (selected)
      (cl-letf (((symbol-function 'consult-ripgrep) #'ignore)
                ((symbol-function 'executable-find)
                 (lambda (name) (and available (equal name "rg") "/mock/rg")))
                ((symbol-function 'call-interactively)
                 (lambda (command &rest _) (setq selected command))))
        (my/search-ripgrep))
      (should (eq selected (if available 'consult-ripgrep 'rgrep))))))

(ert-deftest my/terminal-clipboard-preserves-native-kill-and-yank ()
  (let ((clipboard "old external text")
        (my/environment--last-clipboard nil)
        (kill-ring nil)
        (kill-ring-yank-pointer nil)
        (save-interprogram-paste-before-kill nil)
        (interprogram-cut-function #'my/environment--clipboard-cut)
        (interprogram-paste-function #'my/environment--clipboard-paste))
    (cl-letf (((symbol-function 'call-process-region)
               (lambda (start end &rest _)
                 (setq clipboard (buffer-substring-no-properties start end))
                 0))
              ((symbol-function 'call-process)
               (lambda (&rest _) (insert clipboard) 0)))
      (with-temp-buffer
        (insert "刚删除的内容")
        (goto-char (point-min))
        (let ((last-command nil)) (kill-line))
        (should (equal clipboard "刚删除的内容"))
        (yank)
        (should (equal (buffer-string) "刚删除的内容"))
        (should (= (length kill-ring) 1))
        (erase-buffer)
        (setq clipboard "new external text")
        (yank)
        (should (equal (buffer-string) "new external text"))
        (let ((last-command 'yank)) (yank-pop 1))
        (should (equal (buffer-string) "刚删除的内容"))))))

(ert-deftest my/terminal-clipboard-failures-use-kill-ring ()
  (let ((kill-ring '("local text"))
        (kill-ring-yank-pointer nil)
        (my/environment--last-clipboard nil)
        (interprogram-cut-function #'my/environment--clipboard-cut)
        (interprogram-paste-function #'my/environment--clipboard-paste))
    (cl-letf (((symbol-function 'call-process)
               (lambda (&rest _) (insert "error output") 1))
              ((symbol-function 'call-process-region)
               (lambda (&rest _) (signal 'file-missing '("Mock missing pbcopy")))))
      (kill-new "new local text")
      (with-temp-buffer
        (yank)
        (should (equal (buffer-string) "new local text"))))))

(ert-deftest my/conflict-report-distinguishes-failure-from-empty-scan ()
  (make-directory my/test-org-dir t)
  (dolist (scenario '(empty conflict error missing))
    (let ((my/org-dir (if (eq scenario 'missing)
                          (expand-file-name "absent" my/test-user-dir)
                        my/test-org-dir)))
      (cl-letf (((symbol-function 'directory-files-recursively)
                 (lambda (&rest _)
                   (pcase scenario
                     ('error (signal 'file-error '("Mock unreadable directory")))
                     ('conflict (list (expand-file-name "tasks (conflicted copy).org"
                                                       my/org-dir)))
                     (_ nil))))
                ((symbol-function 'pop-to-buffer) #'get-buffer))
        (my/check-environment))
      (with-current-buffer "*Emacs Config Check*"
        (goto-char (point-min))
        (should (re-search-forward "^.*Sync conflict files.*$" nil t))
        (let ((line (match-string 0)))
          (should (string-prefix-p (if (eq scenario 'empty) "PASS" "WARN") line))
          (when (memq scenario '(error missing))
            (should (string-match-p "Scan incomplete:" line))
            (should-not (string-match-p "none found" line))))))))

(ert-deftest my/org-local-leader-keeps-spacemacs-meta-return ()
  (skip-unless (featurep 'evil))
  (dolist (example '(("* First" . "^\\* $")
                     ("- First" . "^- $")))
    (with-temp-buffer
      (org-mode)
      (evil-insert-state)
      (insert (car example))
      (dolist (keys '("M-<return> M-<return>" "C-M-m M-RET" "SPC m M-RET"))
        ;; SPC is a leader only outside Insert state.
        (if (string-prefix-p "SPC" keys) (evil-normal-state) (evil-insert-state))
        (should (eq (key-binding (kbd keys)) #'org-meta-return)))
      (evil-insert-state)
      (goto-char (point-max))
      (call-interactively (key-binding (kbd "M-<return> M-<return>")))
      (should (save-excursion
                (goto-char (point-min))
                (re-search-forward (cdr example) nil t))))))

(ert-deftest my/agenda-meta-return-shows-entry-in-motion-state ()
  (skip-unless (featurep 'evil))
  (require 'org-agenda)
  (with-temp-buffer
    (org-agenda-mode)
    (evil-motion-state)
    (should (eq (key-binding (kbd "M-<return>")) #'org-agenda-show-and-scroll-up))
    (should (eq (key-binding (kbd "M-RET")) #'org-agenda-show-and-scroll-up))
    (should (eq (key-binding (kbd ", T T")) #'org-agenda-todo))
    (evil-emacs-state)
    (should (eq (key-binding (kbd "M-<return> T T")) #'org-agenda-todo))
    (should (eq (key-binding (kbd "C-M-m T T")) #'org-agenda-todo))))

(ert-deftest my/org-startup-check-does-not-create-data ()
  (let* ((my/org-dir (expand-file-name "new-org-data" my/test-user-dir))
         (my/org-tasks (expand-file-name "tasks.org" my/org-dir))
         (my/org-ideas (expand-file-name "ideas.org" my/org-dir))
         (my/org-archive (expand-file-name "archive.org" my/org-dir))
         report)
    (should-not (memq #'my/gtd-initialize emacs-startup-hook))
    (should (memq #'my/org-check-data-files emacs-startup-hook))
    (cl-letf (((symbol-function 'message)
               (lambda (format-string &rest args)
                 (setq report (apply #'format format-string args)))))
      (my/org-check-data-files))
    (should (string-match-p "my/gtd-initialize" report))
    (should-not (file-exists-p my/org-dir))
    (my/gtd-initialize)
    (with-temp-file my/org-tasks (insert "* TODO Keep existing content\n"))
    (delete-file my/org-ideas)
    (my/org-check-data-files)
    (should-not (file-exists-p my/org-ideas))
    (my/gtd-initialize)
    (should (file-exists-p my/org-ideas))
    (with-temp-buffer
      (insert-file-contents my/org-tasks)
      (should (equal (buffer-string) "* TODO Keep existing content\n")))))


(ert-deftest my/org-native-leaders-work-with-or-without-evil ()
  (require 'org-agenda)
  (dolist (mode '(org-mode org-agenda-mode))
    (with-temp-buffer
      (funcall mode)
      (when (bound-and-true-p evil-local-mode) (evil-emacs-state))
      (let ((command (if (eq mode 'org-mode) #'org-todo #'org-agenda-todo)))
        (dolist (keys '("M-m m T T" "C-M-m T T" "M-<return> T T"))
          (should (eq (key-binding (kbd keys)) command)))))))

(ert-deftest my/org-terminal-meta-return-is-a-prefix ()
  (with-temp-buffer
    (org-mode)
    (when (bound-and-true-p evil-local-mode) (evil-insert-state))
    (should (equal (kbd "C-M-m") (kbd "M-RET")))
    (should (keymapp (key-binding (kbd "M-RET"))))
    (insert "* First")
    (call-interactively (key-binding (kbd "C-M-m M-RET")))
    (should (equal (buffer-string) "* First\n* "))))

(ert-deftest my/org-state-logging-matches-the-documented-scope ()
  ;; Exercise the actual note writer, including the deferred post-command step.
  (dolist (example '(("TODO" "DONE" nil t nil)
                     ("TODO" "SOMEDAY" nil nil nil)
                     ("SOMEDAY" "TODO" nil nil nil)
                     ("TODO" "WAITING" "Waiting for reply" nil t)
                     ("WAITING" "TODO" nil nil t)
                     ("TODO" "CANCELLED" "No longer needed" t t)))
    (save-window-excursion
      (with-temp-buffer
        (org-mode)
        (insert (format "* %s LogProbe\n" (nth 0 example)))
        (goto-char (point-min))
        (let ((post-command-hook nil)
              (this-command 'org-todo)
              (org-log-setup nil))
          (org-todo (nth 1 example))
          (when (memq #'org-add-log-note post-command-hook)
            (save-current-buffer
              (org-add-log-note)
              (when (nth 2 example)
                (with-current-buffer "*Org Note*"
                  (goto-char (point-max))
                  (insert (nth 2 example))
                  (org-store-log-note))))))
        (should (eq (and (org-entry-get nil "CLOSED") t) (nth 3 example)))
        (let ((text (buffer-string)))
          (should (eq (and (string-match-p ":LOGBOOK:" text) t) (nth 4 example)))
          (when (nth 4 example)
            (should (string-match-p (regexp-quote (format "State %S" (nth 1 example))) text)))
          (when (nth 2 example)
            (should (string-match-p (regexp-quote (nth 2 example)) text))))))))

;;; config-tests.el ends here
