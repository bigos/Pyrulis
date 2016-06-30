(defun sentence ()    (append (noun-phrase) (verb-phrase)))
(defun article ()     (one-of '(the a)))
(defun noun-phrase () (append (article) (noun)))
(defun verb-phrase () (append (verb) (noun-phrase)))
(defun noun ()        (one-of '(man woman table)))
(defun verb ()        (one-of '(hit took saw liked)))

(defun one-of (set)
  "Pick one element of set and make a list of it"
  (list (random-elt set)))

(defun random-elt (choices)
  "Choose an element from a list at random"
  (elt choices (random (length choices))))

(defun adj* ()
  (if (= (random 2) 0)
      nil
      (append (adj) (adj*))))

(defun pp* ()
  (if (random-elt '(T nil))
      (append (pp) (pp*))
      nil))

(defun noun-phrase () (append (article) (adj*) (noun) (pp*)))
(defun pp () (append (prep) (noun-phrase)))
(defun adj () (one-of '(big little blue green adiabatic)))
(defun prep () (one-of '(to in by with on)))
