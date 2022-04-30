(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria serapeum)))

(defpackage #:graph-viewer
  (:use #:cl))

;; (load "~/Programming/Pyrulis/Lisp/graph-viewer.lisp")
(in-package #:graph-viewer)

#|
We have 3 functions for somewhat correct drawing of the graph, we still need to
find a way for correct drawing of atoms of the same value
|#

(defun travel (d)
  (let ((seen (make-hash-table)))
    (labels
        ((instance-slots (i)
           (mapcar #'sb-mop:slot-definition-name
                   (sb-mop:class-slots (class-of i))))

         (sethash (key hash value)
           (setf (gethash key hash) value))

         (annotate-a (a)
           (cond ((consp a)
                  (type-of a))
                 ((eq 'structure-class (type-of (class-of a)))
                  (format nil "Struct ~A" (type-of a)))
                 ((null a)
                  (format nil "~A" a))
                 ((typep a 'standard-object)
                  (format nil "Object ~A" (type-of a)))
                 ((symbolp a)
                  (format nil "Symbol ~A" a))
                 ((stringp a)
                  (format nil "~S" a))
                 (t
                  (format nil "~A"   a))))

         (seth (sha parent a fn)
           (let ((a2 (annotate-a a)))
             (let ((target-item (list 'obj a2 'fn fn 'parent parent)))
               (if (gethash sha seen)
                   (unless (member target-item (gethash sha seen) :test #'equal)
                     (sethash sha seen
                              (append (gethash sha seen)
                                      (list target-item))))
                   (sethash sha seen
                            (list target-item))))))

         (visit (a parent parentfn)
           (let ((sha (sxhash (typecase a
                                (null   (cons a parent))
                                (real   (cons a parent))
                                (symbol (cons a parent))
                                (string (cons a parent))
                                (t a)))))  ; without consing parent we get shared node for the value
             (if (gethash sha seen)
                 (seth sha parent a parentfn)
                 (let ((slots (instance-slots a)))
                   (if slots
                       (loop for sl in slots
                             do (seth sha parent a parentfn)
                                (visit (slot-value a sl) sha sl))
                       (if (consp a)
                           (progn
                             (seth sha parent a parentfn)
                             (visit (car a) sha 'car)

                             (seth sha parent a parentfn)
                             (visit (cdr a) sha 'cdr))
                           (progn
                             (seth sha parent a parentfn)))))))))
      (visit d 'nothing 'empty))
    seen))

(defun nodes (seen stream )
  (labels ((node-attrs (na)
             (with-output-to-string (str)
               (format str "[~A]"
                       (serapeum:string-join (mapcar
                                              (lambda (p)
                                                (format nil "~S=~S"
                                                        (car p) (cdr p)))
                                              na)
                                             ", ")))))
    (maphash (lambda (node targets)
               (format stream "~&~a ~a~%"
                       node
                       (node-attrs (list (cons "label" (getf (first targets) 'obj)))))
               (loop for target in targets do
                 (let ((tfn (format nil "~S" (getf target 'fn))))
                   (format stream "~a -> ~a ~A~%"
                           (getf target 'parent)
                           node
                           (node-attrs
                            (cond
                              ((eq 'car (getf target 'fn))
                               (list (cons "label" tfn)
                                     (cons "color" "red")))
                              ((eq 'cdr (getf target 'fn))
                               (list (cons "label" tfn)
                                     (cons "color" "blue")) )
                              (t
                               (list (cons "label" tfn)))))))))
             seen)))

;; usage: (graph (list (list 1 2 3) (list '(1 (2 . 3)  4 . 5))))
(defun graph (gr)
  (let* ((file-directory (pathname-directory "/home/jacek/"))
         (gv-file  (make-pathname :directory file-directory :name "graph" :type "gv"))
         (extension "svg")
         (the-file (make-pathname :directory file-directory :name "graph" :type extension)))

    ;; gv file
    (with-open-file (stream gv-file
                            :direction :output
                            :if-exists :supersede
                            :if-does-not-exist :create)
      (format stream "digraph {~%")
      (format stream "~A" (nodes (travel gr) stream))
      (format stream "~&}~%"))
    ;; dot options
    (let ((options (list
                    (format nil "-T~A" extension)
                    (format nil "~A" gv-file)
                    "-o"
                    (format nil "~A" the-file))))
      (format t "dot options ~A~%" options)
      ;; run program
      (let ((process (sb-ext:run-program
                      "/usr/bin/dot" options
                      :output :stream :wait nil)))
        ;; program output
        (with-output-to-string (s)
          (loop for line = (read-line (sb-ext:process-output process) nil nil)
                while line
                do (format s "~A~%" line))
          (sb-ext:process-close process)
          s)))))
