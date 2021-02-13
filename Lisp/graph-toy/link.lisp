(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria draw-cons-tree)))

#| starting up
(push #p "~/AAAAA/graph-toy/" asdf:*central-registry*)
(ql:quickload :graph-toy)
(in-package #:graph-toy)
|#

(in-package #:graph-toy)

(defclass link ()
  ((source :initarg :source
           :initform (error "We need source")
           :accessor source)
   (action :initarg :action
           :initform ""
           :accessor action)
   (target :initarg :target
           :initform (error "We need target")
           :accessor target)))

(defmethod probe ((l link))
  (list 'the-link
        (source l)
        (action l)
        (target l)))

(defmethod link-to-list ((l link))
  (list (source l) (action l) (target l)))

(defun build-combinations (comb)
  "for testing usage: (build-combinations '(a b c))"
  (loop for p in (let ((zebr))
                   (alexandria:map-combinations (lambda (x) (push x zebr))
                                                comb
                                                :length 2)
                   zebr)
        collect
        (destructuring-bind (source target) p
          (make-instance 'link
                         :source source
                         :action (format nil "~A2~A" source target)
                         :target target))))
