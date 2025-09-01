;;; init-local.el --- Configure customize local behaviour -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


;; 默认要用eglot
(require 'eglot)

(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))

(add-hook 'python-ts-mode-hook #'eglot-ensure)

(add-hook 'typescript-ts-mode-hook #'eglot-ensure)


;; 不要多余的行的提示导致显示错位
(remove-hook 'after-init-hook 'global-diff-hl-mode)

;; 不要屏幕忽明忽暗
(remove-hook 'after-init-hook 'dimmer-mode)

(add-hook 'shell-mode-hook #'eglot-ensure)
(global-set-key (kbd "C-x o") 'other-window)
(global-set-key (kbd "C-x C-o") 'other-window)

(global-set-key (kbd "C-j") 'join-line)

(unbind-key (kbd "C-x C-p"))
(define-key global-map (kbd "C-x C-p") project-prefix-map)

(global-set-key (kbd "C-x k") 'kill-current-buffer)
(global-set-key (kbd "C-x C-k") 'kill-current-buffer)

(global-set-key (kbd "M-?") 'xref-find-references)
;; 加快弹出框显示
(setq corfu-auto-delay 0.1)

;; 可选：设置补全菜单消失的延时（闲置多久后关闭）
(setq corfu-auto-prefix 1)

;; 函数内部不需要做颜色提示了
(setq treesit-font-lock-level 3)

(require 'material-theme)
(load-theme 'material t)

;; 默认不显示行号
(when (fboundp 'display-line-numbers-mode)
  (setq-default display-line-numbers-width 3)
  (remove-hook 'prog-mode-hook 'display-line-numbers-mode)
  (remove-hook 'yaml-mode-hook 'display-line-numbers-mode)
  (remove-hook 'yaml-ts-mode-hook 'display-line-numbers-mode))

;; 加上后会导致窗口分界线错乱
(when (boundp 'display-fill-column-indicator)
  (setq-default indicate-buffer-boundaries 'left)
  (setq-default display-fill-column-indicator-character ?┊)
  (remove-hook 'prog-mode-hook 'display-fill-column-indicator-mode))

;; 去掉很丑的红色的括号!
(when (require-package 'rainbow-delimiters)
  (remove-hook 'prog-mode-hook 'rainbow-delimiters-mode))

;; 不需要page break
(when (maybe-require-package 'page-break-lines)
  (remove-hook 'after-init-hook 'global-page-break-lines-mode)
  (with-eval-after-load 'page-break-lines
    (diminish 'page-break-lines-mode)))

;; 不需要鼠标，不然会导致putty的鼠标左右键的复制粘贴失效
(remove-hook 'after-make-console-frame-hooks 'sanityinc/console-frame-setup)

;; ===================== Treesit-Auto ==========================
(maybe-require-package 'treesit-auto)
;; 加载treesit-auto包
(require 'treesit-auto)

;; 设置自定义变量：安装语法时提示确认
(setq treesit-auto-install 'prompt)

;; 配置：为所有支持的模式添加自动模式关联
(treesit-auto-add-to-auto-mode-alist 'all)

;; 启用全局treesit-auto模式
(global-treesit-auto-mode)

;; ====================== Python Mode Hook =====================
(setq auto-mode-alist
      (append '(("SConstruct\\'" . python-ts-mode)
                ("SConscript\\'" . python-ts-mode))
              auto-mode-alist))

(provide 'init-local)

;; Program mode use subword
(add-hook 'prog-mode-hook 'subword-mode)

;;; init-local.el ends here
