;;; my-ui.el --- Interface and theme -*- lexical-binding: t; -*-

(setq inhibit-startup-message t
      initial-scratch-message "stay hungry , stay foolish 🍎\n\n"
      frame-title-format '("%b — Emacs"))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(global-hl-line-mode 1)

(when (and my/font
           (not (string-empty-p my/font))
           (find-font (font-spec :name my/font)))
  (set-face-attribute 'default nil :font my/font :height my/font-size))

(unless (and my/font
             (not (string-empty-p my/font))
             (find-font (font-spec :name my/font)))
  (catch 'font-set
    (dolist (font '("JetBrains Mono" "SF Mono" "Menlo"))
      (when (find-font (font-spec :name font))
        (set-face-attribute 'default nil :font font :height my/font-size)
        (throw 'font-set font)))))

(when (display-graphic-p)
  (dolist (charset '(han cjk-misc))
    (set-fontset-font t charset (font-spec :family "PingFang SC") nil 'prepend)))

(use-package solarized-theme
  :ensure nil
  :if (package-installed-p 'solarized-theme)
  :config
  (setq solarized-use-variable-pitch nil))

(when my/theme
  (unless (ignore-errors (load-theme my/theme :no-confirm) t)
    (message "Theme %s could not be loaded; using the Emacs default" my/theme)))

(provide 'my-ui)
;;; my-ui.el ends here
