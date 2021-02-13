(in-package #:graph-toy)

;;; === keyboard shortcuts =====================================================

;; commands from previous attempt
;; (defparameter keys-shortcuts-list  '(("i" com-init)
;;                                      ("p" com-print "print model")
;;                                      ("h" com-help)
;;                                      ("a" com-add)
;;                                      ("l" com-link)
;;                                      ("r" com-redraw)
;;                                      ("d" com-delete "delete node")
;;                                      ("k" com-kill "delete link")
;;                                      ("n" com-name "rename node")
;;                                      ("quit" com-quit)))

(defparameter keys-shortcuts-list  '(("h" com-help "help")
                                     ("quit" com-quit)
                                     ("list" com-list "get list of nodes for further experiments")
                                     ("r" com-redraw "redraw the graph")
                                     ("a" com-add "add node with empty link")
                                     ("l" com-link2 "add link for 2 nodes")
                                     ("ls" com-link2 "add link for 2 nodes by entering space separated element")
                                     ("k" com-kill "delete link")
                                     ("n" com-name "rename node")
                                     ("d" com-delete "delete node")))

(defun keys-shortcuts-hash ()
  (let ((key-hash (make-hash-table :test 'equalp)))
    (loop for kv in keys-shortcuts-list
          do (setf (gethash (car kv) key-hash) (cadr kv)))
    key-hash))

(defparameter *keys* (keys-shortcuts-hash))

(defun keys-reload ()
  (setf *keys* (keys-shortcuts-hash)))
(progn
  (format t "reloading keys~%")
  (keys-reload))

(defun keys-command (key)
  (gethash key *keys*))
