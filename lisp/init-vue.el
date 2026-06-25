;;; init-vue.el --- vue programming support  editing -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


(provide 'init-vue)
(maybe-require-package 'vue-mode)


(unless (package-installed-p 'vue-ts-mode)
  (package-vc-install "https://github.com/8uff3r/vue-ts-mode.git"))
(require 'vue-ts-mode)
(add-to-list 'auto-mode-alist '("\\.vue\\'" . vue-ts-mode))


;; (use-package web-mode
;;   :ensure t
;;   :mode "\\.vue\\'"
;;   :config
;;   (setq web-mode-enable-current-element-highlight t)
;;   (setq web-mode-markup-indent-offset 2)
;;   (setq web-mode-css-indent-offset 2)
;;   (setq web-mode-code-indent-offset 2))


;; ;; ;; 2. 配置 lsp-mode 核心
;; (use-package lsp-mode
;;   :hook ((web-mode . lsp-deferred)) ; 当打开 .vue 文件时延迟启动 lsp
;;   :commands (lsp lsp-deferred)
;;   :config
;;   ;; 针对 Vue 3 (Volar v2+) 启用必要的 Hybrid 模式与 Add-on 机制
;;   (lsp-enable-which-key-integration t)
;;   (lsp-register-custom-settings
;;    '(("volar.inlayHints.missingArguments" t))))



;; (if (and (require 'vue-ts-mode)
;;          (fboundp 'treesit-ready-p) (treesit-ready-p 'vue))
;;     (progn
;;       (add-to-list 'auto-mode-alist '("\\.vue\\'" . vue-ts-mode))
;;       (with-eval-after-load 'eglot
;;         (add-to-list 'eglot-server-programs `(vue-ts-mode . ("vue-language-server" "--stdio"
;;                                                              "--log-level" "verbose"
;;                                                              ))))))



;; ;; 锁死主力 TS 驱动：指定为您要求的 'ts-ls (即 typescript-language-server)
;; (setq eglot-typescript-preset-lsp-server 'ts-ls)

;; ;; 【核心触发】初始化该预设包
;; ;; 这一步会自动配置 Eglot，让它在检测到 Vue 项目时：
;; ;; 后台同时启动 vue-language-server 与 typescript-language-server 完美协作
;; (eglot-typescript-preset-setup)

;; ;; =====================================================================
;; ;; 4. 绑定钩子：打开 Vue 文件时自动秒开 Eglot
;; ;; =====================================================================

;; (add-hook 'vue-ts-mode-hook
;;           (lambda ()
;;             ;; 仅在确定当前打开的文件确实是 .vue 后缀时才强制启动 Eglot
;;             (when (string-equal "vue" (file-name-extension (or buffer-file-name "")))
;;               (eglot-ensure))))
;;; init-vue.el ends here
