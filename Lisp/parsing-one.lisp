;;; parsing ONE - playing with the parsing basics

(declaim (optimize (speed 0) (safety 2) (debug 3)))

(ql:quickload :alexandria)

(defpackage #:parsing-one
  (:use #:cl))

(in-package #:parsing-one)              ;---------------------------------------

(defparameter parsed (format nil
                             " 123 + 456 # comment~% \"a \\\"quoted\\\" String\"  # end comment"))

(defun char-within (c char-from char-to)
  (declare (type base-char c char-from char-to))
  (<= (char-code char-from)
      (char-code c)
      (char-code char-to)))

(defun what (c)
  (declare (type (base-char) c))
  (the symbol
       (cond
         ((eq c #\Space) 'space)
         ((char-within c #\0 #\9) 'digit)
         ((char-within c #\a #\z) 'letter-lower)
         ((char-within c #\A #\Z) 'letter-upper)
         (T 'unknown))))

(defun ify (parsed i)
  (let ((c (aref parsed i))
        (prev (when (> i 0)
                (aref parsed (1- i))))
        (next (when (< i (1- (length parsed)))
                (aref parsed (1+ i)))))
    (classify prev c next)))

(defun classify (prev c next)
  (declare (type standard-char c)
           (type (or standard-char null) prev next))
  (let ((a (what c)))
    (cond
      ((and (eq c    #\Return)
            (eq next #\Newline))
       (list 'windows-newline))
      ((and (eq c         #\Newline)
            (not (eq prev #\Return)))
       (list 'unix-newline))
      ((and (eq c         #\")
            (not (eq prev #\\)))
       (list 'string-quote))
      ((and (eq c    #\")
            (eq prev #\\))
       (list 'escaped-quote))
      ((eq c #\\)
       (list 'escape-character))
      ((eq c #\#)
       (list 'comment))
      (T
       (list a)))))

;;; preparing for better tokenizing
(defun pc-prim (parsed i acc in-comment in-string)
  (pc parsed i acc in-comment in-string))

(defun pc (parsed i acc in-comment in-string)
  (declare (type string parsed) (type (integer 0 255) i) (type (or null list) acc))
  (if (>= i (length parsed))
      (list parsed
            (reverse acc))
      (let ((c (aref parsed i))
            (prev (when (> i 0)
                    (aref parsed (1- i))))
            (next (when (< i (1- (length parsed)))
                    (aref parsed (1+ i)))))
        (pc-prim parsed (1+ i)
            (cons
             (list i
                   c
                   '---
                   prev next
                   (ify parsed i))
             acc)
            in-comment in-string
            ))))

(defun main ()  (format t "~s~%"
                        (pc parsed 0 nil nil nil)))

;;; ----------------------------------------------------------------------------
(main)
