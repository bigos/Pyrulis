;;; entering fsm

(declaim (optimize (speed 0) (safety 2) (debug 3)))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria serapeum defclass-std)))

(defpackage :entering-fsm
  (:import-from :serapeum :~>)
  (:import-from :defclass-std :defclass/std)
  (:use #:cl))
;; (load (compile-file "~/Programming/Pyrulis/Lisp/Closer/entering-fsm.lisp"))
(in-package :entering-fsm)

(defun m0 (class) (make-instance class))

(defclass/std prompt-state () ())
(defclass/std initial (prompt-state) ())
(defclass/std help (prompt-state) ())

(defclass/std prompt ()
  ((state :std (m0 'initial))))

;;; ----------------------------------------------------------------------------


;; (send 'process)
(let ((prompt (make-instance 'prompt)))
  (defun send (my-method)
    "With prompt in the closure, I can reduce number of arguments needed in
    REPL."
    (funcall my-method prompt (state prompt))))

;;; ----------------------------------------------------------------------------

(defmethod process ((prompt prompt) (prompt-state initial))
  (warn "processing initial state")
  (setf (state prompt) (m0 'help)))

(defmethod process ((prompt prompt) (prompt-state help))
  (warn "processing help state")
  (setf (state prompt) (m0 'initial)))
