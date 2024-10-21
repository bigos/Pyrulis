(declaim (optimize (speed 0) (safety 3) (debug 3)))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria serapeum dot-cons-tree)))

;; (load (compile-file "~/Programming/Pyrulis/Lisp/simple-bottom-up-parsing.lisp"))

(defun dt (l)
  (dot-cons-tree:draw-graph l))

(defparameter *grammar*
  '((S (#\a A B #\e))
    (A (A #\b #\c))
    (A (#\b))
    (B (#\d))))

(defparameter *data* "abbcde")
(defun data-chars ()
  (loop for c across *data* collect c))

(defun match-replace (tree)
  (format t "-------------------- ~S~%" tree)
  (or
   (ignore-errors
    (destructuring-bind  (a (bs &rest bd) (cs &rest cd) d &rest r)  tree
      (declare (ignore r))
      (format t "999^^^^^ ~S~%" (list tree 'qqq a bs bd cs cd d))
      (when (and (equal a #\a)
                 (equal bs 'a)
                 (equal cs 'b)
                 (equal d #\e))
        (format t "888^^^^^ ~S~%" (list tree 'qqq a bs bd cs cd d))
        (cons (list 's a (list bs bd) (list cs cd) d) (nthcdr 4 tree)))))

   (ignore-errors
    (destructuring-bind ((as ad) b c &rest r) tree
      (declare (ignore r))
      (format t "!!!^^^^^ ~S~%" (list tree 'qqq as ad b c))
      (when (and (equal as 'a)
                 (equal b #\b)
                 (equal c #\c))
        (format t "^^^^^ ~S~%" (list tree 'qqq as ad b c))
        (cons (list 'a (list as ad) b c) (nthcdr 3 tree)))))

   (when (equal (car tree) #\d)
     (cons (list 'b #\d) (cdr tree)))

   (when (equal (car tree) #\b)
     (cons (list 'a #\b) (cdr tree)))))

(defun zzz (tree)
  (format t "=== ~S~%" tree)
  (let ((matched (when (consp tree)
                   (match-replace tree))))
    (if (atom tree)
        tree
        (if matched
            matched
            (progn
              (format t "ELSE  ~S !!! ~S~%" (car tree) (cdr tree))
              (cons (identity (car tree))
                    (zzz (cdr tree))))))))

(defun main ()
  (loop for r = (data-chars)
          then  (zzz r)
        for n = 1 then (1+ n)
        until (and (consp (car r))
                   (equal (caar r) 's))
        until (>= n 25)
        finally (return r)
        do
          (format t "~A>>>>>~%" n )))
