;;;
(declaim (optimize (speed 0) (safety 2) (debug 3)))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(s-graphviz)))

;; (load "~/Programming/Pyrulis/Lisp/editable-graph-editor.lisp")

(defun connections ()
  (list
   (list '(hmm ((:shape "hexagon") (:color "red")))
         (list '(start ((:label "start again?")))))
   (list 'start
         (list 'empty_graph))
   (list 'empty_graph
         (list '(hmm ((:label "quit")))
               '(nodes ((:label "add_node")))))
   (list 'nodes
         (list '(nodes ((:label "add_node")))
               '(empty_graph ((:label remove_last_node)))
               '(quit_areyousure ((:label quit)))))
   (list 'quit_areyousure
         (list '(hmm ((:label yes)))
               '(nodes ((:label no)))))
   ))

(defun for-node (n)
  (list
   (if (symbolp n)
       (list n)
       (cons (first n) (second n)))))

(defun for-links (n lx)
  (let ((n1 (if (symbolp n)
                n
                (first n))))
    (loop for l in lx collect
          (if (symbolp l)
              (list :-> nil        n1  l)
              (list :-> (second l) n1 (first l))))))

(defun for-connection (c)
  (let ((n (first c))
        (lx (second c)))
    (let ((flx (for-links n lx)))

      (if flx
          (list (for-node n) flx)
          (list (for-node n))))))

(defun digraph ()
  (append '(:digraph nil)
          (mapcan #'identity
                  (mapcan (lambda (x)
                            (if (symbolp (caar x))
                                (list  (first x))
                                (second x))
                            x)
                          (loop for c in (connections)
                                collecting (for-connection c))))))

(defun draw-graph (name)
  (multiple-value-bind (ignore1 ignore2 code)
      (s-graphviz:render-graph
       (format nil
               "/tmp/editable-graph-editor-~A.svg"
               name)
       (digraph))
    (declare (ignore
              ignore1 ignore2))
    (format t "~A~%"
            (if (zerop code)
                "generated the graph"
                "error - please check the generated dot file for clues"))))

(draw-graph "connections")
