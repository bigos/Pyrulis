(in-package :web-app-trial)

(defun home-page ()
  (default-layout  (home-page-view)))

(defun faa1 ()
  (default-layout  (faa1-view)))

(defun foo1 ()
  (default-layout (foo1-view)))
