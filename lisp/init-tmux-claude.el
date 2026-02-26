;;; init-tmux-claude.el --- Send region + prompt to tmux Claude -*- lexical-binding: t; -*-

;; 获取当前 tmux 窗口编号
(defun my/tmux-current-window ()
  "Get current tmux window index."
  (string-to-number
   (car (split-string
         (cadr (split-string (getenv "TMUX") ","))
         ":")))

;; 获取当前 tmux 会话名
(defun my/tmux-session-name ()
  "Get current tmux session name."
  (car (split-string
        (cadr (split-string (getenv "TMUX") ","))
        ":")))

;; 查找同一会话中的另一个窗口（不是当前 Emacs 所在窗口）
(defun my/tmux-other-window ()
  "Find another window in current tmux session (not current Emacs window)."
  (let* ((session (my/tmux-session-name))
         (current-win (my/tmux-current-window))
         (windows (seq-filter
                   (lambda (w)
                     (not (= (string-to-number w) current-win)))
                   (seq-mapcat
                    (lambda (line)
                      (when (string-match (format "^%s:[0-9]+\\." session) line)
                        (list (cadr (split-string line ":")))))
                    (split-string (shell-command-to-string
                                   (format "tmux list-windows -t %s -F '#{window_index}'"
                                           session))
                                  "\n" t)))))
    (car windows)))

;; 发送文本到 tmux 指定窗口
(defun my/tmux-send-text (target-window text)
  "Send TEXT to tmux TARGET-WINDOW."
  (let* ((session (my/tmux-session-name))
         (target (format "%s:%s" session target-window)))
    ;; 先发送换行确保新行
    (call-process "tmux" nil nil nil "send-keys" "-t" target "" "Enter")
    ;; 逐行发送文本
    (dolist (line (split-string text "\n" t))
      (call-process "tmux" nil nil nil "send-keys" "-t" target line "Enter"))
    (message "Sent to tmux %s: %s" target text)))

;; 核心功能：发送 region + prompt 到 tmux Claude
(defun my/tmux-claude-send (prompt region-text)
  "Send PROMPT and REGION-TEXT to tmux Claude.

If REGION-TEXT is empty, just send PROMPT.
Otherwise send PROMPT followed by the region as additional context."
  (unless (getenv "TMUX")
    (error "Not running in tmux"))
  (let* ((target-window (my/tmux-other-window))
         (full-text (if (and region-text (not (string= region-text "")))
                        (format "%s\n\n---\n附加上下文:\n%s" prompt region-text)
                      prompt)))
    (if target-window
        (my/tmux-send-text target-window full-text)
      (error "No other tmux window found in session %s" (my/tmux-session-name)))))

;; 交互式命令
(defun my/send-to-tmux-claude ()
  "Send region text with prompt to tmux Claude.

1. Get selected region as additional context
2. Read prompt from mini buffer
3. Send both to tmux Claude in the other window"
  (interactive)
  (let* ((region-text (if (use-region-p)
                          (buffer-substring (region-beginning) (region-end))
                        ""))
         (prompt (read-from-minibuffer "Prompt: ")))
    (my/tmux-claude-send prompt region-text)))

(provide 'init-tmux-claude)
;;; init-tmux-claude.el ends here
