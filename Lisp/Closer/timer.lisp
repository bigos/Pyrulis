;;; oo timer program will go here
(format t "~%this is a timer~%~%")

(defclass my-timer ()
  ((timer-value :initform (- 2 2))
   (yet-another-slot :initform (list 1 (cons 2 2.5) 3))))

(defgeneric get-value (my-timer))

(defmethod get-value (my-timer)
  (slot-value my-timer 'timer-value))

(defgeneric inc (my-timer))

(defmethod inc (my-timer)
  (incf (slot-value my-timer 'timer-value)))

(defparameter *obj* (make-instance 'my-timer ))

(format t "initial value is: ~d~%" (get-value *obj*))

(format t "increased value is: ~d~%" (inc *obj*))
