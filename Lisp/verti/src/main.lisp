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

;;; usage: (build-combinations '(a b c))
(defun build-combinations (comb)
  (loop for p in (let ((zebr))
                   (alexandria:map-combinations (lambda (x) (push x zebr))
                                                comb
                                                :length 2)
                   zebr)
        collect (mapcar #'string-downcase
                        (list
                         (format nil "~A" (nth 0 p))
                         (format nil "~A2~A" (nth 0 p) (nth 1 p))
                         (format nil "~A" (nth 1 p))))))

(defun build-vert (source action target)
  (make-vert :source source :action action :target target))

(defun build-vert-collection (collection)
  (loop for l in collection
        collect (apply #'build-vert l)))

;; (remove-node "a" (build-combinations '(a b c d)))
(defun remove-node (node collection)
  (loop for l in collection
        when (and (not (equalp (vert-source l) node))
                  (not (equalp (vert-target l) node)))
          collect l
        when (and (not (equalp (vert-source l) node))
                  (equalp (vert-target l) node))
          collect (build-vert (vert-source l) "" nil)
        when (and (equalp (vert-source l) node)
                  (not (equalp (vert-target l) node)))
          collect (build-vert (vert-target l) "" nil)))
