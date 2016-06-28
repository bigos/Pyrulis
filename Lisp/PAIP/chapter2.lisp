(defun sentence ()    (append (noun-phrase) (verb-phrase)))
(defun noun-phrase () (append (article) (noun)))
(defun verb-phrase () (append (verb) (noun-phrase)))
(defun article ()     (one-of '(the a)))
(defun noun ()        (one-of '(man woman table)))
(defun verb ()        (one-of '(hit took saw liked)))

(defun one-of (set)
  "Pick one element of set and make a list of it"
  (list (random-elt set)))

(defun random-elt (choices)
  "Choose an element from a list at random"
  (elt choices (random (length choices))))
