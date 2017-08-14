;;; thue grammar toy

(defparameter *rules* '(((1 _) (1 + +))
                        ((0 _) (1))
                        ((0 1 + +) (1 0))
                        ((1 1 + +) (1 + + 0))
                        ((_ 0) (_))
                        ((_ 1 + +) (1 0))))

(defparameter *data* '(_ 1 1 1 _))


;;; semi-thue version of 10 saussages
(defparameter *my-rules* '(((start) (10 saussages frying in the pan))

                           ((10 saussages frying in the pan) (10 saussages one goes bang))
                           ((10 saussages one goes bang) (9 saussages frying in the pan))

                           ((9 saussages frying in the pan) (9 saussages one goes bang))
                           ((9 saussages one goes bang) (8 saussages frying in the pan))

                           ((8 saussages frying in the pan) (8 saussages one goes bang))
                           ((8 saussages one goes bang) (7 saussages frying in the pan))

                           ((7 saussages frying in the pan) (7 saussages one goes bang))
                           ((7 saussages one goes bang) (6 saussages frying in the pan))

                           ((6 saussages frying in the pan) (6 saussages one goes bang))
                           ((6 saussages one goes bang) (5 saussages frying in the pan))

                           ((5 saussages frying in the pan) (5 saussages one goes bang))
                           ((5 saussages one goes bang) (4 saussages frying in the pan))

                           ((4 saussages frying in the pan) (4 saussages one goes bang))
                           ((4 saussages one goes bang) (3 saussages frying in the pan))

                           ((3 saussages frying in the pan) (3 saussages one goes bang))
                           ((3 saussages one goes bang) (2 saussages frying in the pan))

                           ((2 saussages frying in the pan) (2 saussages one goes bang))
                           ((2 saussages one goes bang) (1 saussages frying in the pan))

                           ((1 saussages frying in the pan) (1 saussages one goes bang))
                           ((1 saussages one goes bang) (no saussages left))))

(defparameter *my-data* '(start))


(defun replace-all (str pat replacement)
  (let ((patpos (search pat str)))
    (if (null patpos)
        str
        (let ((pre (subseq str 0 patpos))
              (post (subseq str (+ patpos (length pat)))))
          (concatenate 'list pre replacement (replace-all post pat replacement))))))

(defun matching-rule (data rules)
  (let ((rules (loop for r in rules
                     when (search (car r) data)
                       collect r)))
    (when rules
      ;; (format t "rules ~A~%" rules)
      (first rules)
      ;; (elt rules (random (length rules)))
      )))

(defun execute (data rules &optional (count 0))
  (if (>= count 60)
      (format t "~&warning: end of stack protection reached")
      (progn
        (format t "data ~s~%" data)
        (let ((m (matching-rule data rules)))
          (when m
            (execute
             (replace-all data
                          (car m)
                          (cadr m))
             rules
             (1+ count)))))))
