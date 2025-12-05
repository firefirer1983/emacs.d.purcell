;;; init-tailwindcss.el --- Measure startup and require times -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(add-to-list 'eglot-server-programs
             '((css-mode web-mode typescript-ts-mode) "tailwindcss-language-server" "--stdio"))

(provide 'init-tailwindcss)
;;; init-tailwindcss.el ends here
