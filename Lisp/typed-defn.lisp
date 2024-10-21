(declaim (optimize (speed 0) (safety 3) (debug 3)))

(defun identical (&rest args)
  args)

(defun rewrite (test source rewriter &optional (ignorer 'identical))
  (apply (if test rewriter ignorer)
         source))

(defun positive (x)
  (>= x 0))

(defun divisible-by-2 (n)
  (zerop (rem n 2)))

(deftype poseven ()
  `(and
    fixnum
    (satisfies divisible-by-2)
    (satisfies positive)))

(proclaim '(ftype (function (fixnum fixnum) poseven)  even-adder))
(defun even-adder (x y)
  (+ x y))

;;; at SAFETY 3 we have type checking
;; file:~/Programming/Lisp/lispy-experiments/typed-class-test.lisp::1
