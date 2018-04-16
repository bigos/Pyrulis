;;; error fixing

(defun err-me (a b)
  (+ a b))

(defun main ()
  (format t
          "~&result ~A~%"
          (err-me 1 #\2)))

(main)
