;;; 1.1 -----------------------------------------
(defun separatorp (c)
  (notevery 'null (mapcar (lambda (x) (eq x c))
                          '(#\Space #\. #\, #\?))))

(defun split (str &optional (from 0) (cursor 0) acc)
  (labels ((at-cursor () (elt str cursor))
           (acc-apend () (append acc (list (subseq str from cursor)))))
    (if (>= cursor (length str))
        (if (>= from (length str))
            acc
            (acc-apend) )
        (if (separatorp (at-cursor))
            (split str (1+ cursor) (1+ cursor)
                   (if (eq from cursor)
                       acc
                       (acc-apend)))
            (split str from (1+ cursor)
                   acc)))))

(defun titlep (s)
  (notevery 'null
       (mapcar (lambda (x) (equalp s x)) '("MD" "Jr"))))

(defun last-name (str)
  (labels ((last-name-inner (l)
             (if (and (> (length l) 1)
                      (titlep (car (last l))))
                 (last-name-inner (butlast l))
                 (last l))))
    (car (last-name-inner (split str)))))

(format t "~A~%" (last-name "Rex Morgan MD,"))

;;; 1.2 -----------------------------------------
(defun power (x p)
  (cond ((= p 0) 1)
        (T (apply '* (loop for i from 1 to p collect x)))))


(format t "~A~%" (power 3 2))

;;; 1.3 -----------------------------------------
(defun count-atoms (l)
  (cond ((null l) 0)
        ((atom l) 1)
        (T (+ (count-atoms (car l))
              (count-atoms (cdr l))))))

(format t "~A~%" (count-atoms '(a (b) c)))

;;; 1.4 -----------------------------------------
(defun count-anywhere (e l)
  (cond ((null l) 0)
        ((equalp e l) 1)
        ((atom l) 0)
        (T (+ (count-anywhere e (car l))
              (count-anywhere e (cdr l))))))

(format t "~A~%" (count-anywhere 'a '(a ((a) b) a)))

;;; 1.5 -----------------------------------------
(defun dot-product (a b &optional (acc 0))
  (if (not (and a b))
      acc
      (dot-product (cdr a)
                   (cdr b)
                   (+ acc (* (car a) (car b))))))
