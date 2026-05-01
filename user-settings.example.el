;; ~/.emacs.d/user-settings.el
;; Copy this file to user-settings.el and adjust it for the local machine.

;; Org files root directory.
;; Local:    "~/org"
;; Dropbox:  "~/Dropbox/orgfiles"
;; iCloud:   "~/Library/Mobile Documents/com~apple~CloudDocs/orgfiles"
(setq my/org-dir "~/org")

;; Font name. Use "" to let config.org fall back to system fonts.
(setq my/font "Iosevka")

;; Font size in 1/10 pt. 150 means 15 pt.
(setq my/font-size 150)

;; Theme.
;; Light: modus-operandi, modus-operandi-tinted
;; Dark:  modus-vivendi, modus-vivendi-tinted
(setq my/theme 'modus-operandi-tinted)

;; Additional agenda files for larger projects.
;; (setq my/org-extra-agenda-files
;;       '("~/org/renovation.org"
;;         "~/org/book-draft.org"))

;; capture-llm: DeepSeek API key for natural language capture.
;; Get your key at https://platform.deepseek.com/api_keys
(setq my/deepseek-api-key "YOUR_DEEPSEEK_API_KEY")
