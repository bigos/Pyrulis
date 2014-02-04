(defun solution ()
  (let ((n (read))
        (k (read))
        (c 0))
    ;;(format t "~s ~s~%" n k)
    (loop for x from 2 to (1+ n)
       do
         (if (zerop (mod (parse-integer (read-line)) k))
             (incf c)))
    c))

(format t "~a" (solution))
