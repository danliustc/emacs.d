;;; my-ui.el --- Interface and theme -*- lexical-binding: t; -*-

(setq inhibit-startup-message t
      initial-scratch-message
      (concat
       ";; Welcome back.\n"
       ";;\n"
       ";; SPC b b    继续最近的工作\n"
       ";; SPC p p    选择项目\n"
       ";; SPC f f    打开文件\n"
       ";; SPC a o o  查看任务\n"
       ";; SPC a o c  快速记录\n\n")
      frame-title-format '("%b — Emacs"))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(global-hl-line-mode 1)

(let ((font (or (and my/font
                     (not (string-empty-p my/font))
                     (find-font (font-spec :name my/font))
                     my/font)
                (seq-find (lambda (name) (find-font (font-spec :name name)))
                          my/font-fallbacks))))
  (when font
    (set-face-attribute 'default nil :font font :height my/font-size)))

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
