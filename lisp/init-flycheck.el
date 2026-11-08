;;; init-flycheck.el --- Configure Flycheck global behaviour -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(maybe-require-package 'flycheck)
(maybe-require-package 'flycheck-eglot)
(require 'flycheck)
(require 'flycheck-eglot)

;; eglot 诊断之后继续链式运行其它 checker（而不是二选一），
;; TS/Vue 缓冲区同时得到 LSP 诊断 + javascript-eslint
(setq flycheck-eglot-exclusive nil)

;; eglot 管理的缓冲区：诊断经 flycheck-eglot 接管（它会自动关闭 flymake）
(add-hook 'eglot-managed-mode-hook #'flycheck-eglot-mode)

(add-hook 'after-init-hook 'global-flycheck-mode)

;; .ts/.tsx 已被 javascript-eslint 内置支持，补上 Vue SFC
(flycheck-add-mode 'javascript-eslint 'vue-ts-mode)

;; 让项目本地的 node_modules/.bin 里的 eslint 可被找到
(maybe-require-package 'add-node-modules-path)
(dolist (hook '(typescript-mode-hook typescript-ts-mode-hook
                tsx-ts-mode-hook js-ts-mode-hook vue-ts-mode-hook))
  (add-hook hook #'add-node-modules-path))

(provide 'init-flycheck)

;;; init-flycheck.el ends here
