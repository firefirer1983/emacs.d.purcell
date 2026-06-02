;;; init-crux.el --- Configure customize local behaviour -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(when (maybe-require-package 'crux)
  (require 'crux)
  (global-set-key [remap move-beginning-of-line] #'crux-move-beginning-of-line)
  (global-set-key (kbd "C-c o") #'crux-open-with)
  (global-set-key [(shift return)] #'crux-smart-open-line)
  (global-set-key (kbd "s-r") #'crux-recentf-find-file)
  (global-set-key (kbd "C-j") #'crux-kill-and-join-forward)
  (global-set-key (kbd "C-<backspace>") #'crux-kill-line-backwards)
  (global-set-key [remap kill-whole-line] #'crux-kill-whole-line)
  (global-set-key [remap keyboard-quit] #'crux-keyboard-quit-dwim))
(provide 'init-crux)
;;; init-crux.el ends here
