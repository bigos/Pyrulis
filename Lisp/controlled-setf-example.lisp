(declaim (optimize (speed 0) (safety 3) (debug 2)))
;; (load "~/Programming/Pyrulis/Lisp/controlled-setf-example.lisp")

(defparameter *zzz* nil)

;;; how do I replace setf with assign forms in my code when I need it?
(defun assignf (place value)
  (setf place value))

(defmacro assignm (place value)
  `(setf ,place ,value))

;;; simple case
(progn
  (setf *zzz* 1)
  (setf *zzz* 2)
  ;; I want warning or error
  (setf *zzz* nil))



;;; typed case
(progn
  (setf *zzz* "1")
  ;; that should be allowed
  (setf *zzz* nil)
  (setf *zzz* :one)
  ;; I want warning or error
  (setf *zzz* nil))
