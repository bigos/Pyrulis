;;; parsing ip numbers, arguments to grammar nodes are either seq or alt
(defparameter better-grammar '((s (seq ip))
                               (ip (seq num dot num dot num dot num))
                               (dot (alt
                                     #\.))
                               (num (seq dig dig dig))
                               (dig (alt
                                     #\0
                                     #\1
                                     #\2
                                     #\3
                                     #\4
                                     #\5
                                     #\6
                                     #\7
                                     #\8
                                     #\9))))

(defun invalid-nodes (grammar)
  (loop for p in grammar
        for res = (and (symbolp (car p))
                       (symbolp (caadr p))
                       (> (length (cadr p)) 1))
        unless res collect p))

(defun find-node (grammar node)
  (loop for p in grammar
        for res = (equalp (car p) node)
        until res
        finally (return (when res p))))

(defun node-value (grammar node)
  (cadr (find-node grammar node)))

(defun node-value-type (grammar node)
  (car (node-value grammar node)))

(defun find-character (grammar character)
  (loop for p in grammar
        for res = (cadr p)
        when (some (lambda (x) (eq x character)) res)
          collect (list (car p)
                        (caadr p))))
