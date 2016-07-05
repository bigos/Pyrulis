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
  "Apply fn to each element of list and append the resulting lists
  into one list"
   (format t "~&mappend ~A ~A~%" fn the-list)
  (apply #'append (mapcar fn the-list)))

(defun generate (phrase)
  "Generate random sentence or phrase"
  (cond ((listp phrase)
         (mappend #'generate phrase))
        ((rewrites phrase)
         (generate (random-elt (rewrites phrase))))
        (T (list phrase))))

(defun generate (phrase)
  "Generate a random sentence or phrase"
  (if (listp phrase)
      (mappend #'generate phrase)
      (let ((choices (rewrites phrase)))
        (if (null choices)
            (list phrase)
            (generate (random-elt choices))))))

;;; exercise 2.1 p 66
(defun generate (phrase)
  "generate random sentence or phrase"
  (let ((rewritten (rewrites phrase)))
    (cond ((listp phrase)
           (mappend #'generate phrase))
          (rewritten
           (generate (random-elt rewritten)))
          (T (list phrase)))))

;;; exercise 2.2 p 66
(defun generate (phrase)
  "generate random sentence or phrase"
  (cond ((listp phrase)
         (mappend #'generate phrase))
        ((non-terminal-p phrase)
         (generate (random-elt (rewrites phrase))))
        (T (list phrase))))

(defun non-terminal-p (category)
  "True if this is a grammar category"
  (not (null (rewrites category))))

(defparameter *bigger-grammar*
  '((sentence -> (noun-phrase verb-phrase))
    (noun-phrase -> (article adj* noun pp*) (name) (pronoun))
    (verb-phrase -> (verb noun-phrase pp*))
    (pp* -> () (pp pp*))
    (adj* -> () (adj adj*))
    (pp -> (prep noun-phrase))
    (prep -> to in by with on)
    (adj -> big little blue green adiabatic)
    (article -> the a)
    (name -> pat kim terry robin)
    (noun -> man ball woman table)
    (verb -> hit took saw liked)
    (pronoun -> he she it these those that)))

;; (setf *grammar* *bigger-grammar*)
(setf *grammar* *simple-grammar*)

(defun generate-tree (phrase)
  "Generate a random sentence or phrase
  with a complete parse tree"
  (cond ((listp phrase)
         (mapcar #'generate-tree phrase))
        ((rewrites phrase)
         (cons phrase
               (generate-tree (random-elt (rewrites phrase)))))
        (T (list phrase))))

(defun generate-all (phrase)
  "Generate list of all possible expansions of this phrase"
  (cond ((null phrase) (list nil))
        ((listp phrase)
         (combine-all (generate-all (first phrase))
                      (generate-all (rest phrase))))
        ((rewrites phrase)
         (mappend #'generate-all (rewrites phrase)))
        (T (list (list phrase)))))

(defun combine-all (xlist ylist)
  "Return a list of lists formed by appending a y to an x.
  e.g. (combine-all '((a) (b)) '((1) (2)))
  -> ((A 1) (B 1) (A 2) (B 2))"
  (mappend #'(lambda (y)
               (mapcar #'(lambda (x) (append x y)) xlist))
           ylist))

;;; 2.7 Exercises
(defun cross-product (fn xlist ylist)
  "Return a list of all (fn x y) values."
  (mappend #'(lambda (y)
               (mapcar #'(lambda (x) (funcall fn x y))
                       xlist))
           ylist))

(defun combine-all (xlist ylist)
  "Return a list of lists formed by appending a y to an x"
  (cross-product #'append xlist ylist))
