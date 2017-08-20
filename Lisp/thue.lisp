;;; thue grammar toy

(defparameter *rules* '(((1 _) (1 ++))
                        ((0 _) (1))
                        ((0 1 ++) (1 0))
                        ((1 1 ++) (1 ++ 0))
                        ((start 0) (start))
                        ((start 1 ++) (1 0))))

(defparameter *data* '(start 1 1 1 _))

;; run
;; (execute *my-data* *my-rules*)

(defun replace-all (lst pat replacement)
  (subst replacement pat lst :test #'equalp))

(defun rule-match (rules data)
   (loop for r in rules
         for res = (replace-all (or res data) (car r) (cadr r))
         do (format t "~A ~A~%" r res)
         while (equalp res data)
         finally (return (if (equalp res data)
                             nil
                             res))))
