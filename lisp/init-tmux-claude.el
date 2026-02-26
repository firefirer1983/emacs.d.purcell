;;; init-tmux-claude.el --- Send region + prompt to tmux Claude -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; Get current tmux pane info
(defun my/tmux-current-pane ()
  "Get current tmux pane ID (e.g., '0' or '1')."
  (string-trim
   (shell-command-to-string "tmux display-message -p '#{pane_index}'")))

;; Get current tmux window index
(defun my/tmux-current-window ()
  "Get current tmux window index."
  (string-trim
   (shell-command-to-string "tmux display-message -p '#{window_index}'")))

;; Get current tmux session name
(defun my/tmux-session-name ()
  "Get current tmux session name."
  (string-trim
   (shell-command-to-string "tmux display-message -p '#{session_name}'")))

;; Find the other pane in the same window
(defun my/tmux-other-pane ()
  "Find the other pane in current tmux window (not current pane).
If there are multiple panes, prompt user to select one."
  (let* ((session (my/tmux-session-name))
         (window (my/tmux-current-window))
         (current-pane (my/tmux-current-pane))
         (output (shell-command-to-string
                  (format "tmux list-panes -t %s:%s -F '#{pane_index}'"
                          session window)))
         (panes (delq nil (mapcar (lambda (s) (unless (string= s "") s))
                                  (split-string output "\n" t))))
         (other-panes (delete current-pane panes)))
    (cond
     ((null other-panes)
      (error "No other pane found"))
     ((= (length other-panes) 1)
      (car other-panes))
     (t
      ;; Show pane numbers briefly (500ms)
      (shell-command "tmux display-panes -d 750")
      (completing-read "Select target pane: " other-panes nil t)))))

;; Send text to tmux target pane
(defun my/tmux-send-text (target-pane text)
  "Send TEXT to tmux TARGET-PANE and switch focus to that pane."
  (let* ((session (my/tmux-session-name))
         (window (my/tmux-current-window))
         (target (format "%s:%s.%s" session window target-pane))
         (cmd (format "tmux set-buffer \"%s\" && tmux paste-buffer -t '%s' && tmux select-pane -t '%s'"
                      text target target)))
    (shell-command cmd)
    (message "Sent to tmux %s" text)))

;; Core function: send region + prompt to tmux Claude
(defun my/tmux-claude-send (prompt region-text &optional file-path region-info)
  "Send PROMPT and REGION-TEXT to tmux Claude.

If FILE-PATH is provided, include it in the context.
If REGION-INFO is provided, include line numbers in the context."
  (unless (getenv "TMUX")
    (error "Not running in tmux"))
  (let* ((target-pane (my/tmux-other-pane))
         (context-header (cond
                          ((and file-path region-info)
                           (format "File: %s (%s)" file-path region-info))
                          (file-path
                           (format "File: %s" file-path))
                          (region-info
                           (format "(%s)" region-info))
                          (t "")))
         (full-text (if (and region-text (not (string= region-text "")))
                        (if (string= context-header "")
                            (format "%s\n\n---\nContext:\n%s" prompt region-text)
                          (format "%s\n\n---\n%s\nContext:\n%s" prompt context-header region-text))
                      prompt)))
    (if target-pane
        (progn
          (my/tmux-send-text target-pane full-text)
          (deactivate-mark))
      (error "No other pane found in window %s" (my/tmux-current-window)))))

;; Interactive command
(defun my/send-to-tmux-claude ()
  "Send region text with prompt to tmux Claude.

1. Get selected region as additional context
2. Read prompt from mini buffer
3. Send both to tmux Claude in the other pane"
  (interactive)
  (let* ((file-path (when buffer-file-name (abbreviate-file-name buffer-file-name)))
         (has-region (use-region-p))
         (region-beg (when has-region (region-beginning)))
         (region-end (when has-region (region-end)))
         (line-beg (when region-beg (line-number-at-pos region-beg)))
         (line-end (when region-end (line-number-at-pos region-end)))
         (region-info (if has-region
                          (format "Lines %d-%d" line-beg line-end)
                        ""))
         (region-text (if has-region
                          (buffer-substring region-beg region-end)
                        ""))
         (prompt (read-from-minibuffer "Prompt: ")))
    (my/tmux-claude-send prompt region-text file-path region-info)))

;; Simple test function
(defun my/tmux-test-send (text)
  "Test: send TEXT to other pane in current tmux window."
  (interactive "sText to send: ")
  (let* ((session (my/tmux-session-name))
         (window (my/tmux-current-window))
         (other-pane (my/tmux-other-pane))
         (target (format "%s:%s.%s" session window other-pane))
         (cmd (format "tmux set-buffer '%s' && tmux paste-buffer -t '%s'"
                      text target)))
    (shell-command cmd)
    (message "Test: sent to %s" target)))

;; Bind key
(global-set-key (kbd "C-c s") 'my/send-to-tmux-claude)

(provide 'init-tmux-claude)
;;; init-tmux-claude.el ends here
