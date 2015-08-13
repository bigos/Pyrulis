#! /usr/bin/sbcl --script

(format t "testing impications~%")

(defun implies (p q) (or (not p) q))

(defun verdict (p q)
  (let ((implies (implies p q)))
    (cond ((and implies p) (list T "telling the truth"))
          ((not implies)   (list NIL "LIAR"))
          (implies         (list T "innocent unless proven guilty")))))

(map 'list
     (lambda (x) (format t "~A~%" (verdict (car x) (cdr x))))
     '((T . T) (T . NIL) (NIL . T) (NIL . NIL)))
