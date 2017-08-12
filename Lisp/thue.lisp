;;; thue grammar toy

(defstruct rule
  lhs
  rhs)

(defun is-space (s)
  (some (lambda (x)
          (equalp x #\space))
        s))

(defun find-all (s pattern &optional acc)
  (let ((f (search pattern s :start2 (1+ (or (car acc)
                                             -1)))))
    (if (null f)
        (reverse acc)
        (find-all s pattern (cons f acc)))))

(defun replace-all (string part replacement &key (test #'char=))
  "Returns a new string in which all the occurences of the part
is replaced with replacement."
  (with-output-to-string (out)
    (loop with part-length = (length part)
          for old-pos = 0 then (+ pos part-length)
          for pos = (search part string
                            :start2 old-pos
                            :test test)
          do (write-string string out
                           :start old-pos
                           :end (or pos (length string)))
          when pos do (write-string replacement out)
            while pos)))

(defun replace-substring (str pat replacement)
  (let ((patpos (search pat str)))
    (when patpos
      (let ((pre (subseq str 0 patpos))
            (post (subseq str (+ patpos (length pat) 0))))
        (concatenate 'string pre replacement post)))))

(defun replace-all-ng (str pat replacement)
  (let ((patpos (search pat str)))
    (if (null patpos)
        str
        (let ((pre (subseq str 0 patpos))
              (post (subseq str (+ patpos (length pat)))))
          (concatenate 'string pre replacement (replace-all-ng post pat replacement))))))
