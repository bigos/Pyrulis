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

(defparameter *simple-grammar*
  '((sentence -> (noun-phrase verb-phrase))
    (noun-phrase -> (article noun))
    (verb-phrase -> (verb noun-phrase))
    (article -> the a)
    (noun -> man ball woman table)
    (verb -> hit took saw liked))
  "A grammar for a trivial subset of English")

(defvar *grammar* *simple-grammar*
  "The grammar used by generate. Initially this is
  *simple-grammar*, but we can switch to other grammars.")

(defun rule-lhs (rule)
  "The left hand side of the rule"
  (first rule))

(defun rule-rhs (rule)
  "The right hand side of the rule"
  (rest (rest rule)))

(defun rewrites (category)
  "Return list of possible rewrites for this category"
  (rule-rhs (assoc category *grammar*)))

(defun mappend (fn the-list)
  "Apply fn to each element of list and append the results"
  (apply #'append (mapcar fn the-list)))

(defun generate (phrase)
  "Generate random sentence or phrase"
  (cond ((listp phrase)
         (mappend #'generate phrase))
        ((rewrites phrase)
         (generate (random-elt (rewrites phrase))))
        (T (list phrase))))
