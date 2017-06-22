;;; simple lisp parser

;;; basic utilities

(defun tokenize (str)
  (loop for c across str collect c))

(defun char-in (c cl)
  "Check if the character C belongs to CL."
  (loop for cc in cl
     for r = (eq cc c) ; consider different test
     until r
     finally (return r)))

(defun char-within (c c-from c-to)
  (char<= c-from c c-to))

(defun whitespace (c)
  (char-in c '(#\Space #\Tab)))

(defun num (c)
  (char-in c (tokenize "0123456789")))

(defun letter-lower (c)
  (char-within c #\a #\z))

(defun letter-upper (c)
  (char-within c #\A #\Z))

(defun operator
    (char-in c (tokenize "+-*/")))
