;; ~/.emacs.d/user-settings.el
;; 将本文件复制为 user-settings.el，再按本机情况修改。

;; Org 文件根目录。
;; 本地目录："~/org"
;; Dropbox:  "~/Library/CloudStorage/Dropbox/orgfiles"
;;           旧版 Dropbox 可能使用 "~/Dropbox/orgfiles"。请先确认真实路径。
;;           配置会自动创建目录，因此错误路径表面上也可能看起来正常。
;; iCloud:   "~/Library/Mobile Documents/com~apple~CloudDocs/orgfiles"
(setq my/org-dir "~/org")

;; 字体名称。设为 "" 时，my-ui.el 会使用系统回退字体。
(setq my/font "Iosevka")

;; 字号单位为 1/10 pt，150 表示 15 pt。
(setq my/font-size 150)

;; 主题（solarized-theme）。
;; 亮色：solarized-light、solarized-light-high-contrast
;; 暗色：solarized-dark、solarized-dark-high-contrast
;; 也可以使用内置主题，例如 modus-operandi、modus-vivendi。
;; 设为 nil 时不加载主题。
(setq my/theme 'solarized-light)

;; 大型项目可以增加额外的 Agenda 文件。
;; (setq my/org-extra-agenda-files
;;       '("~/org/renovation.org"
;;         "~/org/book-draft.org"))
