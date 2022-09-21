(declaim (optimize (speed 0) (safety 2) (debug 3)))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria serapeum)))

(defpackage #:hashpath
  (:import-from :serapeum
   :->)
  (:use :cl))
;; (load "~/Programming/Pyrulis/Lisp/hashpath.lisp")
(in-package #:hashpath)

(defun hash-add (hash key value)
  (when (typep value 'hash-table)
    (setf (gethash :.. value) hash
          (gethash :.  value) key))
  (setf (gethash key hash) value))

;; (hash-add-path zzz '('q :a :b :c) 3)
(defun hash-add-path (hash keys value)
  (loop for k in keys
        for oldh = nil then h
        for h = hash then (alexandria:ensure-gethash k h (make-hash-table))
        do
           (when oldh
             (hash-add oldh k h))
           (format t "~& printing ~S~%" h)
        finally (setf (gethash k h) value)))

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

(defun parent-hash-table-alist (table)
  "Returns an association list containing the keys and values of hash table
TABLE replacing parent table with 'parent."
  (let ((alist nil))
    (maphash (lambda (k v)
               (push (cons k
                           (if (eql k :..)
                               'parent
                               v))
                     alist))
             table)
    alist))

(defmethod print-object ((obj hash-table)  stream)
  (print-unreadable-object (obj stream :type t)
    (format stream "~S"
          (parent-hash-table-alist obj))))

(defun test-me ()
  (format t "~&Testing hashpath~%")

  (let* ((root-hash (make-hashpath-table :root))
         (current-hash root-hash))
    (assert (typep current-hash 'hash-table))


    root-hash))
