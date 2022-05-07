;;;; tris.lisp

(in-package #:tris)

(defstruct tris
  (trib)
  (tria)
  (trid))

(defun tris (trib tria trid)
  "Three way version of cons, with TRIA and TRID resembling CAR and CDR."
  (make-tris :trib trib :tria tria :trid trid))

(defun trib (tris)
  (tris-trib tris))
(defun (setf trib) (val tris)
  (setf (tris-trib tris) val))

(defun tria (tris)
  (tris-tria tris))
(defun (setf tria) (val tris)
  (setf (tris-tria tris) val))

(defun trid (tris)
  (tris-trid tris))
(defun (setf trid) (val tris)
  (setf (tris-trid tris) val))

(defun trilist (&rest values)
  (let ((head nil)
        (b nil))
    (loop for v in values
          do
             (let ((current (tris b v nil)))
               (unless head (setf head current))
               (when b
                 (setf (trid b) current))
               (setf b current)))
    head))

(defun trilist-tail (tris)
  (if (trid tris)
      (trilist-tail (trid tris))
      tris))
