;;; init-vterm.el --- Configure customize local behaviour -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(when (maybe-require-package 'vterm)
  (with-eval-after-load 'vterm
    (setq vterm-max-scrollback 10000))
  (global-set-key (kbd "M-t") 'vterm)
  (add-hook 'vterm-mode-hook
            (lambda ()
              (setq-local confirm-kill-processes nil))))



(provide 'init-vterm)

;;; init-vterm.el ends here
