;;; init-elpa-mirror.el --- Settings and melpa/elpa mirror for package.el -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(setq package-archives '(("gnu"    . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("nongnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                         ("melpa"  . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

(provide 'init-elpa-mirror)
;;; init-elpa-mirror.el ends here
