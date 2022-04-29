(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria)))

(defpackage #:graph-viewer
  (:use #:cl))

;; (load "~/Programming/Pyrulis/Lisp/graph-viewer.lisp")
(in-package #:graph-viewer)

(defun instance-slots (i)
  (mapcar #'sb-mop:slot-definition-name
          (sb-mop:class-slots (class-of i))))

(defun travel (d)
  (let ((seen (make-hash-table)))
    (labels
        ((sethash (key hash value)
           (setf (gethash key hash) value))

         (seth (sha parent a fn)
           (let ((a2 (cond ((consp a)
                            (type-of a))
                           ((eq 'structure-class (type-of (class-of a)))
                            (format nil "Struct ~A" (type-of a)))
                           ((null a)
                            (format nil "~A" a))
                           ((symbolp a)
                            (format nil "Symbol ~A" a))
                           (t
                            (format nil "~A"   a)))))
             (let ((target-item (list 'obj a2 'fn fn 'parent parent)))
               (if (gethash sha seen)
                   (unless (member target-item (gethash sha seen) :test #'equal)
                     (sethash sha seen
                              (append (gethash sha seen)
                                      (list target-item))))
                   (sethash sha seen
                            (list target-item))))))

         (visit (a parent parentfn)
           (let ((sha (sxhash a)))
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

(defun draw-graph (gv-file-path)
  (let ((filename gv-file-path)
        (extension "svg"))
    (let ((gv-file (format nil "~A.gv" filename))
          (the-file(format nil "~A.~A" filename extension)))
      (let ((options (list
                      (format nil "-T~A" extension)
                      gv-file
                      "-o"
                      the-file)))
        (format t "dot options ~A~%" options)
        (let ((process (sb-ext:run-program
                        "/usr/bin/dot" options
                        :output :stream :wait nil)))
          (with-output-to-string (s)
            (loop for line = (read-line (sb-ext:process-output process) nil nil)
                  while line
                  do (format s "~A~%" line))
            (sb-ext:process-close process)
            s))))))

(defun nodes (th s)
  (maphash (lambda (node targets)
             ;; (format t "~&elling ~A ~s~%" node targets)

             (format s "~&~a [label=~s]~%"
                     node
                     (getf (first targets) 'obj))
             (loop for target in targets do
               (cond
                 ((eq 'car (getf target 'fn))
                  (format s "~a -> ~a [label=~s,color=red]~%"
                          (getf target 'parent)
                          node
                          (format nil "~S" (getf target 'fn))))

                 ((eq 'cdr (getf target 'fn))
                  (format s "~a -> ~a [label=~s,color=blue]~%"
                          (getf target 'parent)
                          node
                          (format nil "~S" (getf target 'fn))))

                 (t
                  (format s "~a -> ~a [label=~s]~%"
                          (getf target 'parent)
                          node
                          (format nil "~S" (getf target 'fn)))
                  ))))
           th))

(defun graph ()
  (let ((file-path  #p"/tmp/graph.gv"))
    (format t "~A~%"
            (with-open-file (s file-path
                               :direction :output
                               :if-exists :supersede
                               :if-does-not-exist :create)
              (format s "digraph {~%")

              (progn
                (let ((th (travel
                           (list
                            (list 1 2 3)
                            (list
                             '(1 (2 . 3)  4 . 5))))))
                  (nodes th s)))

              (format s "~&}")))
    (draw-graph "/tmp/graph")))
