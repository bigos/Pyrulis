(declaim (optimize (speed 0) (safety 2) (debug 3)))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria serapeum)))

(defpackage #:hashpath
  (:import-from :serapeum
   :->)
  (:use :cl))
;; (load "~/Programming/Pyrulis/Lisp/hashpath.lisp")
(in-package #:hashpath)

(defun make-hashpath-table (key)
  (let ((hash (make-hash-table)))
    (setf (gethash :. hash) key)
    hash))

(defun hash-add (hash key value)
  (when (typep value 'hash-table)
    (setf (gethash :.. value) hash))
  (setf (gethash key hash) value))

(defun hashpath-tablep (current-hash key)
  (let ((hash (gethash key current-hash)))
    (and (typep hash 'hash-table)
         (not (null (gethash :. hash)))
         (typep (gethash :. hash) 'keyword)
         (not (null (gethash :.. hash)))
         (typep (gethash :.. hash) 'hash-table))))



(-> hash-parent (hash-table) hash-table)
(defun hash-parent (current-hash)
  (gethash :.. current-hash))

(-> hash-current (hash-table) keyword)
(defun hash-current (current-hash)
  (gethash :. current-hash))

(-> the-hash (hash-table keyword) hash-table)
(defun the-hash (current-hash key)
  (cond
    ((equal :. key)
     current-hash)
    (t
     (gethash key current-hash))))

(defmethod print-object ((obj hash-table)  stream)
  (print-unreadable-object (obj stream :type t)
    (format stream "~S"
            (loop for k being each hash-key in obj
                  collect (list k
                                '=
                                (if (eql k :..)
                                    'parent
                                    (gethash k zzz))) ))))

(defun test-me ()
  (format t "~&Testing hashpath~%")

  (let* ((root-hash (make-hashpath-table :root))
         (current-hash root-hash))
    (assert (typep current-hash 'hash-table))


    root-hash))
