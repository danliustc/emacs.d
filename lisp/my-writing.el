;;; my-writing.el --- Writing tools -*- lexical-binding: t; -*-

(use-package markdown-mode
  :ensure nil
  :if (package-installed-p 'markdown-mode)
  :mode ("\\.md\\'" . markdown-mode)
  :config
  (setq markdown-command "pandoc"))

(use-package flyspell
  :ensure nil
  :config
  (let ((spell-program (or (executable-find "aspell")
                           (executable-find "ispell"))))
    (when spell-program
      (setq ispell-program-name spell-program)
      (when (string-match-p "aspell\\'" spell-program)
        (setq ispell-extra-args '("--sug-mode=ultra" "--lang=en_US")))
      (add-hook 'text-mode-hook #'flyspell-mode))))

(provide 'my-writing)
;;; my-writing.el ends here
