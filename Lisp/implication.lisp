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

(defun verdict2 (p q)
  (if (implies p q)
      (if p
          (list T "telling the truth")
          (list T "innocent unless proven guilty"))
      (list NIL "LIAR")))

(defun iff (p q)
  (and (implies p q) (implies q p)))

(defun formula1 (p q)
  (and (not p)
       (iff (implies p q)
            (not (and (q
                       (not p)))))))
