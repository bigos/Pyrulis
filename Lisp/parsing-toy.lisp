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

;;; character predicates

(defun whitespace (c)
  (char-in c '(#\Space #\Tab)))

(defun num (c)
  (char-in c (tokenize "0123456789")))

(defun letter-lower (c)
  (char-within c #\a #\z))

(defun letter-upper (c)
  (char-within c #\A #\Z))

(defun operator (c)
  (char-in c (tokenize "+-*/")))

;;; token consumers

(defun consume-1 (token-list character-predicate)
  "Consume 1 character from the TOKEN-LIST, examine it with the
CHARACTER-PREDICATE and return either nil for no match or unconsumed TOKEN-LIST
remainder."
  (when (funcall character-predicate (car token-list))
    (subseq token-list 1)))

(defun consume-0-1 (token-list character-predicate)
  "Allow 0 or 1 matches and return unconsumed TOKEN-LIST, if more matches found
return nil."
  (if (consume-1 token-list character-predicate)
      ;; 1st found try to see the 2nd can be found
      (if (consume-1 (cdr token-list) character-predicate)
          nil
          (cdr token-list))
      token-list))

(defun consume-1-or-more (token-list character-predicate)
  "Allow 1 or more matches, when 0 found return nil"
  (when (consume-1 token-list character-predicate)
    (consume-0-or-more (cdr token-list) character-predicate)))

(defun consume-0-or-more (token-list character-predicate)
  "Allow 0 or more matches, always return unconsumed list stop when no more matches"
  (if (consume-1 token-list character-predicate)
      (consume-0-or-more (cdr token-list) character-predicate)
      token-list))

;;; rule types

(defun alt (token-list alt-predicates)
  "Check if first of the TOKEN-LIST matches one of ALT-PREDICATES."
  (some (lambda (x) (funcall x (car token-list))) alt-predicates))
;; (alt (tokenize "1") '(num whitespace))

(defun succ (token-list succ-predicates)
  "Check if all successive SUCC-PREDICATES match successive TOKEN-LIST elements."
  (if (< (length token-list)
         (length succ-predicates))
      (error "Succ-predicates is longer than remaining token-list.")
      (every 'identity (loop for tk in token-list
                          for p in succ-predicates
                          collect (funcall p tk)))))
;; (succ (tokenize "1 a") '(num whitespace letter-lower))
