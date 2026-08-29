;;; my-completion.el --- Minibuffer completion -*- lexical-binding: t; -*-

(savehist-mode 1)
(setq recentf-max-saved-items 200)
(recentf-mode 1)

(use-package vertico
  :ensure nil
  :if (package-installed-p 'vertico)
  :init
  (vertico-mode 1)
  :config
  (setq vertico-count 15
        vertico-cycle t))

(use-package orderless
  :ensure nil
  :if (package-installed-p 'orderless)
  :config
  (setq completion-styles '(orderless basic)
        completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :ensure nil
  :if (package-installed-p 'marginalia)
  :init
  (marginalia-mode 1))

(use-package consult
  :ensure nil
  :if (package-installed-p 'consult)
  :bind (("M-y" . consult-yank-pop)
         ("C-x b" . consult-buffer)
         ("C-s" . consult-line))
  :config
  (setq consult-preview-key 'any))

(use-package embark
  :ensure nil
  :if (package-installed-p 'embark)
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings))
  :config
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :ensure nil
  :if (and (package-installed-p 'embark)
           (package-installed-p 'embark-consult)
           (package-installed-p 'consult))
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(use-package which-key
  :ensure nil
  :init
  (which-key-mode 1)
  :config
  (setq which-key-idle-delay 0.5
        which-key-max-description-length 40))

(provide 'my-completion)
;;; my-completion.el ends here
