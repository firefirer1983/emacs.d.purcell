;;; init-lsp.el --- vue programming support  editing -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


(provide 'init-lsp)

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

;; ;; 2. 配置 lsp-mode 核心
(use-package lsp-mode
  :hook ((web-mode . lsp-deferred)) ; 当打开 .vue 文件时延迟启动 lsp
  :commands (lsp lsp-deferred)
  :config
  ;; 针对 Vue 3 (Volar v2+) 启用必要的 Hybrid 模式与 Add-on 机制
  (add-to-list 'lsp-language-id-configuration '(".*\\.mjs$" . "javascript"))
  (setq lsp-enable-text-document-color nil)
  (lsp-enable-which-key-integration t)
  (setq-default lsp-enable-indentation nil)
  (lsp-register-custom-settings
   '(("volar.inlayHints.missingArguments" t))))


(use-package emmet-mode
  :hook ((web-mode . emmet-mode))
  :ensure t)


;;; init-lsp.el ends here
