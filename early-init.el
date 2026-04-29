;;; early-init.el --- Early startup settings -*- lexical-binding: t; -*-

;; Package activation is handled explicitly in config.org. Keeping automatic
;; startup activation off avoids loading packages before user settings are read.
(setq package-enable-at-startup nil)

;; Maximize GC threshold early so the initial load runs with fewer collections.
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 16 1024 1024))))

;;; early-init.el ends here
