;; USAGE
;; (load "~/Programming/Pyrulis/Lisp/all-classes.lisp")
;; (all-classes)
(defun all-classes ()
  (let ((seen nil))
    (labels ((dp (class)
               (loop for c in (sb-mop:class-direct-subclasses class) do
                 (push (format nil "~a" c) seen)
                 (dp c))))
      (progn
        ;; find all classes below T
        (dp (find-class t))

        ;; show nice output
        (remove-duplicates
         (sort seen
               (lambda (x y) (string<= x y)))
         :test #'equalp)))))
