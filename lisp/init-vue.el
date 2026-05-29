;;; init-vue.el --- vue programming support  editing -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


(provide 'init-vue)

;; (add-to-list 'load-path (concat user-emacs-directory "vue-ts-mode"))
(add-to-list 'load-path "~/.emacs.d/site-lisp/vue-ts-mode/vue-ts-mode.el")
(if (and (require 'vue-ts-mode)
         (fboundp 'treesit-ready-p) (treesit-ready-p 'vue))
    (progn
      (add-to-list 'auto-mode-alist '("\\.vue\\'" . vue-ts-mode))
      (with-eval-after-load 'eglot
        (add-to-list 'eglot-server-programs '(vue-ts-mode . ("vue-language-server" "--stdio")))))
  (maybe-require-package 'vue-mode))

;;; init-vue.el ends here
