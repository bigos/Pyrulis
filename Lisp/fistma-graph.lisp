(declaim (optimize (speed 1) (debug 0)))

#| loading
(load "~/Programming/Pyrulis/Lisp/fistma-graph.lisp")
(in-package #:fistma-graph)
(draw-graph *graph*)
|#

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(serapeum)))

(defpackage #:fistma-graph
  (:use #:cl)
  (:local-nicknames (#:se #:serapeum)))

(in-package #:fistma-graph)

(defparameter *graph*
  ;; source action target
  '(
    (closed lock locked)
    (closed open opened)
    (locked "un lock" closed)
    (opened close closed)

    ))

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
  (let ((filename "fis-graph")
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
