;;; init-local.el --- Configure customize local behaviour -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


;; 默认要用eglot
(require 'eglot)

(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))

(add-hook 'python-ts-mode-hook #'eglot-ensure)

(add-hook 'typescript-ts-mode-hook #'eglot-ensure)

(add-hook 'go-ts-mode-hook #'eglot-ensure)
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

;; ======================== ZOOM / UNZOOM 当前窗口 ==================
(defvar-local my-zoomed-p nil
  "记录当前窗口是否处于通过 zoom-window 触发的最大化状态.")

(defun zoom-current-window ()
  "最大化窗口或恢复之前的布局。只有处于缩放状态时才执行 winner-undo."
  (interactive)
  (if (and (one-window-p) my-zoomed-p)
      (progn
        (winner-undo)
        (setq my-zoomed-p nil))
    (progn
      (setq my-zoomed-p t)
      (delete-other-windows))))

(global-set-key (kbd "C-x z") 'zoom-current-window)
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


;; Program mode use subword
(add-hook 'prog-mode-hook 'subword-mode)

;; ======================= MC multi editing ======================
(global-unset-key (kbd "C-M-n"))
(global-set-key (kbd "C-M-n") 'mc/mark-next-like-this)

;; ====================== clipboard emacs to tmux ================
;; 纯终端环境：Emacs 复制内容自动同步到 Tmux 剪贴板

(defun my/copy-to-tmux (text)
  "Copy TEXT from Emacs to tmux clipboard."
  (when (and text (getenv "TMUX"))
    (with-temp-buffer
      (insert text)
      ;; 把 Emacs 文本写入 tmux buffer
      (call-process-region (point-min) (point-max)
                           "tmux" nil 0 nil "load-buffer" "-"))))


(setq interprogram-cut-function 'my/copy-to-tmux)

;; ====================== vertico setting ================
(add-hook 'minibuffer-setup-hook #'vertico-repeat-save)
(global-set-key (kbd "M-s p") 'vertico-repeat)

;; ===================== Python Setting ========================

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               `((python-ts-mode python-mode) . ("ty" "server"))))

;; (with-eval-after-load 'eglot
;;   (add-to-list 'eglot-server-programs
;;                `((python-ts-mode python-mode) . ("pyrefly" "lsp"))))


;; (with-eval-after-load 'eglot
;;   (add-to-list 'eglot-server-programs
;;                `((python-ts-mode python-mode) . ("basedpyright-langserver" "--stdio"))))

;; (with-eval-after-load 'eglot
;;   (add-to-list 'eglot-server-programs
;;                `((python-ts-mode python-mode) . ("pyright-langserver" "--stdio"))))

;; ==================== GO Setting ==============================
(add-hook 'go-mode-hook (lambda () (setq tab-width 4)))

;; ==================== Rust Setting ==============================
(add-hook 'rust-mode-hook 'eglot-ensure)
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               `((rust-ts-mode rust-mode) . ("rust-analyzer" :initializationOptions (:check (:command "clippy"))))))


;; ==================== Zig Setting ==============================

(add-to-list 'auto-mode-alist '("\\.\\(zig\\|zon\\)\\'" . zig-ts-mode))
(add-hook 'zig-ts-mode-hook 'eglot-ensure)
;; (with-eval-after-load 'eglot
;;   (add-to-list 'eglot-server-programs
;;                `((zig-ts-mode zig-mode) . ("zls"))))

;; ===================== C/C++ Setting ===============================
(add-to-list 'auto-mode-alist '("\\.\\(c\\|cpp\\|h\\|hpp\\)\\'" . c-ts-mode))
(add-hook 'c-ts-mode-hook 'eglot-ensure)
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((c-ts-mode c++-ts-mode) . ("clangd"))))

;; ===================== auto split window =========================
(defun minibuffer-exist-p ()
  (active-minibuffer-window))

(defun window-split-horizontally-p ()
  "Return t if the current window is split horizontally (side by side)."
  (let* ((edges (window-edges))
         (top (nth 1 edges))
         (next-window (or (window-next-sibling) (window-prev-sibling))))
    (and next-window
         (= top (nth 1 (window-edges next-window))))))

(defun window-split-vertically-p ()
  "Return t if the current window is split vertically (one above the other)."
  (let* ((edges (window-edges))
         (left (nth 0 edges))
         (next-window (or (window-next-sibling) (window-prev-sibling))))
    (and next-window
         (= left (nth 0 (window-edges next-window))))))


(defun multiple-windows-p ()
  "Return t if there is more than one window (excluding the minibuffer)."
  (> (length (window-list-1 nil 'nomini)) 1))

(defun my-auto-split-window (current-frame)
  "Automatically adjust window split based on frame width and keep the buffers."
  (let ((current-window-buffer (current-buffer)) ;; 保存当前 buffer
        (next-window-buffer (window-buffer (next-window))))
    (when (and (multiple-windows-p) (not (minibuffer-exist-p)))
      (if (< (frame-width) 154)
          (when (window-split-horizontally-p)
            (delete-other-windows)  ;; 删除其他窗口布局
            (split-window-vertically) ;; 垂直拆分
            (set-window-buffer (next-window) next-window-buffer) ;; 恢复下一个窗口的 buffer
            (switch-to-buffer current-window-buffer)) ;; 恢复当前窗口的 buffer
        (when (window-split-vertically-p)
          (delete-other-windows)
          (split-window-horizontally) ;; 水平拆分
          (set-window-buffer (next-window) next-window-buffer)
          (switch-to-buffer current-window-buffer))))))

(add-hook 'window-size-change-functions 'my-auto-split-window)


(provide 'init-local)
;;; init-local.el ends here
