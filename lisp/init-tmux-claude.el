;;; init-tmux-claude.el --- Send region + prompt to tmux Claude -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; Get current tmux info from frame parameter or env var
;; Frame parameter format (from emacsclient): "session:window:pane"
;; TMUX env var format: "/tmp/tmux-1000/default,2944363,4" (legacy, unreliable)
(defun my/tmux-parse-env ()
  "Parse tmux info from frame parameter.
Returns (cons session window)."
  ;; Get from frame parameter (set by emacsclient --frame-parameters)
  (let ((frame-tmux (frame-parameter nil 'tmux-id)))
    (when frame-tmux
      (let ((parts (split-string frame-tmux ":")))
        (when (= (length parts) 3)
          (cons (car parts)    ; session
                (cadr parts))))))) ; window


;; Get current tmux window index
(defun my/tmux-current-window ()
  "Get current tmux window index."
  (or (cdr (my/tmux-parse-env))
      (string-trim
       (shell-command-to-string "tmux display-message -p '#{window_index}'"))))

;; Get current tmux session name
(defun my/tmux-session-name ()
  "Get current tmux session name."
  (or (car (my/tmux-parse-env))
      (string-trim
       (shell-command-to-string "tmux display-message -p '#{session_name}'"))))


;; Find the other pane in the same window that is running Claude
(defun my/tmux-other-pane ()
  "Find the other pane in current tmux window running Claude (not current pane).
If there are multiple Claude panes, prompt user to select one."
  (let* ((session (my/tmux-session-name))
         (window (my/tmux-current-window))
         ;; Get pane index and command for each pane
         (output (shell-command-to-string
                  (format "tmux list-panes -t %s:%s -F '#{pane_index}|#{pane_current_command}'"
                          session window)))
         (panes-list (delq nil (mapcar (lambda (s)
                                         (unless (string= s "")
                                           (split-string s "|" t)))
                                       (split-string output "\n" t))))
         ;; Filter to only panes running Claude (case insensitive)
         (claude-panes (cl-loop for (idx cmd) in panes-list
                                when (and (stringp idx)
                                          (stringp cmd)
                                          (string-match-p (regexp-opt '("claude" "Claude") t) cmd))
                                collect idx))
         )
    (cond
     ((null claude-panes)
      (error "No Claude pane found"))
     ((= (length claude-panes) 1)
      (car claude-panes))
     (t
      ;; Show pane numbers briefly (500ms)
      (shell-command "tmux display-panes -d 750")
      (completing-read "Select Claude pane: " claude-panes nil t)))))


(my/tmux-other-pane)

;; Send text to tmux target pane
(defun my/tmux-send-text (target-pane text)
  "Send TEXT to tmux TARGET-PANE and switch focus to that pane."
  (let* ((session (my/tmux-session-name))
         (window (my/tmux-current-window))
         (target (format "%s:%s.%s" session window target-pane))
         (cmd (format "tmux set-buffer '%s' && tmux paste-buffer -t '%s' && tmux select-pane -t '%s'"
                      text target target)))
    (shell-command cmd)))


;; Core function: send region + prompt to tmux Claude
(defun my/tmux-claude-send (prompt region-text &optional file-path region-info)
  "Send PROMPT and REGION-TEXT to tmux Claude.

If FILE-PATH is provided, include it in the context.
If REGION-INFO is provided, include line numbers in the context."
  (unless (getenv "TMUX")
    (error "Not running in tmux"))
  (let* ((session (my/tmux-session-name))
         (window (my/tmux-current-window))
         (target-pane (my/tmux-other-pane))
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
      (error "No other pane found in window %s" window))))

;; Interactive command
(defun my/send-prompt-to-tmux-claude ()
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

;; Interactive command: send region to Claude for implementation
(defun my/send-inspect-req-to-tmux-claude ()
  "Send selected region to tmux Claude for inspection.

Get selected region as code to inspect and send to tmux Claude
in the other pane with a prompt to inspect the code."
  (interactive)
  (unless (use-region-p)
    (error "No region selected"))
  (let* ((file-path (when buffer-file-name (abbreviate-file-name buffer-file-name)))
         (region-beg (region-beginning))
         (region-end (region-end))
         (line-beg (line-number-at-pos region-beg))
         (line-end (line-number-at-pos region-end))
         (region-info (format "Lines %d-%d" line-beg line-end))
         (region-text (buffer-substring region-beg region-end))
         (prompt "请检查和详细解释以下代码:\n"))
    (my/tmux-claude-send prompt region-text file-path region-info)))


;; Bind key
(global-set-key (kbd "C-c '") 'my/send-prompt-to-tmux-claude)

;; Record tmux info when creating new frame (for emacsclient)

(provide 'init-tmux-claude)
;;; init-tmux-claude.el ends here
