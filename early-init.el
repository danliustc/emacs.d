;;; early-init.el --- Early startup settings -*- lexical-binding: t; -*-

;; Package activation is handled explicitly in config.org. Keeping automatic
;; startup activation off avoids loading packages before user settings are read.
(setq package-enable-at-startup nil)

;;; early-init.el ends here
