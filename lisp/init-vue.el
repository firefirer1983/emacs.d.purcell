;;; init-vue.el --- vue programming support  editing -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


(provide 'init-vue)

(unless (package-installed-p 'vue-ts-mode)
  (package-vc-install "https://github.com/8uff3r/vue-ts-mode.git"))
(require 'vue-ts-mode)

(add-hook 'vue-ts-mode-hook #'prettier-js-mode)
;; `treesit-auto' 把 .html 关联到 `html-ts-mode' 且优先于 web-mode 生效，
;; 因此在 html-ts-mode 启动后再切换回 web-mode。
;; (add-hook 'html-ts-mode-hook #'web-mode)


(add-to-list 'auto-mode-alist '("\\.js\\'" . js-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.vue\\'" . vue-ts-mode))

(add-hook 'vue-ts-mode-hook #'eglot-ensure)
(add-hook 'typescript-ts-mode-hook #'eglot-ensure)
(add-hook 'typescript-ts-mode-hook (lambda () (setq-local tab-width 2)))

(use-package web-mode
  :ensure t
  :mode ("\\.html\\'")
  :hook (web-mode . prettier-js-mode)

  :config
  (setq web-mode-enable-current-element-highlight t)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-style-padding 0)
  (setq web-mode-script-padding 0)
  )


(use-package emmet-mode
  :hook ((web-mode . emmet-mode))
  :ensure t)

(add-to-list 'eglot-server-programs
             '(vue-ts-mode . ("vue-language-server" "--stdio")))
;; (require 'eglot-typescript-preset)

;; (setopt eglot-typescript-preset-vue-lsp-server 'rass)
;; (setopt eglot-typescript-preset-vue-rass-tools
;;         '(vue-language-server tailwindcss-language-server))


;; (setopt eglot-typescript-preset-tsdk
;;         "/home/xy/.nvm/versions/node/v22.14.0/lib/node_modules/typescript/lib")


;; (add-to-list 'eglot-server-programs
;;              '((js-mode js-ts-mode tsx-ts-mode typescript-ts-mode
;;                         jtsx-jsx-mode jtsx-tsx-mode jtsx-typescript-mode)
;;                "typescript-language-server" "--stdio"))

;; (setopt eglot-typescript-preset-css-lsp-server 'rass)
;; (setopt eglot-typescript-preset-css-rass-tools
;;         '(vscode-css-language-server tailwindcss-language-server))

;;; init-vue.el ends here
