;;;; graph-toy.lisp

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria)))

#| starting up
(push #p"~/Programming/Pyrulis/Lisp/graph-toy/" asdf:*central-registry*)
(ql:quickload :graph-toy)
(in-package #:graph-toy)
(asdf:test-system 'graph-toy)
|#

(in-package #:graph-toy)

;;; functions
(defun describe-instance (inst)
  (cons (type-of inst)
   (loop for slot in (sb-mop:class-direct-slots (class-of inst))
         collect (list
                  (sb-mop:slot-definition-name slot)
                  (slot-value inst (sb-mop:slot-definition-name slot))))))

(defun prompt (message)
  (format t "~& ~A > " message)
  (read-line))

(defparameter *graph* nil)

(defun main ()
  (setf *graph* (make-instance 'graph))
  (loop for l in (build-combinations '("a" "b" "c"))
        do (push l (links *graph*)))
  *graph*)

(defun my-loop ()
  (let ((prompt "~& > "))
    (format t prompt)
    (loop for input = (read-line)
          until (eq 'quit-main-loop     ;com-quit returns 'quit-main-loop
                    (let ((command (keys-command input)))
                      (if command
                          (funcall command)
                          (format t "unrecognised command entered~&enter h for HELP~%"))))
          do
             (format t prompt))))

;;; usage
;;; (main)
;; (my-loop)
