(declaim (optimize (speed 0) (debug 3)))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria)))

(defpackage #:hashpath
  (:use :cl))
;; (load "~/Programming/Pyrulis/Lisp/hashpath.lisp")
(in-package #:hashpath)

(defun make-hashpath-table (key)
  (let ((hash (make-hash-table)))
    (setf (gethash :. hash) key)
    hash))

(defun hash-add (hash key value)
  (when (eql 'hash-table (type-of value))
    (setf (gethash :.. value) hash))
  (setf (gethash key hash) value))

(defun hashpath-tablep (current-hash key)
  (let ((hash (gethash key current-hash)))
    (and (eql 'hash-table (type-of hash))
         (not (null (gethash :. hash)))
         (not (null (gethash :.. hash))))))

(defun hash-enter (current-hash key)
  (setf current-hash (gethash key current-hash)))

(defun hash-parent (current-hash)
  (gethash :.. current-hash))

(defun hash-current (current-hash)
  (gethash :. current-hash))

(defun hash-add-path (current-hash keys value)
  (if (null (cdr keys))
      (setf (gethash (car keys) current-hash) value)
      (progn
        (unless (gethash (first keys) current-hash)
          (hash-add current-hash (first keys) (make-hashpath-table (first keys))))
        (hash-add-path (gethash (first keys) current-hash) (rest keys) value))))

(defun the-hash (current-hash key)
  (cond
    ((equal :. key)
     current-hash)
    (t
     (gethash key current-hash))))

(defun hash-enter-path (current-hash keys)
  (assert (eql 'hash-table (type-of current-hash))
          (current-hash keys) )
  (let ((current-hash2 nil))
    (setf current-hash2
          (the-hash current-hash (first keys)))
    (if (null current-hash2)
        current-hash
        (hash-enter-path current-hash (rest keys)))))

(defun test-me ()
  (format t "~&Testing hashpath~%")

  (let* ((root-hash (make-hashpath-table :root))
        (current-hash root-hash))
    (hash-add current-hash :key1 'value1)
    (hash-add current-hash :key2 'value2)
    (hash-add current-hash :ch1 (make-hashpath-table :ch1))
    (hash-add current-hash :ch2 (make-hashpath-table :ch2))

    (when (hashpath-tablep current-hash :ch1)
      (format t "~S is a hashpath table~%" :ch1))

    (hash-enter current-hash :ch1)
    (hash-parent current-hash)

    (when (equal :root
                 (hash-current current-hash))
      (format t "we are at root~%"))

    (hash-add-path current-hash '(:root :ch1 :ch1a) "avalue")
    (hash-add-path current-hash '(:root :ch1 :ch1b) (make-hashpath-table ::ch1a1))

    (format t "before cd ~s~%" current-hash)
    (hash-enter-path current-hash '(:. :ch1 :ch1b))

    (when (equal :ch1b
                 (hash-current current-hash))
      (format t "we are at ch1b~%"))

    root-hash))
