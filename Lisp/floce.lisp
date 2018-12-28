(defun floce (n f )
  (let* ((z f)
         (fa (floor (/ n f)))
         (ca (ceiling (/ n f))))
    (list n (* z fa) (* z ca))))

(format t "ticker ~A~%"
        (loop for x from 0 to 40 collect (floce x 10)))
