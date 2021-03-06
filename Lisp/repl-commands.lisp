;;; https://graphviz.org/documentation/       - index
;;; https://graphviz.org/doc/info/attrs.html  - attributes
;;; https://graphviz.org/doc/info/lang.html   - language

;; (declaim (optimize (debug 3) (speed 0)))

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
                                     ("n" com-name "rename node")
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
  (format t "enter name of the link parent node > ")
  (let* ((node (read-line))
         (links (loop for n in *model*
                      when (and (consp n) (equalp node (car n)))
                        collect n)))
    (when links
      (format t "we can remove following links:~%")
      (loop for l in links
            for n = 0 then (1+ n)
            do (format t "~a ~A~%" n l))
      (format t "Please enter the NUMBER of the link to kill > ")
      (let* ((deleted-number (parse-integer (read-line)))
             (deleted-part (elt links deleted-number)))
        (format t "we are going to delete ~A~%" deleted-part)

        (remove-if #'null
                   (setf *model*
                         (remove-duplicates (mapcar
                                             (lambda (x)
                                               (if (and (consp x)
                                                        (equalp deleted-part x))
                                                   (car x)
                                                   x))
                                             *model*)
                                            :test #'equalp)))))))

(defun rename-matcher (node x newname)
  (format t "==== ~A~%" x)
  (cond ((and (atom x)
              (equalp node x))
         newname)
        ((and (consp x)
              (equalp node (car  x))
              (equalp node (cadr x)))
         (list newname newname (caddr x)))
        ((and (consp x)
              (equalp node (car  x)))
         (list newname (cadr x) (caddr x)))
        ((and (consp x)
              (equalp node (cadr  x)))
         (list (car x) newname (caddr x)))
        (T
         x)))

(defun model-name ()
  (format t "enter RENAMED node name > ")
  (let ((node (read-line)))
    (format t "enter NEW node name > ")
    (let ((newname (read-line)))
      (setf *model*
            (mapcar (lambda (x)
                      (rename-matcher node x newname))
                    *model*)))))

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

(defun com-name ()
  (model-name)
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
