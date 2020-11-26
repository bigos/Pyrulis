;;; toy lisp
(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(draw-cons-tree)))

(defun dt (l)
  (draw-cons-tree:draw-tree l))

;;; ============================================================================

(defun keys-shortcuts-hash ()
  (let ((key-hash (make-hash-table :test 'equalp)))
    (loop for kv in '(("h" . com-help)
                      ("quit" . com-quit))

          do (setf (gethash (car kv) key-hash) (cdr kv)))
    key-hash))

(defparameter *keys* (keys-shortcuts-hash))

(defun keys-reload ()
  (setf *keys* (keys-shortcuts-hash)))

(defun keys-command (key)
  (gethash key *keys*))

;;; ============================================================================

(defun com-help ()
  (format t "key  command ----~%")
  (loop for x being the hash-key in (keys-shortcuts-hash) using (hash-value y)
        do (format t "~A ~A~%" x y)))

(defun com-quit ()
  (format t "doing quitting~%~%")
  'quit-main-loop)

;;; ============================================================================

(defun my-loop ()
  (let ((prompt "~&~% > "))
    (format t prompt)
    (loop for input = (read-line)
          until (eq (process input) 'quit-main-loop)
          do
             (format t prompt))))

(defun process (input)
  (let ((command (keys-command input)))
    (cond (command
           (funcall command)) ;; when input is quit 'quit-main-loop will return
          (T
           (format t "unrecognised command entered~%")))))
