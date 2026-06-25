;;; init-yasnippet.el --- Configure customize local behaviour -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(maybe-require-package 'yasnippet)
(require 'yasnippet)
(yas-global-mode 1)
(global-set-key (kbd "M-n") 'yas-insert-snippet)
(provide 'init-yasnippet)
;;; init-yasnippet.el ends here
