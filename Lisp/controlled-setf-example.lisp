(declaim (optimize (speed 0) (safety 3) (debug 2)))
;; (load "~/Programming/Pyrulis/Lisp/controlled-setf-example.lisp")

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(defclass-std)))

(shadowing-import 'defclass-std::defclass/std)

(defclass/std my-obj ()
  ((slot-1 :std nil)))

(defparameter *zzz* nil)

(defmacro assignm (place value)
  `(progn
     (format t "assigning ~S ~S of type ~S~%" ,place ,value (type-of ,place))
     (typecase ,place
       (my-obj
        (progn
          (format t "doing keyword~%")
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




(progn
  (assignm *zzz* "1")
  (assignm *zzz* (make-instance 'my-obj))
  (assignm (slot-1 *zzz*) :anything)
  ;; I want error
  (assignm *zzz* nil)
  )
