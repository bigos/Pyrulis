;;; example of basic usage of CLOS

(defun slot-values (obj)
  (loop for the-slot in (mapcar #'sb-pcl:slot-definition-name
                                (sb-pcl:class-slots (class-of obj)))
        collect (if (slot-boundp obj the-slot)
                    (cons the-slot
                          (slot-value obj the-slot))
                    the-slot)))
;;; generic

(defgeneric boo (value)
  (:documentation "display a value with comment"))

;;; methods

(defmethod boo ((value integer))
  (format t "integer ~a~%" value))

(defmethod boo ((value (eql 2)))
  (format t "integer number two ~a~%" value))


(defmethod boo ((value single-float))
  (format t "float ~a~%" value))

(defmethod boo ((value T))
  (format t "other ~a - ~a~%" value (type-of value)))

;;; classes

(defclass baa ()
  ((value)))

(defclass buu ()
  ((value
     :initarg :value
     :accessor value)
   (another-value)))

;;; usage example

(format t "trying normal values~%")

(boo 1)

(boo 2)

(boo 3.14)

(boo "string")

(format t "trying classes~%")

(defparameter baaobj (make-instance 'baa))
(defparameter buuobj (make-instance 'buu :value #\a))

(boo baaobj)

(boo buuobj)

(format t "~&You can inspect objects in REPL by right clicking on the result and selecting Inspect~%")

(format t "slots of object buuobj ~A~%" (slot-values buuobj))

(setf (slot-value buuobj 'another-value) 11111111111)

(format t "slots of object buuobj after setting the another-value ~A~%" (slot-values buuobj))
