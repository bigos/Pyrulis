;;; (load "~/Programming/Pyrulis/Lisp/clpm/demo1.lisp")

(clpm-client:sync :sources '("quicklisp"))
(clpm-client:active-context "default" :activate-asdf-integration t)

(loop for s in '(:alexandria)
      do (asdf:load-system s))

(defun try-me-first ()
  (format t "Trying clpm with plist to alist: ~S~%" (alexandria:plist-alist '(1 2 3 4))))

(try-me-first)
