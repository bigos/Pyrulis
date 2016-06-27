(defun separatorp (c)
  (notevery 'null (mapcar (lambda (x) (eq x c))
                          '(#\Space #\. #\, #\?))))

(defun split (str &optional (from 0) (cursor 0) acc)
  (labels ((at-cursor ()
             (elt str cursor))
           (acc-apend ()
             (append acc (list (subseq str from cursor)))))
    (if (>= cursor (length str))
        (if (>= from (length str))
            acc
            (acc-apend) )
        (if (separatorp (at-cursor))
            (split str (1+ cursor) (1+ cursor )
                   (if (eq from cursor)
                       acc
                       (acc-apend)))
            (split str from (1+ cursor )
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
    (last-name-inner (split str))))

(princ (last-name "Rex Morgan MD,"))
