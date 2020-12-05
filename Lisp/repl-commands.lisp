;;; https://graphviz.org/documentation/       - index
;;; https://graphviz.org/doc/info/attrs.html  - attributes
;;; https://graphviz.org/doc/info/lang.html   - language

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(draw-cons-tree)))

(defun dt (l)
  (draw-cons-tree:draw-tree l))

;;; === keyboard shortcuts =====================================================

(defun keys-shortcuts-hash ()
  (let ((key-hash (make-hash-table :test 'equalp)))
    (loop for kv in '(("i" . com-init)
                      ("p" . com-print)
                      ("h" . com-help)
                      ("a" . com-add)
                      ("l" . com-link)
                      ("r" . com-redraw)
                      ("d" . com-delete)
                      ("quit" . com-quit))

          do (setf (gethash (car kv) key-hash) (cdr kv)))
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
  (setf *model* (list 'ala 'ma 'kota)))

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

(defun delete-node (node model)
  (if (null (cdr model))
      (if (equalp node (car model))
          nil
          model)
      (cond ((and (consp (car model))
                  (equalp node (car model))
                  (equalp node (cadr model)))
             (delete-node node (cdr model)))
            ((and (consp (car model))
                  (equalp node (caar model)))
             (cons (cadar model) (delete-node node (cdr model))))
            ((and (consp (car model))
                  (equalp node (cadar model)))
             (cons (caar model) (delete-node node (cdr model))))

            ((and (atom (car model))
                  (equalp node (car model)))
             (delete-node node (cdr model)))
            (t
             (cons (car model) (delete-node node (cdr model)))))))

(defun model-delete ()
  (format t "enter DELETED node name > ")
  (let ((nn (read-line)))
    (setf *model* (delete-node nn *model*))))

;;; ----- printing and redrawing

(defun model-print ()
  (format T "=== ~A~%" *model*)
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
  (model-init))

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

(defun com-redraw ()
  (model-redraw))

(defun com-print ()
  (model-print))

(defun com-help ()
  (format t "key  command ----~%")
  (loop for x being the hash-key in (keys-shortcuts-hash) using (hash-value y)
        do (format t "~A ~A~%" x y)))

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
