;;; parsiuk

(declaim (optimize (safety 2) (speed 1) (debug 3)))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(:draw-cons-tree)))

(defun dt (l)
  (declare (cons l))
  (draw-cons-tree:draw-tree l))

(defparameter *data*
  (the (SIMPLE-ARRAY CHARACTER) "123+45*56"))

(defun accelp (el)
  (or (null el)
      (characterp el)
      (consp el)
      (and (symbolp el)
           (member el '(end none)))))

(deftype accel ()
  `(satisfies accelp))

(defun valaref (data n)
  (declare ((simple-array character) data)
           (integer n))
  (when (< n (length data))
    (aref data n)))

(defun next-or-end (n)
  (declare (integer n))
  (or (valaref *data* n)
      'end))

(defun eat (n &optional acc)
  (declare (integer n)
           ((or null cons) acc))
  (if (and (> n 0)
           (null acc))
      (error "when n is above 0 acc should not be nil"))

  (format T "~A ~s~%" n acc)
  (the cons
       (if (> n (length *data*))
           acc
           (if (eq 'none (car acc))
               (eat (1+ n)
                    (cons (next-or-end n)
                          (cdr acc)))
               (eat n
                    (parse acc))))))

(defun parse (acc)
  (parse2 acc))

(defun none (a)
  (declare (ignore a))
  'none)

(defun else (a)
  (declare (ignore a))
  T)

(defun parse2 (acc)
  (or
   (shrink0 acc #'null #'none)
   (shrink1 acc
            (lambda (x) (and (characterp x)
                             (digit-char-p x)))
            (lambda (y) (list 'd (digit-char-p y))))
   (shrink1 acc
            (lambda (x) (and (consp x)
                             (eq 'd (car x))))
            (lambda (y) (list 'n (cadr y))))
   (shrink2 acc
            (lambda (a b) (and (consp a)
                               (eq 'n (car a))
                               (consp b)
                               (eq 'n (car b))))
            (lambda (x y) (list 'n (+ (* 1  (cadr x))
                                         (* 10 (cadr y))))))
   (shrink0 acc #'else #'none)))

;; (defun canth (n l)
;;   (let ((e (nth n l)))
;;     (if (consp e)
;;         (car e)
;;         e)))

;; (defun cdnth (n l)
;;   (let ((e (nth n l)))
;;     (if (consp e)
;;         (cdr e)
;;         e)))

;;;
(defun shrink0 (acc mfn pfn)
  (when (funcall mfn acc)
    (cons (funcall pfn acc)
          (nthcdr 0 acc))))

(defun shrink1 (acc mfn pfn)
  (let ((a1 (nth 0 acc)))
    (when (funcall mfn a1)
      (cons (funcall pfn a1)
            (nthcdr 1 acc)))))

(defun shrink2 (acc mfn pfn)
  (let ((a1 (nth 0 acc))
        (a2 (nth 1 acc)))
    (when (funcall mfn a1 a2)
      (cons (funcall pfn a1 a2)
            (nthcdr 2 acc)))))

(defun shrink3 (acc mfn pfn)
  (let ((a1 (nth 0 acc))
        (a2 (nth 1 acc))
        (a3 (nth 2 acc)))
    (when (funcall mfn a1 a2 a3)
      (cons (funcall pfn a1 a2 a3)
            (nthcdr 3 acc)))))
