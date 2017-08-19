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

(defun find-rhs (grammar character)
  (loop for p in grammar
        for res = (cadr p)
        when (some (lambda (x) (eq x character)) res)
          collect (list (car p)
                        (caadr p)
                        (1- (length (cadr p))))))

(defun find-ancestors (grammar character prev &optional acc)
  "Get non ambiguous ancestors of the CHARACTER."
  (let ((rhs (find-rhs grammar character)))
    (if (eq (length rhs) 1)
        (find-ancestors grammar
                        (caar rhs)
                        prev
                        (cons (list character (car rhs)) acc))
          acc)))

(defun ambiguous-p (grammar character)
  (not (eq 's (car (find-ancestors grammar character)))))

(defun ambiguities (grammar character)
  (let ((d (find-ancestors grammar character)))
    (if (eq 's (car d))
        nil
        (find-rhs grammar character))))

(defun parse (grammar string)
  (loop
    for prev = nil then res
    for zn across string
    for res = (find-ancestors grammar zn prev)
    collect res))

;;; parsed representation of valid ip
(defun main ()
  (print
   (parse better-grammar "123.456.789.000")))

(main)
