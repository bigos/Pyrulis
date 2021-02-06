(defpackage verti
  (:use :cl))
(in-package :verti)

(defun describe-instance (inst)
  (cons (type-of inst)
        (loop for slot in (sb-mop:class-direct-slots (class-of inst))
              collect (list
                       (sb-mop:slot-definition-name slot)
                       (slot-value inst (sb-mop:slot-definition-name slot))))))

(defstruct vert
  (source)
  (action)
  (target))

(defparameter *col3*
  '(("a" "a2b" "b")
    ("b" "b2c" "c")
    ("c" "c2a" "a")))

(defun build-vert (source action target)
  (make-vert :source source :action action :target target))

(defun build-vert-collection (collection)
  (loop for l in collection
        collect (apply #'build-vert l)))

(defun remove-node (node collection)
  (loop for l in collection
        unless (equalp node (vert-source l)) collect l))
