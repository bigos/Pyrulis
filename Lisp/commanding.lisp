(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria serapeum defclass-std)))

(defpackage #:commanding
  (:import-from :defclass-std :defclass/std)
  (:use #:cl))

;; (load "~/Programming/Pyrulis/Lisp/commanding.lisp")
(in-package #:commanding)

(defun prompt (prompt)
  (format t "~&~a > " prompt)
  (read-line))

(defun mkstr (&rest args)
  (with-output-to-string (s)
    (dolist (a args) (princ a s))))

(defun symb (&rest args)
  (values (intern (apply #'mkstr args))))


#| command succession
  repl_input
  update message model
  view model
  repl_print
|#

(defmethod print-object ((obj standard-object) stream)
  (print-unreadable-object (obj stream :type t)
    (format stream "~S"
            (loop for sl in (sb-mop:compute-slots (class-of obj))
                  collect (list
                           (sb-mop:slot-definition-name sl)
                           (slot-value obj (sb-mop:slot-definition-name sl)))))))

(defclass/std runtime ()
  ((model)))

(defclass/std model ()
  ((help-message :std nil)))

(defclass/std message ()
  ())

(defclass/std help (message)
  ())

(defclass/std nop (message)
  ())


(defmethod init ((runtime runtime) flags)
  (declare (ignore flags))
  (setf (model runtime)
        (make-instance 'model)))

(defmethod view ((runtime runtime) model)
  (warn "view ~S~%" model)

  (format t "~&beginning of output ==============================~%")
  ;;  do the view stuff
  (when (help-message (model runtime))
    (format t "help message ~S~%" (help-message model)))

  (format t "~&the end of output ================================~%"))

(defmethod update ((runtime runtime) message model)
  (warn "update ~S ~S~%" message model)
  (typecase message
    (help
     (warn "update handling help")
     (setf (help-message (model runtime)) "this is help")
     (view runtime model))
    (nop
     (setf (help-message (model runtime)) nil)
     (view runtime model))
    (t
     (warn "not implemented ~S ~S~%" message model)
     (setf (help-message (model runtime)) nil)
       (view runtime model))))

(defmethod command ((runtime runtime) input)
  (format t "handling command ~S~%" input)
  (cond
    ((equal input "help")
     (update runtime (make-instance 'help) (model runtime)))
    ((equal input "nop")
     (update runtime (make-instance 'nop) (model runtime)))
    (T
     (warn "not handled case"))))

(defun main ()
  (let ((runtime (make-instance 'runtime)))
    (init runtime nil)

    (loop for input = (prompt "enter command")
          do
             (format t "you have said ~S~%" input)
             (command runtime input)
          until (equal input "quit")
          finally
             (format t "quitting with ~S~%" runtime))))
