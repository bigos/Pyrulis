;;; we must declare safety for better type checking
(declaim (optimize (safety 3)))

(defclass person ()
  ((name
    :type simple-string
    :initarg :name)))

(defparameter p1 (make-instance 'person :name "Lolek"))

;;; example of using mop in sbcl
(loop for s in (sb-mop:class-slots (class-of p1))
      collect (sb-mop:slot-definition-name s))


