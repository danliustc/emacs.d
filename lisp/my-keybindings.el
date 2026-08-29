;;; my-keybindings.el --- Small Spacemacs-style key map -*- lexical-binding: t; -*-

(defvar org-agenda-mode-map)
(declare-function org-agenda-todo "org-agenda" ())
(declare-function org-agenda-schedule "org-agenda" (&optional arg))

(defvar-keymap my/leader-file-map
  :doc "File commands under the leader key.")
(keymap-set my/leader-file-map "f" #'find-file)
(keymap-set my/leader-file-map "r" #'my/open-recent-file)
(keymap-set my/leader-file-map "t" #'my/toggle-file-sidebar)

(defvar-keymap my/leader-buffer-map
  :doc "Buffer commands under the leader key.")
(keymap-set my/leader-buffer-map "b" #'my/switch-buffer)
(keymap-set my/leader-buffer-map "d" #'kill-current-buffer)

(defvar-keymap my/leader-search-map
  :doc "Search commands under the leader key.")
(keymap-set my/leader-search-map "p" #'my/search-ripgrep)

(defvar-keymap my/leader-jump-map
  :doc "Jump commands under the leader key.")
(keymap-set my/leader-jump-map "i" #'my/jump-outline)

(defvar-keymap my/leader-project-map
  :doc "Project commands under the leader key.")
(keymap-set my/leader-project-map "p" #'project-switch-project)

(defvar-keymap my/leader-org-map
  :doc "Org commands under the applications prefix.")
(keymap-set my/leader-org-map "c" #'org-capture)
(keymap-set my/leader-org-map "o" #'org-agenda)

(defvar-keymap my/leader-application-map
  :doc "Application commands under the leader key.")
(keymap-set my/leader-application-map "o" my/leader-org-map)

(defvar-keymap my/leader-map
  :doc "Minimal Spacemacs-style global leader map.")
(keymap-set my/leader-map "SPC" #'execute-extended-command)
(keymap-set my/leader-map "f" my/leader-file-map)
(keymap-set my/leader-map "b" my/leader-buffer-map)
(keymap-set my/leader-map "s" my/leader-search-map)
(keymap-set my/leader-map "j" my/leader-jump-map)
(keymap-set my/leader-map "p" my/leader-project-map)
(keymap-set my/leader-map "a" my/leader-application-map)

(defvar-keymap my/org-toggle-leader-map)
(keymap-set my/org-toggle-leader-map "T" #'org-todo)
(defvar-keymap my/org-date-leader-map)
(keymap-set my/org-date-leader-map "s" #'org-schedule)
(defvar-keymap my/org-local-leader-map
  :doc "Minimal Org local leader map.")
(keymap-set my/org-local-leader-map "T" my/org-toggle-leader-map)
(keymap-set my/org-local-leader-map "d" my/org-date-leader-map)

(defvar-keymap my/org-agenda-toggle-leader-map)
(keymap-set my/org-agenda-toggle-leader-map "T" #'org-agenda-todo)
(defvar-keymap my/org-agenda-date-leader-map)
(keymap-set my/org-agenda-date-leader-map "s" #'org-agenda-schedule)
(defvar-keymap my/org-agenda-local-leader-map
  :doc "Minimal Org Agenda local leader map.")
(keymap-set my/org-agenda-local-leader-map "T" my/org-agenda-toggle-leader-map)
(keymap-set my/org-agenda-local-leader-map "d" my/org-agenda-date-leader-map)

(defvar-keymap my/org-leader-root-map)
(set-keymap-parent my/org-leader-root-map my/leader-map)
(keymap-set my/org-leader-root-map "m" my/org-local-leader-map)

(defvar-keymap my/org-agenda-leader-root-map)
(set-keymap-parent my/org-agenda-leader-root-map my/leader-map)
(keymap-set my/org-agenda-leader-root-map "m" my/org-agenda-local-leader-map)

(keymap-global-set "M-m" my/leader-map)

(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "SPC") my/leader-map)
  (define-key evil-motion-state-map (kbd "SPC") my/leader-map)
  (define-key evil-visual-state-map (kbd "SPC") my/leader-map)
  (with-eval-after-load 'org
    (evil-define-key '(normal motion visual) org-mode-map
      (kbd "SPC") my/org-leader-root-map
      (kbd ",") my/org-local-leader-map)
    (define-key org-mode-map (kbd "M-m") my/org-leader-root-map)
    (define-key org-mode-map (kbd "M-<return>") my/org-local-leader-map))
  (with-eval-after-load 'org-agenda
    (evil-define-key '(normal motion visual) org-agenda-mode-map
      (kbd "SPC") my/org-agenda-leader-root-map
      (kbd ",") my/org-agenda-local-leader-map)
    (define-key org-agenda-mode-map (kbd "M-m") my/org-agenda-leader-root-map)
    (define-key org-agenda-mode-map (kbd "M-<return>")
                my/org-agenda-local-leader-map)))

(when (fboundp 'which-key-add-keymap-based-replacements)
  (which-key-add-keymap-based-replacements my/leader-map
    "f" "files" "b" "buffers" "s" "search"
    "j" "jump" "p" "projects" "a" "applications")
  (which-key-add-keymap-based-replacements my/leader-application-map "o" "org")
  (which-key-add-keymap-based-replacements my/org-leader-root-map "m" "major mode")
  (which-key-add-keymap-based-replacements my/org-agenda-leader-root-map "m" "major mode")
  (which-key-add-keymap-based-replacements my/org-local-leader-map
    "T" "toggle" "d" "dates")
  (which-key-add-keymap-based-replacements my/org-agenda-local-leader-map
    "T" "toggle" "d" "dates"))

;; Remove keys from older versions when this file is reloaded in a live session.
(dolist (key '("C-c c" "C-c a" "C-c l" "C-c s" "C-c f"
               "C-c o" "C-c t" "C-c b" "C-c m" "C-c e" "C-c g"))
  (keymap-global-unset key t))
(with-eval-after-load 'org
  (keymap-unset org-mode-map "C-c o" t))

(provide 'my-keybindings)
;;; my-keybindings.el ends here
