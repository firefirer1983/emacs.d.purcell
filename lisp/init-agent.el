;;; init-agent.el --- Configure customize local behaviour -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; ================================ claude code ==============================
;; 1. 添加路径并加载
(add-to-list 'load-path "~/.emacs.d/site-lisp/claude-code.el")
(require 'claude-code)

;; 3. 启用模式
(claude-code-mode 1)

;; 4. 绑定快捷键
;; 绑定主命令图到 C-c c
(global-set-key (kbd "C-c c") claude-code-command-map)

;; 5. 定义 Repeat Map (用于 C-c M 后的连续操作)
(defvar my-claude-code-map (make-sparse-keymap)
  "Keymap for repeating claude-code commands.")
(define-key my-claude-code-map (kbd "M") 'claude-code-cycle-mode)

;; 设置属性以便 repeat-mode 识别
(put 'claude-code-cycle-mode 'repeat-map 'my-claude-code-map)
(setq claude-code-terminal-backend 'vterm)

;; ============================== agent shell ===============================
(require 'acp)
(require 'agent-shell)

(setq agent-shell-anthropic-claude-environment
      (agent-shell-make-environment-variables :inherit-env t))
(provide 'init-agent)
;;; init-agent.el ends here
