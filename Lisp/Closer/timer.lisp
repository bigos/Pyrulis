;;; timer oo yprogram will go here
(format t "~%this is a timer~%~%")

(defclass my-timer ()
  ((value
    :initarg :value
    :initform 0
    )))

(defgeneric get-value (my-timer))

(defmethod get-value ((my-timer))
  (slot-value my-timer 'value))

(defgeneric inc (my-timer))

(defmethod inc ((my-timer))
  (incf value)
  )
