;;; parsing ONE - playing with the parsing basics

(declaim (optimize (speed 0) (safety 2) (debug 3)))

(ql:quickload :alexandria)

(defpackage #:parsing-one
  (:use #:cl))

(in-package #:parsing-one)              ;---------------------------------------

(defparameter parsed (format nil " 123 + 456 # comment~% \"a string\"  # end comment"))

(defun what (c)
  (declare (type (base-char) c))
  (the symbol
       (cond
         ((eq c #\Space) 'space)
         ((eq c #\Newline) 'newline)
         ((and
           (>= (char-code c) (char-code #\0))
           (<= (char-code c) (char-code #\9))) 'digit)
         (T 'unknown))))

(defun classify (prev c next)
  (declare (type standard-char c)
           (type (or standard-char null) prev next))
  (let ((a (what c)))
    a))

(defun pc (parsed i acc)
  (declare (type string parsed) (type (integer 0 255) i) (type (or null list) acc))
  (if (>= i (length parsed))
      (list parsed
            (reverse acc))
      (let ((c (aref parsed i))
            (prev (when (> i 0)
                    (aref parsed (1- i))))
            (next (when (< i (1- (length parsed)))
                    (aref parsed (1+ i)))))
        (pc parsed (1+ i)
            (cons
             (list i
                   c
                   '---
                   prev
                   next
                   '===
                   (classify prev c next))
             acc)))))

(defun main ()  (format t "~A~%"
                        (pc parsed 0 nil)))

;;; ----------------------------------------------------------------------------
(main)
