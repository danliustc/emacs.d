;;; my-keybindings.el --- Small Spacemacs-style key map -*- lexical-binding: t; -*-

(declare-function evil-define-key* "evil-core" (state keymap key def &rest bindings))

(defvar org-mode-map)
(defvar org-agenda-mode-map)
(defvar dired-mode-map)
(defvar dired-sidebar-mode-map)
(defvar help-mode-map)
(declare-function org-agenda-todo "org-agenda" ())
(declare-function org-agenda-schedule "org-agenda" (&optional arg))
(declare-function org-agenda-deadline "org-agenda" (&optional arg))
(declare-function org-agenda-refile "org-agenda" (&optional goto rfloc no-update))
(declare-function consult-yank-pop "consult" (&optional arg))
(declare-function consult-buffer "consult" (&optional sources))
(declare-function consult-line "consult" (&optional initial start))
(declare-function embark-act "embark" (&optional arg))
(declare-function embark-dwim "embark" (&optional arg))
(declare-function embark-bindings "embark" (global))
(declare-function dired-sidebar-find-file "dired-sidebar" (&optional dir))
(declare-function dired-sidebar-hide-sidebar "dired-sidebar" ())

(defvar-keymap my/leader-file-map
  :doc "File commands under the leader key.")
(keymap-set my/leader-file-map "f" #'find-file)
(keymap-set my/leader-file-map "r" #'my/open-recent-file)
(keymap-set my/leader-file-map "s" #'save-buffer)
(keymap-set my/leader-file-map "t" #'my/toggle-file-sidebar)

(defvar-keymap my/leader-buffer-map
  :doc "Buffer commands under the leader key.")
(keymap-set my/leader-buffer-map "b" #'my/switch-buffer)
(keymap-set my/leader-buffer-map "d" #'kill-current-buffer)

(defvar-keymap my/leader-search-map
  :doc "Search commands under the leader key.")
(keymap-set my/leader-search-map "p" #'my/search-ripgrep)
(keymap-set my/leader-search-map "s" #'my/search-buffer)

(defvar-keymap my/leader-jump-map
  :doc "Jump commands under the leader key.")
(keymap-set my/leader-jump-map "i" #'my/jump-outline)

(defvar-keymap my/leader-project-map
  :doc "Project commands under the leader key.")
(keymap-set my/leader-project-map "p" #'project-switch-project)
(keymap-set my/leader-project-map "f" #'project-find-file)

(defvar-keymap my/leader-window-map
  :doc "Window commands under the leader key.")
(keymap-set my/leader-window-map "h" #'windmove-left)
(keymap-set my/leader-window-map "j" #'windmove-down)
(keymap-set my/leader-window-map "k" #'windmove-up)
(keymap-set my/leader-window-map "l" #'windmove-right)
(keymap-set my/leader-window-map "v" #'split-window-right)
(keymap-set my/leader-window-map "s" #'split-window-below)
(keymap-set my/leader-window-map "d" #'delete-window)
(keymap-set my/leader-window-map "=" #'balance-windows-area)
(keymap-set my/leader-window-map "u" #'winner-undo)

(defvar-keymap my/leader-describe-map
  :doc "Describe keys, functions, and variables.")
(keymap-set my/leader-describe-map "k" #'describe-key)
(keymap-set my/leader-describe-map "f" #'describe-function)
(keymap-set my/leader-describe-map "v" #'describe-variable)
(defvar-keymap my/leader-help-map)
(keymap-set my/leader-help-map "d" my/leader-describe-map)

(defvar-keymap my/leader-org-map
  :doc "Org commands under the applications prefix.")
(keymap-set my/leader-org-map "c" #'org-capture)
(keymap-set my/leader-org-map "o" #'org-agenda)

(defvar-keymap my/leader-application-map
  :doc "Application commands under the leader key.")
(keymap-set my/leader-application-map "o" my/leader-org-map)

(defvar-keymap my/leader-usage-map
  :doc "Local command usage statistics and review snapshots.")
(keymap-set my/leader-usage-map "s" #'my/usage-show)
(keymap-set my/leader-usage-map "e" #'my/usage-snapshot)
(keymap-set my/leader-application-map "u" my/leader-usage-map)

(defvar-keymap my/leader-map
  :doc "Minimal Spacemacs-style global leader map.")
(keymap-set my/leader-map "SPC" #'execute-extended-command)
(keymap-set my/leader-map "TAB" #'my/alternate-buffer)
(keymap-set my/leader-map "<tab>" #'my/alternate-buffer)
(keymap-set my/leader-map "f" my/leader-file-map)
(keymap-set my/leader-map "b" my/leader-buffer-map)
(keymap-set my/leader-map "s" my/leader-search-map)
(keymap-set my/leader-map "j" my/leader-jump-map)
(keymap-set my/leader-map "p" my/leader-project-map)
(keymap-set my/leader-map "a" my/leader-application-map)
(keymap-set my/leader-map "w" my/leader-window-map)
(keymap-set my/leader-map "h" my/leader-help-map)

(defvar-keymap my/org-toggle-leader-map)
(keymap-set my/org-toggle-leader-map "T" #'org-todo)
(defvar-keymap my/org-date-leader-map)
(keymap-set my/org-date-leader-map "s" #'org-schedule)
(keymap-set my/org-date-leader-map "d" #'org-deadline)
(defvar-keymap my/org-subtree-leader-map)
(keymap-set my/org-subtree-leader-map "r" #'org-refile)
(keymap-set my/org-subtree-leader-map "A" #'org-archive-subtree)
(keymap-set my/org-subtree-leader-map "n" #'org-narrow-to-subtree)
(keymap-set my/org-subtree-leader-map "w" #'widen)
(defvar-keymap my/org-local-leader-map
  :doc "Minimal Org local leader map.")
(keymap-set my/org-local-leader-map "T" my/org-toggle-leader-map)
(keymap-set my/org-local-leader-map "d" my/org-date-leader-map)
(keymap-set my/org-local-leader-map "s" my/org-subtree-leader-map)
;; Preserve Org's original Meta-Return behind the Spacemacs local leader.
(keymap-set my/org-local-leader-map "M-RET" #'org-meta-return)
(keymap-set my/org-local-leader-map "M-<return>" #'org-meta-return)

(defvar-keymap my/org-agenda-toggle-leader-map)
(keymap-set my/org-agenda-toggle-leader-map "T" #'org-agenda-todo)
(defvar-keymap my/org-agenda-date-leader-map)
(keymap-set my/org-agenda-date-leader-map "s" #'org-agenda-schedule)
(keymap-set my/org-agenda-date-leader-map "d" #'org-agenda-deadline)
(defvar-keymap my/org-agenda-subtree-leader-map)
(keymap-set my/org-agenda-subtree-leader-map "r" #'org-agenda-refile)
(defvar-keymap my/org-agenda-local-leader-map
  :doc "Minimal Org Agenda local leader map.")
(keymap-set my/org-agenda-local-leader-map "T" my/org-agenda-toggle-leader-map)
(keymap-set my/org-agenda-local-leader-map "d" my/org-agenda-date-leader-map)
(keymap-set my/org-agenda-local-leader-map "s" my/org-agenda-subtree-leader-map)

(defvar-keymap my/org-leader-root-map)
(set-keymap-parent my/org-leader-root-map my/leader-map)
(keymap-set my/org-leader-root-map "m" my/org-local-leader-map)

(defvar-keymap my/org-agenda-leader-root-map)
(set-keymap-parent my/org-agenda-leader-root-map my/leader-map)
(keymap-set my/org-agenda-leader-root-map "m" my/org-agenda-local-leader-map)

(keymap-global-set "M-m" my/leader-map)

;; Keep all non-leader custom bindings here as well. Optional packages retain
;; the native bindings when unavailable.
(when (package-installed-p 'consult)
  (keymap-global-set "M-y" #'consult-yank-pop)
  (keymap-global-set "C-x b" #'consult-buffer)
  (keymap-global-set "C-s" #'consult-line))
(when (package-installed-p 'embark)
  (keymap-global-set "C-." #'embark-act)
  (keymap-global-set "C-;" #'embark-dwim)
  (keymap-global-set "C-h B" #'embark-bindings))

(with-eval-after-load 'org
  (define-key org-mode-map (kbd "M-m") my/org-leader-root-map)
  (define-key org-mode-map (kbd "C-M-m") my/org-local-leader-map)
  (define-key org-mode-map (kbd "M-<return>") my/org-local-leader-map))
(with-eval-after-load 'org-agenda
  (define-key org-agenda-mode-map (kbd "M-m") my/org-agenda-leader-root-map)
  (define-key org-agenda-mode-map (kbd "C-M-m") my/org-agenda-local-leader-map)
  (define-key org-agenda-mode-map (kbd "M-<return>") my/org-agenda-local-leader-map))

;; These callbacks already wait for each keymap, so no deferred Evil macro is needed.
(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "SPC") my/leader-map)
  (define-key evil-motion-state-map (kbd "SPC") my/leader-map)
  (define-key evil-visual-state-map (kbd "SPC") my/leader-map)
  (with-eval-after-load 'org
    (evil-define-key* '(normal motion visual) org-mode-map
      (kbd "SPC") my/org-leader-root-map
      (kbd ",") my/org-local-leader-map))
  (with-eval-after-load 'org-agenda
    (evil-define-key* '(normal motion visual) org-agenda-mode-map
      (kbd "SPC") my/org-agenda-leader-root-map
      (kbd ",") my/org-agenda-local-leader-map)
    (evil-define-key* 'motion org-agenda-mode-map
      (kbd "M-RET") #'org-agenda-show-and-scroll-up
      (kbd "M-<return>") #'org-agenda-show-and-scroll-up))
  (with-eval-after-load 'dired
    (evil-define-key* 'motion dired-mode-map
      (kbd "j") #'dired-next-line
      (kbd "k") #'dired-previous-line
      (kbd "RET") #'dired-find-file
      (kbd "q") #'quit-window))
  (with-eval-after-load 'dired-sidebar
    (evil-define-key* 'motion dired-sidebar-mode-map
      (kbd "j") #'dired-next-line
      (kbd "k") #'dired-previous-line
      (kbd "RET") #'dired-sidebar-find-file
      (kbd "q") #'dired-sidebar-hide-sidebar))
  (with-eval-after-load 'help-mode
    (evil-define-key* 'motion help-mode-map
      (kbd "j") #'next-line
      (kbd "k") #'previous-line
      (kbd "RET") #'push-button
      (kbd "q") #'quit-window))
  (with-eval-after-load 'org-agenda
    (evil-define-key* 'motion org-agenda-mode-map
      (kbd "j") #'org-agenda-next-line
      (kbd "k") #'org-agenda-previous-line
      (kbd "RET") #'org-agenda-switch-to
      (kbd "q") #'org-agenda-quit)))

(when (fboundp 'which-key-add-keymap-based-replacements)
  (which-key-add-keymap-based-replacements my/leader-map
    "f" "files" "b" "buffers" "s" "search"
    "j" "jump" "p" "projects" "a" "applications"
    "w" "windows" "h" "help")
  (which-key-add-keymap-based-replacements my/leader-help-map "d" "describe")
  (which-key-add-keymap-based-replacements my/leader-application-map
    "o" "org" "u" "usage")
  (which-key-add-keymap-based-replacements my/org-leader-root-map "m" "major mode")
  (which-key-add-keymap-based-replacements my/org-agenda-leader-root-map "m" "major mode")
  (which-key-add-keymap-based-replacements my/org-local-leader-map
    "T" "toggle" "d" "dates" "s" "subtrees")
  (which-key-add-keymap-based-replacements my/org-agenda-local-leader-map
    "T" "toggle" "d" "dates" "s" "subtrees"))

(provide 'my-keybindings)
;;; my-keybindings.el ends here
