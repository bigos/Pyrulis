(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria draw-cons-tree)))

#| starting up
(push #p "~/AAAAA/graph-toy/" asdf:*central-registry*)
(ql:quickload :graph-toy)
(in-package #:graph-toy)
(asdf:test-system 'graph-toy)
|#

(in-package #:graph-toy)

(defclass graph ()
  ((links     :initform nil :accessor links)
   (primary   :initform nil :accessor primary)
   (secondary :initform nil :accessor secondary)))

(defmethod rename-node ((g graph) node-name)
  (let ((rename-as (prompt "new node name")))
    (mapcar (lambda (l)
              (when (equalp (source l) node-name)
                (setf (source l) rename-as))
              (when (equalp (target l) node-name)
                (setf (target l) rename-as)))
            (links g))))

;;; that needs testing with fiveam
(defmethod remove-node ((g graph) node-name)
  (setf (links g)
        (remove-node2 node-name (links g) nil nil)))

(defmethod remove-node2 (node collection acc singles)
  (if (null collection)
      (progn
        (let ((sns (loop for ln in acc collect (source ln)))
              (tns (loop for ln in acc collect (target ln))))
          (concatenate 'list
                        acc
                        (remove-if #'null
                                     (mapcar (lambda (x)
                                               (when (not (or (member x sns :test #'equalp)
                                                              (member x tns :test #'equalp)))
                                                 (unless (null x)
                                                   (make-instance 'link
                                                                   :source x
                                                                   :action ""
                                                                   :target nil))))
                                             (remove-duplicates singles :test #'equalp))))))
      (let ((l (car collection))
            (new-acc acc)
            (new-singles singles))
        (cond
          ((and (not (equalp (source l) node))
                (not (equalp (target l) node)))
           (setf new-acc (cons l acc)))

          ((and (equalp (source l) node)
                (equalp (target l) node))
           (setf #| skipped for both ends matching |#))

          ((and (equalp (source l) node)
                (not (equalp (target l) node)))
           (setf new-singles (cons (target l) singles)))

          ((and (not (equalp (source l) node))
                (equalp (target l) node))
           (setf new-singles (cons (source l) singles)))
          (t
           (error "we should not end here with ~A" l)))
        (remove-node2 node (cdr collection) new-acc new-singles))))

;;; (try-removing)
(defun try-removing ()
  (setf *graph* nil)
  (main)
  (probe *graph*)
  (setf (links *graph*) (remove-node *graph* "a"))
  (probe *graph*))

;;; (ql:quickload :graph-toy)
;;; (main)
;;; (my-loop)

(defmethod delete-link ((g graph) (l link))
  (format t "~&~&deleting ~A~%" (probe l))
  (alexandria:deletef (links g) l))

(defmethod links-to-list ((g graph))
  (loop for l in (links g) collect (link-to-list l)))

(defmethod probe ((g graph))
  (list 'the-graph
        (loop for l in (links g) collect (probe l))
        'primary
        (primary g)
        'secondary
        (secondary g)))

(defgeneric gv-print (a) (:documentation "link as graphviz dot data"))
(defmethod gv-print ((l link))
  (if (null (target l))
      (format nil "~&  ~A;~%" (source l))
      (format nil "~&  ~A -> ~A [label=\"~A\"];~%" (source l) (target l) (action l))))

(defgeneric digraph (a) (:documentation "graph model as graphviz dot data"))
(defmethod digraph ((g graph))
  (format nil "digraph m {~%~A~&}~%"
          (reduce (lambda (a b) (concatenate 'string a b) )
                  (loop for l in (links g)
                     collect (gv-print l))
                  :initial-value "")))
(defmethod digraph ((g (eql nil)))
  (format nil "NO graph"))

(defgeneric draw (a) (:documentation "draw on graphviz"))
(defmethod draw ((g (eql nil)))
  (error "We do not draw NULL graph"))
(defmethod draw ((g graph))
  ;; filename, extension and options
  (let* ((filename "the-graph")
         (extension "svg")
         (gv-file (format nil "/tmp/~A.gv" filename))
         (the-file(format nil "/tmp/~A.~A" filename extension))
         (options (list
                   (format nil "-T~A" extension)
                   gv-file
                   "-o"
                   the-file)))
    (format t "dot options ~A~%" options)

    ;; create gv file
    (with-open-file (stream gv-file :direction :output :if-exists :supersede)
      (write-sequence (digraph g) stream))

    ;; draw graphical output
    (let ((outcome (sb-ext:run-program "/usr/bin/dot" options)))
      ;; report outcome of drawing
      (format t "~&~A~%"
              (if (eq 1 (sb-impl::process-exit-code outcome))
                  "We had a problem, possibly invalid dot file generated"
                  "All went OK")))))
