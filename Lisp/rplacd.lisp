(declaim (optimize (debug 3)))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria draw-cons-tree)))

(defparameter links '((b3 "+" zn_plus)
                      (b3 "-" zn_minus)
                      (b3 "d" na3)
                      (na3 "d" na3)
                      (zn_plus "d" na3)
                      (zn_minus "d" na3)))

(defparameter *gr* nil)

(defun push-links (links)
  (loop for l in links do
    (let ((av (assoc (car l) *gr*)))
      (if av
          (rplacd av (cons (cdr l)
                           (cdr av)))
          (push (list (car l) (cdr l))
                *gr*)))))

(defun links-leaving (node-name)
  (loop for l in (cdr (assoc node-name *gr*)) collect (car l)))

(defun links-coming (node-name)
  (loop for n in *gr*
        for l = (loop for ln in (cdr n)
                      when (equalp node-name (cadr ln)) collect ln)
        when l collect (list (car n) l)))

(progn
  (format t "=====~%")
  (setf *gr* nil)
  (push-links links)
  (format t "~A~%" *gr*)
  (format t "=====~%")
  (format t "~A~%" (links-leaving 'b3))
  (format t "=====~%")
  (format t "~A~%" (links-coming 'na3)))
