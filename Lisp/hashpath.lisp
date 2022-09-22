(declaim (optimize (speed 0) (safety 2) (debug 3)))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria serapeum)))

(defpackage #:hashpath
  (:import-from :serapeum
   :->)
  (:use :cl))
;; (load "~/Programming/Pyrulis/Lisp/hashpath.lisp")
(in-package #:hashpath)

(defun init-hash (parent-hash current-hash key)
  (unless (zerop (hash-table-count current-hash))
    (error "You can only init empty hash-table"))

  (setf (gethash :.. current-hash) parent-hash
        (gethash :.  current-hash) key))

(defun hash-add (hash key value)
  (when (typep value 'hash-table)
    (init-hash hash value key))
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
  (loop for k being the hash-key in table
        collect (cons k
                      (if (eql k :..)
                          'parent
                          (gethash k table)))))

(defmethod print-object ((obj hash-table)  stream)
  (print-unreadable-object (obj stream :type t)
    (format stream "~S"
          (parent-hash-table-alist obj))))

(defun test-me ()
  (format t "~&Testing hashpath~%")

  (let* ((root-hash (make-hash-table))
         (current-hash root-hash))
    (init-hash nil root-hash :/)
    (assert (typep current-hash 'hash-table))

    (hash-add current-hash :a "a")
    (hash-add current-hash :b "b")

    (hash-add-path current-hash '(zzz :c) "c")
    (assert (hashpath-tablep current-hash :c))

    root-hash))
