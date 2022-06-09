(declaim (optimize (spped 1) (safety 2) (debug 3)))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria serapeum defclass-std)))

;;; * package %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
(require 'sb-concurrency)

(defpackage :key-presser
  (:use #:cl))
;; (load "/home/jacek/Programming/Pyrulis/Lisp/key-presser.lisp")
(in-package :key-presser)

;; #####################################################################

(defun key-press-from-name (name &optional modifiers)
  "For testing, build needed key press data and add Shift for some NAMEs."

  (list
   ;;sanitised modifiers
   (let ((first-char (aref name 0)))
     (remove-if                   ;remove shift for lower case letters
      (lambda (m) (and (eq m :shift)
                       (lower-case-p first-char)))
      (remove-duplicates
       (remove-if-not                   ;remove invalid modifiers
        (lambda (m) (member m '(:shift :ctrl :alt :super)))
        (if (and (eq (length name) 1)
                 (upper-case-p first-char)) ;add :shift for upper case letters
            (cons  :shift
                   modifiers)
            modifiers)))))

   ;; key character or "" for special keys
   (let ((c (cond ((member name (list "Return" "Backspace" "Tab" "Escape" "Delete")
                           :test #'equal)
                   (name-char name))
                  ;; we need more names in the list and better way of handling it
                  ((member name (list "Insert" "Up" "Down" "Left" "Right" "Home"
                                      "End" "Page_Down" "Page_Up")
                           :test #'equal)
                   "")
                  ((member name (list "space")
                           :test #'equal)
                   " ")
                  ((and (equal (subseq name 0 1) "F") ; F1-F12 ?
                        (>= (length name) 2)
                        (parse-integer name :start 1 :junk-allowed nil))
                   "")
                  ((eql 1 (length name))
                   name)
                  (t
                   (error "Name ~S is not valid" name)))))

     (if (stringp c)
         c
         (format nil "~A" c)))

   ;; character name
   name))

(defstruct my-key
  (modifiers)
  (string)
  (name))

(defun my-key-from-name (name &optional modifiers)
  (destructuring-bind (modifiers string name) (key-press-from-name name modifiers)
    (make-my-key :modifiers modifiers
                 :string string
                 :name name)))

;; #####################################################################

(defmethod print-object ((obj standard-object) stream)
  (print-unreadable-object (obj stream :type t)
    (format stream "~S"
            (loop for sl in (sb-mop:compute-slots (class-of obj))
                  collect (list
                           (sb-mop:slot-definition-name sl)
                           (slot-value obj (sb-mop:slot-definition-name sl)))))))

(defclass-std:defclass/std model ()
  ((cnt :std 0)
   (message)))

;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
(defun key-from-inputs (i)
  (typecase i
    (string
     (loop for c across i do
       (try
        (my-key-from-name (format nil "~a" c)))))
    (cons
     (try
      (apply #'my-key-from-name i)))
    (otherwise (error "Type ~S of ~S is not valid" i (type-of i)))))

(defun try (key)
  ;(warn "trying arg ~S ~s" key *model*)
  (let ((m (my-key-modifiers key))
        (s (my-key-string key))
        (n (my-key-name key)))
    (cond
      ((equal (my-key-name key) "F1")
       (setf (message *model*) (format nil "help will go here")))
      ((equal (my-key-name key) "u")
       (setf (cnt *model*) (1+ (cnt *model*))
             (message *model*) nil))
      ((equal (my-key-name key) "d")
       (if (<= (cnt *model*) 0)
           (setf (cnt *model*) 0
                 (message *model*) "can not go below 0")
           (setf (cnt *model*) (1- (cnt *model*))
                 (message *model*) nil)))
      (T
       (setf (message *model*) (format nil "ignoring key ~S" (my-key-name key)))))
    (warn "finished with ~S" *model*)))

(defparameter *model* nil)

(defun try-inputs ()
  (setf *model* (make-instance 'model))
  (loop for i in
        '(("F1") ("space") "uuuddd"  ("space") "dddu" ("F1"))
        do (key-from-inputs i)))

(quote (
        build a counter with
        ( count message)
        and actions
        (up down reset last-message help)
  ))
