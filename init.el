(require 'org)

(setq org-confirm-babel-evaluate nil)

(let ((local-file (expand-file-name "local.el" user-emacs-directory)))
  (when (file-exists-p local-file)
    (load local-file nil 'nomessage)))

(org-babel-load-file
 (expand-file-name "config.org" user-emacs-directory))
