;;; simple lisp parser

(defparameter grammar '((s     seq num op num )
                        (op    alt #\+ #\- #\* #\/)
                        (num   seq digit)
                        (digit alt #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9)))
(defparameter ast '(s
                    (num
                     (digit 1)
                     (digit 2))
                    (op +)
                    (num
                     (digit 2)
                     (digit 3))))

(defun grammar-elements ()
  (let ((keys)
        (types)
        (values))
    (mapcar (lambda (x)
              (push (car  x) keys)
              (push (cadr x) types)
              (push (cddr x) values))
            grammar)
    (list
     'keys keys
     'types (remove-duplicates types)
     'values values)))

(defun valid-types ()
  (let ((known-types '(alt seq)))
    (every (lambda (x)good

             (member x known-types))
           (getf (grammar-elements)
                 'types))))

(defun terminal-values ()
  (let ((elements (grammar-elements))
        (terminal)
        (keys))
    (mapcar (lambda (vl)
              (mapcar (lambda (v)
                        (if (member v (getf elements 'keys))
                            (push v keys)
                            (push v terminal)))
                      vl))
            (getf elements 'values))
    (list 'terminal (remove-duplicates terminal)
          'keys (remove-duplicates keys))))

(defun key-definition (k)
  (find k grammar :key 'car))

(defun terminal-definitions (v)
  (let ((definitions))
    (mapc (lambda (vl)
            (when (member v (cddr vl))
              (push vl definitions)))
          grammar)
    definitions))

(defun terminal-path-inner (v &optional acc)
  (let ((td (terminal-definitions v)))
    (if (null td)
        acc
        (terminal-path-inner (caar td)
                       (cons (caar td)
                             acc)))))

(defun terminal-path (v)
  (terminal-path-inner v (list v)))

;;; basic utilities

(defun tokenize (str)
  (loop for c across str collect c))

(defun char-in (c cl)
  "Check if the character C belongs to CL."
  (member c cl))

(defun char-within-range (c c-from c-to)
  (char<= c-from c c-to))

(defun string-to-paths (str)
  "Convert STR to a list of grammar paths"
  (loop for c across str collect (terminal-path c)))

;;; character predicates

(defun whitespace (c)
  (char-in c '(#\Space #\Tab)))

(defun num (c)
  (char-in c (tokenize "0123456789")))

(defun letter-lower (c)
  (char-within-range c #\a #\z))

(defun letter-upper (c)
  (char-within-range c #\A #\Z))

(defun operator (c)
  (char-in c (tokenize "+-*/")))

;;; token consumers
