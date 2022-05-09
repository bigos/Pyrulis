;;;; tris.lisp

(in-package #:tris)

(defstruct tris
  (tria)
  (trib)
  (tric))

(defun tris (tria trib tric)
  "Three way version of cons, with TRIB and TRIC resembling CAR and CDR."
  (make-tris :tria tria :trib trib :tric tric))

(defun tria (tris)
  (tris-tria tris))
(defun (setf tria) (val tris)
  (setf (tris-tria tris) val))

(defun trib (tris)
  (tris-trib tris))
(defun (setf trib) (val tris)
  (setf (tris-trib tris) val))

(defun tric (tris)
  (tris-tric tris))
(defun (setf tric) (val tris)
  (setf (tris-tric tris) val))

(defun trilist (&rest values)
  (let ((head nil)
        (b nil))
    (loop for v in values
          do
             (let ((current (tris b v nil)))
               (unless head (setf head current))
               (when b
                 (setf (tric b) current))
               (setf b current)))
    head))

(defun trilist-last (tris)
  (if (tric tris)
      (trilist-last (tric tris))
      tris))
