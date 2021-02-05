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
