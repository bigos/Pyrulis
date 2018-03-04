(defgeneric boo (value)
  (:documentation "display a value with comment"))

(defmethod boo ((value integer))
  (format t "integer ~a~%" value))

(defmethod boo ((value single-float))
  (format t "float ~a~%" value))

(defmethod boo ((value T))
  (format t "other ~a - ~a~%" value (type-of value)))

(defclass baa ()
  ((value)))

(defclass buu ()
  ((value
     :initarg :value
     :accessor value)))

(format t "trying normal values~%")

(boo 1)

(boo 3.14)

(boo "string")

(format t "trying classes~%")

(defparameter baaobj (make-instance 'baa))
(defparameter buuobj (make-instance 'buu :value #\a))

(boo baaobj)

(boo buuobj)
