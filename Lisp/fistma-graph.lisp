(declaim (optimize (speed 0) (debug 3)))

#| loading
(load "~/Programming/Pyrulis/Lisp/fistma-graph.lisp")
(in-package #:fistma-graph)
(draw-graph *graph*)
(draw-graph (dot-links *nested*))
|#


(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria serapeum dot-cons-tree)))

(defpackage #:fistma-graph
  (:use #:cl)
  (:local-nicknames (#:se #:serapeum) (#:ax #:alexandria)))

(in-package #:fistma-graph)

(defparameter *graph*
  ;; source action target
  '((closed lock locked)
    (closed open opened)
    (locked "unlock" closed)
    (opened close closed)))

(defparameter *nested*
  ;; (source (action target))
  '((closed
     (lock locked)
     (open opened))
    (locked
     (unlock closed))
    (opened
     (close closed))))

(defun dot-links (l)
  "Take a nested graph L and convert it to list of links for draw-graph."
  (let ((a))
    (loop for s in l do
      (unless (atom (car s)) (error "Source must be an atom"))
      (loop for at in (cdr s) do
        (unless (atom (car  at)) (error "Action must be an atom"))
        (unless (atom (cadr at)) (error "Target must be an atom"))
        (push (cons (car s) at) a)))
    (reverse a)))

(defun sources ()
  (mapcar #'car *nested*))

(defun actions ()
  (ax:flatten
   (mapcar
    (lambda (x) (mapcar #'car (cdr x)))
    *nested*)))

(defun targets ()
  (ax:flatten
   (mapcar
    (lambda (x) (mapcar #'cdr (cdr x)))
    *nested*)))

(defun prepare-graph (data)
  "Take DATA and prepare a graph string."
  (with-output-to-string (g)
    (format g "digraph {~%")
    (loop for c in data do
      (format g "~A -> ~A [label=~S]~%"
              (nth 0 c)
              (nth 2 c)
              (nth 1 c)))
    (format g "}~%")))

(defun draw-graph (graph-string)
  (let ((filename "fistma-graph")
        (extension "svg"))
    (let ((gv-file (format nil "/tmp/~A.gv" filename))
          (the-file(format nil "/tmp/~A.~A" filename extension)))
      (let ((options (list
                      (format nil "-T~A" extension)
                      gv-file
                      "-o"
                      the-file)))
        (format t "dot options ~A~%" options)
        (with-open-file (stream gv-file :direction :output :if-exists :supersede)
          (write-sequence (prepare-graph graph-string) stream))
        (sb-ext:run-program "/usr/bin/dot" options)))))
