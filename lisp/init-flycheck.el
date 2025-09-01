(require 'flycheck)

(require 'flycheck-eglot)
(global-flycheck-eglot-mode 1)
(add-hook 'after-init-hook 'global-flycheck-mode)
(add-hook 'eglot-managed-mode-hook (lambda () (flymake-mode -1)))
(provide 'init-flycheck)
