;;; init-pyvenv.el --- pyvenv  editing -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(maybe-require-package 'pyvenv)

(provide 'init-pyvenv)

(defun my/auto-activate-pyvenv ()
  "Activate ./venv in project root if not already active."
  (require 'pyvenv)
  (when-let* ((project-root (project-root (project-current)))
	      (venv-path (expand-file-name "venv" project-root))
	      (activate-script (expand-file-name "bin/activate" venv-path)))
    (when (and (file-exists-p activate-script)
	       (or (not (stringp pyvenv-virtual-env))
		   (not (string= (file-truename (directory-file-name venv-path))
				 (file-truename (directory-file-name pyvenv-virtual-env))))))
      (message "venv-path: %s vs pyvenv-virtual-env: %s"
	       (or venv-path "<no-venv-path>")
	       (or pyvenv-virtual-env "<not-activated>"))

      (pyvenv-activate venv-path))))

(add-hook 'python-ts-mode-hook (lambda ()
				 (my/auto-activate-pyvenv)))

;;; init-pyvenv.el ends here
