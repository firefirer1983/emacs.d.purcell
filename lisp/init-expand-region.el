;;; init-expand-region.el --- Configure customize local behaviour -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(when (maybe-require-package 'expand-region)
  (require 'expand-region)
  (global-set-key (kbd "C-]") 'er/expand-region)
  (global-set-key (kbd "C-c ]") 'er/contract-region)
  )

(provide 'init-expand-region)
;;; init-expand-region.el ends here
