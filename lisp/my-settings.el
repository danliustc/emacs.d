;;; my-settings.el --- User settings and paths -*- lexical-binding: t; -*-

(require 'subr-x)

(let ((settings (expand-file-name "user-settings.el" user-emacs-directory)))
  (if (file-exists-p settings)
      (load settings nil 'nomessage)
    (message "user-settings.el was not found; using defaults")))

(defvar my/org-dir "~/Dropbox/orgfiles"
  "Directory that holds the Org files shared with beorg.")
(defvar my/font "Iosevka"
  "Preferred Emacs font. An empty string enables automatic fallback.")
(defvar my/font-size 150
  "Default font height in tenths of a point.")
(defvar my/theme 'solarized-light
  "Theme to load, or nil to keep the default theme.")
(defvar my/org-extra-agenda-files nil
  "Extra files to include in Org Agenda.")

(setq my/org-dir (expand-file-name my/org-dir))

(defvar my/org-tasks (expand-file-name "tasks.org" my/org-dir))
(defvar my/org-ideas (expand-file-name "ideas.org" my/org-dir))
(defvar my/org-archive (expand-file-name "archive.org" my/org-dir))

(setq native-comp-async-report-warnings-errors nil)

(provide 'my-settings)
;;; my-settings.el ends here
