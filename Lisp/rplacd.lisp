(declaim (optimize (debug 3)))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria draw-cons-tree)))

(defparameter links '((b3 "+" zn_plus)
                      (b3 "-" zn_minus)
                      (b3 "d" na3)
                      (na3 "d" na3)
                      (zn_plus "d" na3)
                      (zn_minus "d" na3)))

(defparameter gr nil)

(defun link-keys (ls)
  (remove-duplicates (loop for l in ls collect (elt l 0))))

(defun build-keys (ls)
  (let ((lk (link-keys ls)))
    (setf gr (loop for l in lk collect (cons l nil)))))

(defun push-links (ls)
  (build-keys ls)
  (let ((k))
    (loop for l in ls do
      (setf k (assoc (car l) gr))
      (rplacd k (cons (cdr l) (cdr k)))
      ;; (break "gr ~A" gr)
      (format t "~A~%" k))))

;;; finally do
;; (assoc 'b3 gr)
