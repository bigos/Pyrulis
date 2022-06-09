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
