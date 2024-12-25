(declaim (optimize (speed 0) (safety 3) (debug 2)))
;; (load "~/Programming/Pyrulis/Lisp/controlled-setf-example.lisp")

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(defclass-std)))

(shadowing-import 'defclass-std::defclass/std)

(defclass/std my-obj ()
  ((slot-1 :std :initial)))

(defmethod print-object ((obj standard-object) stream)
  (print-unreadable-object (obj stream :type t :identity t)
    (format stream "~a"
            (loop for sl in (sb-mop:class-slots (class-of obj))
                  for slot-name = (sb-mop:slot-definition-name sl)
                  collect (cons slot-name
                                (if (slot-boundp obj slot-name)
                                    (format nil "~S" (slot-value obj slot-name))))))))

(defparameter *zzz* nil)

;;; needs fixing
;; https://lispcookbook.github.io/cl-cookbook/macros.html#getting-macros-right

(defmacro assignm (place value)
  `(progn
     (format t "assigning place ~S with value ~S ----  type of place ~S~%" ,place ,value (type-of ,place))
     (typecase ,place
       (my-obj
        (progn
          (format t "doing ~S~%" (type-of ,place))
          (if (null ,value)
              (progn
                (error "error assigning with null")
                (setf,place ,value))
              (setf ,place ,value))))
       (t (progn
            (format t "doing any~%")
            (if (null ,value)
                (progn
                  (warn "assigning with null")
                  (setf,place ,value))
                (setf ,place ,value)))))))

;;; simple case
(progn
  (assignm *zzz* 1)
  (assignm *zzz* 2)
  ;; I want warning
  (assignm *zzz* nil))


(format t "~%~% more examples ~%~%")

(progn
  (assignm *zzz* "1")
  (assignm *zzz* (make-instance 'my-obj))
  (assignm (slot-1 *zzz*) :anything)
  (assignm *zzz* (make-instance 'my-obj :slot-1 "again"))
  ;; I want error
  (assignm *zzz* nil)
  )
