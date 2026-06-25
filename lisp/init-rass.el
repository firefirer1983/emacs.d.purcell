;;; init-rass.el --- Configure customize local behaviour -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(maybe-require-package 'eglot-typescript-preset)
(require 'eglot-typescript-preset)

;; (maybe-require-package 'eglot-python-preset)
;; (require 'eglot-python-preset)

;; (setq eglot-python-preset-lsp-server 'rass)
;; (setq eglot-python-preset-rass-tools '(pyrefly ruff))

(setq eglot-typescript-preset-lsp-server 'rass)
(setq eglot-typescript-preset-rass-tools '(vue-language-server typescript-language-server))


(provide 'init-rass)
;;; init-rass.el ends here
