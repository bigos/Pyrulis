(declaim (optimize (speed 0) (safety 2) (debug 3)))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(defclass-std)))

(defpackage :clos-micro-objects
  (:import-from :defclass-std :defclass/std)
  (:use #:cl))

;; (load "~/Programming/Lisp/lispy-experiments/clos-micro-objects.lisp")
(in-package :clos-micro-objects)

;; (print "hello micro")


;; ====================================== type checking in a class ========================
;; https://stackoverflow.com/questions/51723992/how-to-force-slots-type-to-be-checked-during-make-instance/56920918

;;; First the metaclass:
;;; first a metaclass for classes which checks slot writes
(defclass checked-class (standard-class)
  ())

;;; this is a MOP method, probably use CLOSER-MOP for a portable version
(defmethod sb-mop:validate-superclass ((class checked-class) (superclass standard-class))
  t)

;; Now we check all slot writes for that metaclass:
;; this is a MOP method, probably use CLOSER-MOP for a portable version
(defmethod (setf sb-mop:slot-value-using-class) :before (new-value (class checked-class) object slot)
  (assert (typep new-value (sb-mop:slot-definition-type slot))
          ()
          "new value ~s is not of type ~a in object ~a slot ~a"
          new-value
          (sb-mop:slot-definition-type slot)
          object
          (sb-mop:slot-definition-name slot)))

;;; ====================== ensuring no unbound slots ===========================
(defun set-all-unbound-slots (instance &optional (value nil))
  (let ((class (class-of instance)))
    (sb-mop:finalize-inheritance class)
    (loop for slot in (sb-mop:compute-slots class)
          for name = (sb-mop:slot-definition-name slot)
          unless (slot-boundp instance name)
          do (setf (slot-value instance name) value))
    instance))

(defclass set-unbound-slots-mixin () ())

(defmethod initialize-instance :after ((i set-unbound-slots-mixin) &rest initargs)
  (declare (ignore initargs))
  (set-all-unbound-slots i nil))

;;; =========== classes for experimenting with type checking ===================
(defclass/std uno  (set-unbound-slots-mixin) ((val :type (integer 0 10))) (:metaclass checked-class))
(defclass/std bot  (uno) () (:metaclass checked-class))
(defclass/std bot2 (uno) () (:metaclass checked-class))
