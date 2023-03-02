;;; entering fsm

(declaim (optimize (speed 0) (safety 2) (debug 3)))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria serapeum defclass-std)))

(defpackage :entering-fsm
  (:import-from :serapeum :~>)
  (:import-from :defclass-std :defclass/std)
  (:use #:cl))
;; (load "~/Programming/Pyrulis/Lisp/Closer/entering-fsm.lisp")
(in-package :entering-fsm)

(defun m0 (class) (make-instance class))

(defclass/std prompt-state () ())
(defclass/std initial (prompt-state) ())
(defclass/std help (prompt-state) ())

(defclass/std prompt ()
  ((state :std (m0 'initial))))

;;; ----------------------------------------------------------------------------

(defparameter !!! (make-instance 'prompt))

(defun qqq (arg)
  (enter !!! arg))

;; (enter !!! "zzz") or (qqq "zzz")
(defmethod enter ((prompt prompt) (entered t))
  (cond ((null entered)
         (format t "nothing entered~%"))
        ((typep entered 'string)
         (cond
           ((equalp entered "")
            (format t "entered empty string~%"))
           ((serapeum:blankp entered)
            (format t "entered blank string~%"))
           (t
            (format t "entered some string")

            (process prompt
                     (state prompt)
                     (serapeum/bundle:make-keyword (string-upcase entered))))))

        (t (warn "entered ~S is not recognised" entered))))

;;; ----------------------------------------------------------------------------

(defmethod process ((prompt prompt) (prompt-state initial) (entered (eql :help)))
  (warn "processing initial state")
  (setf (state prompt) (m0 'help)))

(defmethod process ((prompt prompt) (prompt-state help)    (entered (eql :quit)))
  (warn "processing help state")
  (setf (state prompt) (m0 'initial)))
