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

(defun remove-node (node collection &optional (acc))
  (if (null collection)
      (remove-duplicates acc :test #'equalp)
      (let ((l (car collection)))
        (cond
          ((and (not (equalp (vert-source l) node))
                (not (equalp (vert-target l) node)))
           (remove-node node (cdr collection) (cons l acc)))
          ((and (equalp (vert-source l) node)
                (equalp (vert-target l) node))
           (remove-node node (cdr collection) acc))
          ((and (equalp (vert-source l) node)
                (not (equalp (vert-target l) node)))
           (remove-node node (cdr collection) (cons (build-vert (vert-target l) "" nil) acc)))
          ((and (not (equalp (vert-source l) node))
                (equalp (vert-target l) node))
           (remove-node node (cdr collection) (cons (build-vert (vert-source l) "" nil) acc)))
          (t
           (error "we should not end here with ~A" l))))))


(remove-node "a"
             (build-vert-collection '(("a" "a2a" "a")
                                      ("a" "a2b" "b")
                                      ("b" "b2a" "a")
                                      ("c" "c2b" "b")
                                      )))

(remove-node "b"
             (build-vert-collection '(("a" "a2a" "a")
                                      ("a" "a2b" "b")
                                      ("b" "b2a" "a")
                                      ("c" "c2b" "b")
                                      )))
