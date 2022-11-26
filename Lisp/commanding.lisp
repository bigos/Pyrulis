(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria serapeum defclass-std)))

(defpackage #:commanding
  (:import-from :defclass-std
   :defclass/std)
  (:import-from :serapeum
   :~>)
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
  ((help-message :std nil)
   (size :std (make-instance 'tsmall))
   (t1 :std :ts1)
   (t2 :std :ts2)
   (t3 :std :ts3)
   (large :std :l1)))

(defclass/std message ()        ())
(defclass/std help    (message) ())
(defclass/std nop     (message) ())
(defclass/std t1      (message) ())
(defclass/std t2      (message) ())
(defclass/std t3      (message) ())
(defclass/std sml     (message) ())
(defclass/std med     (message) ())
(defclass/std lrg     (message) ())

(defclass/std thumb-size ()           ())
(defclass/std tsmall     (thumb-size) ())
(defclass/std tmedium    (thumb-size) ())
(defclass/std tlarge     (thumb-size) ())

(defun is-child-of (obj class-sym)
  (warn "in child check ~S ~S ~S ==> ~S" obj (type-of obj) class-sym (subtypep (type-of obj) class-sym))
  (and
   (not (eq (type-of obj) class-sym))
   (typep obj class-sym)
   ;; need to investigate further
   ;; NOOO because of equal check in the function
   (subtypep (type-of obj) class-sym)))

(defmethod validate ((model model))
  (warn "validating model")
  (unless (is-child-of (size model) 'thumb-size)
    (error "class ~S is not expected thumb-size class" (type-of (size model)))))

(defmethod init ((runtime runtime) flags)
  (declare (ignore flags))
  (setf (model runtime)
        (make-instance 'model)))

(defmethod view ((runtime runtime) model)
  (warn "view ~S~%" model)

  (format t "~&beginning of output ==============================~%")
  ;;  do the view stuff
  (when (~> runtime model help-message)
    (format t "help message ~S~%" (help-message model)))

  (format t "~&the end of output ================================~%"))

(defmethod update :before ((runtime runtime) message model)
  (unless (is-child-of message 'message)
    (error "class ~S is not expected message class" (type-of message)))
  (setf (~> runtime model help-message) nil))

(defmethod update :after ((runtime runtime) message model)
  (validate model)
  (view runtime model))

(defmethod update ((runtime runtime) (message T) model)
  (warn "not implemented update ~S ~S" message model))

(defmethod update ((runtime runtime) (message help) model)
  (warn "update handling help")
  (setf (~> runtime model help-message) "this is help"))

(defmethod update ((runtime runtime) (message nop) model)
  (warn "update handling nop"))

(defmethod update ((runtime runtime) (message t1) model)
  (setf (~> model large) :l1))

(defmethod update ((runtime runtime) (message t2) model)
  (setf (~> model large) :l2))

(defmethod update ((runtime runtime) (message t3) model)
  (setf (~> model large) :l3))

(defmethod update ((runtime runtime) (message sml) model)
  (setf (~> model size) (make-instance 'tsmall)
        (~> model t1) :ts1
        (~> model t2) :ts2
        (~> model t3) :ts3))

(defmethod update ((runtime runtime) (message med) model)
  (setf (~> model size) (make-instance 'tmedium)
        (~> model t1) :tm1
        (~> model t2) :tm2
        (~> model t3) :tm3))

(defmethod update ((runtime runtime) (message lrg) model)
  (setf (~> model size) (make-instance 'tlarge)
        (~> model t1) :tl1
        (~> model t2) :tl2
        (~> model t3) :tl3))

(defmethod command ((runtime runtime) input)
  (labels ((ur (sym)
             (update runtime (make-instance sym) (model runtime))))

    (format t "handling command ~S~%" input)
    (cond
      ((equal input "help")
       (ur 'help))
      ((equal input "nop")
       (ur 'nop) )
      ((equal input "t1")
       (ur 't1))
      ((equal input "t2")
       (ur 't2))
      ((equal input "t3")
       (ur 't3))
      ((equal input "sml")
       (ur 'sml))
      ((equal input "med")
       (ur 'med))
      ((equal input "lrg")
       (ur 'lrg))
      (T
       (warn "not handled case")))))

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
