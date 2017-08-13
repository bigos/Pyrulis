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

(defun replace-all-old (string part replacement &key (test #'char=))
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

(defun replace-all (str pat replacement)
  (let ((patpos (search pat str)))
    (if (null patpos)
        str
        (let ((pre (subseq str 0 patpos))
              (post (subseq str (+ patpos (length pat)))))
          (concatenate 'string pre replacement (replace-all post pat replacement))))))

(defvar *rules* '(("1_" . "1++")
                  ("0_" . "1")
                  ("01++" . "10")
                  ("11++" . "1++0")
                  ("_0" . "_")
                  ("_1++" . "10")))

(defvar *data* "_111_")

(defun matching-rules (data)
  (loop for r in *rules*
        when (search (car r) data) collect r))

(defun execute (data)
  (format t "data ~s~%" data)
  (let ((m (matching-rules data)))
    (when m
      (execute
       (replace-all data
                    (caar (matching-rules data))
                    (cdar (matching-rules data)))))))
