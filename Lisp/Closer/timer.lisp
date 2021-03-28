;;; oo timer program will go here
(declaim (optimize (speed 0) (space 0) (safety 2) (debug 3)))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria serapeum dot-cons-tree fiveam)))

(defun dd (l)
  (dot-cons-tree:draw-graph l))

(format t "~%this is a timer~%~%")

(defclass my-timer ()
  ((timer-value :initform (- 2 2))))

(defgeneric get-value (my-timer))

(defmethod get-value (my-timer)
  (slot-value my-timer 'timer-value))

(defgeneric inc (my-timer))

(defmethod inc (my-timer)
  (incf (slot-value my-timer 'timer-value)))

(defparameter *obj* (make-instance 'my-timer ))

(format t "initial value is: ~d~%" (get-value *obj*))

(format t "increased value is: ~d~%" (inc *obj*))

(dot-cons-tree:draw-graph (list 1 *obj* 3 4 5))


(defun testme ()
  (5am:test abc
    (5am:is (= 1 2)))

  (5am:run! 'abc))
