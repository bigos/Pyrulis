(in-package :web-app-trial)

(defun app-js ()
  (parenscript:ps
    (defun greeting-callback ()
      (alert "Hello World"))))
