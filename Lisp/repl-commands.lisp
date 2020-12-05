;;; https://graphviz.org/documentation/       - index
;;; https://graphviz.org/doc/info/attrs.html  - attributes
;;; https://graphviz.org/doc/info/lang.html   - language

(declaim (optimize (debug 3) (speed 0)))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(draw-cons-tree)))

(defun dt (l)
  (draw-cons-tree:draw-tree l))

;;; === keyboard shortcuts =====================================================
(defparameter keys-shortcuts-list  '(("i" com-init)
                                     ("p" com-print "print model")
                                     ("h" com-help)
                                     ("a" com-add)
                                     ("l" com-link)
                                     ("r" com-redraw)
                                     ("d" com-delete "delete node")
                                     ("k" com-kill "delete link")
                                     ("quit" com-quit)))
(defun keys-shortcuts-hash ()
  (let ((key-hash (make-hash-table :test 'equalp)))
    (loop for kv in keys-shortcuts-list
          do (setf (gethash (car kv) key-hash) (cadr kv)))
    key-hash))

(defparameter *keys* (keys-shortcuts-hash))

(defun keys-reload ()
  (setf *keys* (keys-shortcuts-hash)))

(defun keys-command (key)
  (gethash key *keys*))

;;; === model ==================================================================

(defparameter *model* nil)

;;; ----- adding nodes

(defun model-init ()
  (setf *model* '(("state1" "state2" "transition"))))

(defun model-add ()
  (format t "enter new node name > ")
  (let ((nn (read-line)))
    (push nn *model*)))

(defun model-link ()
  (format t "enter start link node name > ")
  (let ((ns (read-line)))
    ;; remove all atoms matching ns
    (setf *model* (delete ns *model* :test #'equalp))
    (format t "enter end link node name > ")
    (let ((ne (read-line)))
      ;; remove all atoms matching ne
      (setf *model* (delete ne *model* :test #'equalp))
      (format t "enter link label > ")
      (let ((ll (read-line)))
        (if (equalp ll "")
            (push (list ns ne) *model*)
            (push (list ns ne ll) *model*))))))

(defun delete-matcher (node x)
  (cond ((and (atom x)
              (equalp node x))
         nil)
        ((and (consp x)
              (equalp node (car  x))
              (equalp node (cadr x)))
         nil)
        ((and (consp x)
              (equalp node (car  x)))
         (cadr x))
        ((and (consp x)
              (equalp node (cadr  x)))
         (car x))
        (T
         x)))

(defun model-delete ()
  (format t "enter DELETED node name > ")
  (let ((node (read-line)))
    (setf *model* (remove-duplicates
                   (remove-if #'null
                              (mapcar (lambda (x)
                                        (delete-matcher node x))
                                      *model*))
                   :test #'equalp))))

(defun model-kill ()
  (format t "model-kill not implemented~%"))

;;; ----- printing and redrawing

(defun model-print ()
  (format T "=== ~S~%" *model*)
  *model*)

(defun node-print (n)
  (cond
    ((atom n)
     (format nil "~A~%" n))
    ((consp n)
     (if (caddr n)
         (format nil "~A -> ~A [label=\"~A\"]~%" (car n) (cadr n) (caddr n))
         (format nil "~A -> ~A~%" (car n) (cadr n))))
    (t
     (format nil "~A~%" n))))

(defun model-as-gv ()
  (format nil "digraph m {~%~A~&}~%"
          (reduce (lambda (a b) (concatenate 'string a b) )
                  (loop for n in *model*
                        collect (node-print n))
                  :initial-value "")))

(defun model-redraw ()
  (let ((filename "my-graph"))
    (let ((gv-file  (format nil "/tmp/~A.gv"  filename))
          (png-file (format nil "/tmp/~A.png" filename)))
      ;; write nodes to gv
      (with-open-file (stream gv-file :direction :output :if-exists :supersede)
        (write-sequence (model-as-gv) stream))
      ;; redraw image
      (sb-ext:run-program "/usr/bin/dot" (list "-Tpng" gv-file "-o" png-file)))))

;;; === commands ===============================================================

(defun com-init ()
  (model-init)
  (model-redraw))

(defun com-add ()
  (model-add)
  (model-redraw))

(defun com-link ()
  (model-print)
  (model-link)
  (model-redraw))

(defun com-delete ()
  (model-delete)
  (model-redraw))

(defun com-kill ()
  (model-kill)
  (model-redraw))

(defun com-redraw ()
  (model-redraw))

(defun com-print ()
  (model-print))

(defun com-help ()
  (format t "key  command ----~%")
  (loop for x in keys-shortcuts-list
        do (format t "~A~%" x)))

(defun com-quit ()
  (format t "quitting now...~%~%")
  'quit-main-loop)

;;; === loop ===================================================================

(defun my-loop ()
  (let ((prompt "~& > "))
    (format t prompt)
    (loop for input = (read-line)
          until (eq 'quit-main-loop     ;com-quit returns 'quit-main-loop
                    (let ((command (keys-command input)))
                      (if command
                          (funcall command)
                          (format t "unrecognised command entered~%"))))
          do
             (format t prompt))))
