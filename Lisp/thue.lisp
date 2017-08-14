;;; thue grammar toy

(defun replace-all (str pat replacement)
  (let ((patpos (search pat str)))
    (if (null patpos)
        str
        (let ((pre (subseq str 0 patpos))
              (post (subseq str (+ patpos (length pat)))))
          (concatenate 'list pre replacement (replace-all post pat replacement))))))

(defparameter *rules* '(((1 _) (1 ++))
                        ((0 _) (1))
                        ((0 1 ++) (1 0))
                        ((1 1 ++) (1 ++ 0))
                        ((start 0) (start))
                        ((start 1 ++) (1 0))))

(defparameter *data* '(start 1 1 1 _))

(defun matching-rule (data)
  (let ((rules (loop for r in *rules*
                     when (search (car r) data)
                       collect r)))
    (when rules
      (elt rules (random (length rules))))))

(defun execute (data &optional (count 0))
  (if (>= count 20)
      (format t "~&warning: end of stack protection reached")
      (progn
        (format t "data ~s~%" data)
        (let ((m (matching-rule data)))
          (when m
            (execute
             (replace-all data
                          (car m)
                          (cadr m))
             (1+ count)))))))
