;; ~/.emacs.d/user-settings.el
;; 个人配置文件 — 只改这里，config.org 不用动
;; ================================================

;; org 文件根目录
;; 本地：           "~/org"
;; Dropbox：        "~/Dropbox/orgfiles"
;; iCloud：         "~/Library/Mobile Documents/com~apple~CloudDocs/orgfiles"
(setq my/org-dir "/Users/liwei/Library/CloudStorage/Dropbox")

;; 字体名称（留空 "" 自动回退到系统字体）
(setq my/font "Iosevka")

;; 字体大小（单位 1/10pt，150 = 15pt）
(setq my/font-size 150)

;; 主题
;; 亮色：modus-operandi  modus-operandi-tinted
;; 暗色：modus-vivendi   modus-vivendi-tinted
(setq my/theme 'modus-operandi-tinted)

;; Cmd 键映射：meta（推荐）或 super
(setq my/mac-command-key 'meta)

;; 额外的 Agenda 文件（复杂项目单独建文件时用）
;; 取消注释并填入文件路径即可，支持多个
;; (setq my/org-extra-agenda-files
;;       '("~/Dropbox/orgfiles/renovation.org"
;;         "~/Dropbox/orgfiles/book-draft.org"))
