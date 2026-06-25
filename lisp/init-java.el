;;; init-java.el --- Configure customize local behaviour -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(provide 'init-java)
(maybe-require-package 'java-ts-mode)
(require 'java-ts-mode)

(add-hook 'java-ts-mode-hook
          (lambda ()
            (eglot-ensure)))

(maybe-require-package 'eglot-java)
(require 'eglot-java)
;; (with-eval-after-load 'eglot
;;   (eglot-java-mode))
(with-eval-after-load 'eglot
  (require 'eglot-java))
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(java-ts-mode . ("jdtls"
                                 :initializationOptions
                                 (:settings
                                  (:java
                                   (:format
                                    (:enabled
                                     t
                                     :settings
                                     (:url
                                      "file:///home/xy/jdt-lsp/eclipse-java-google-style.xml"
                                      :profile
                                      "cay"))
                                    :settings
                                    (:url
                                     "file:///home/xy/jdt-lsp/eclipse-settings.prefs")
                                    :configuration
                                    (:runtimes
                                     [
                                      (:name "JavaSE-21"
                                             :path "/usr/lib/jvm/java-21-openjdk-amd64"
                                             :default t)
                                      ])))
                                  )))))

;;; init-java.el ends here
