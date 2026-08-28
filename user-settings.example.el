;; ~/.emacs.d/user-settings.el
;; Copy this file to user-settings.el and adjust it for the local machine.

;; Org files root directory.
;; Local:    "~/org"
;; Dropbox:  "~/Library/CloudStorage/Dropbox/orgfiles"
;;           (older Dropbox installs use "~/Dropbox/orgfiles" — check which one
;;           actually exists, the config silently creates the directory it is
;;           given and an unsynced copy looks exactly like a working one)
;; iCloud:   "~/Library/Mobile Documents/com~apple~CloudDocs/orgfiles"
(setq my/org-dir "~/org")

;; Font name. Use "" to let config.org fall back to system fonts.
(setq my/font "Iosevka")

;; Font size in 1/10 pt. 150 means 15 pt.
(setq my/font-size 150)

;; Theme (solarized-theme).
;; Light: solarized-light, solarized-light-high-contrast
;; Dark:  solarized-dark, solarized-dark-high-contrast
;; Built-in themes (modus-operandi, modus-vivendi, ...) work too.
;; nil loads no theme at all.
(setq my/theme 'solarized-light)

;; Additional agenda files for larger projects.
;; (setq my/org-extra-agenda-files
;;       '("~/org/renovation.org"
;;         "~/org/book-draft.org"))
