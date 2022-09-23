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
    (error "You can only init empty hash-table, we have key ~S" (gethash :. current-hash)))

  (setf (gethash :.. current-hash) parent-hash
        (gethash :.  current-hash) key))

(defun hash-add (hash key value)
  (when (typep value 'hash-table)
    (unless (hashpath-tablep hash key)
      (init-hash hash value key)))
  (setf (gethash key hash) value))

(defun hash-add-path (hash keys value)
  (if (null (cdr keys))
      (setf (gethash (car keys) hash) value)
      (let ((next-hash (gethash (car keys) hash )))
        (unless next-hash
          (setf next-hash (alexandria:ensure-gethash (car keys)
                                                     hash
                                                     (make-hash-table)))
          (init-hash hash next-hash (car keys)))
        (hash-add-path next-hash (cdr keys) value))))

(defun hash-get-path (hash keys)
  "Return HASH or value that can be traversed from HASH using the KEYS."
  (if (endp keys)
      hash
      (hash-get-path (gethash (first keys) hash) (rest keys))))

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
    (assert (equal (parent-hash-table-alist root-hash)
                   '((:|..| . PARENT) (:|.| . :/) (:A . "a") (:B . "b"))))

    (hash-add-path current-hash '(:c :c) "c")
    (assert (hashpath-tablep current-hash :c))
    (assert (equal (parent-hash-table-alist (gethash :c  root-hash))
                   '((:|..| . PARENT) (:|.| . :C) (:C . "c"))))

    (hash-add-path current-hash '(:c :d :d) "d")
    (assert (equal (parent-hash-table-alist
                    (gethash :d
                             (gethash :c  root-hash)))
                   '((:|..| . PARENT) (:|.| . :D) (:D . "d"))))

    (format t "zzzz ~S~%"
            (hash-get-path root-hash '(:c :d :d)))
    root-hash))

(defun test-add ()
  (let ((root-hash (make-hash-table)))
    (init-hash nil root-hash :/)

    (hash-add-path root-hash '(:a :b :c) "c-value")

    root-hash))
