;;; thue grammar toy

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

(defun matching-rule (data)
  (car
   (loop for r in *rules*
         when (search (car r) data)
           collect r)))

;;; this is different from Thue language, because we apply the first rule found
;;; the original uses random selected from possibly multiple matched rules
(defun execute (data)
  (format t "data ~s~%" data)
  (let ((m (matching-rule data)))
    (when m
      (execute
       (replace-all data
                    (car m)
                    (cdr m))))))
