;;
;; (loop for l = (read-line)
;;    until (eq 42 (parse-integer l))
;; do
;; (format t "~a~%" l))

(defun multiple5p (n)
  (zerop (mod n 5)))

(defun parse-string-to-float (line)
  (with-input-from-string (s line)
    (loop
       :for num := (read s nil nil)
       :while num
       :collect num)))

(defun solution ()
  (let* ((inp (parse-string-to-float (read-line)))
         (fee 0.50)
         (want (nth 0 inp))
         (balance (nth 1 inp)))
    ;;(format t "~s ~S~%" want balance)
    (when (and (multiple5p want)
               (<= (+ want fee) balance))
      (setf balance (- balance (+ want fee))))
    (format nil "~$" balance)))

(format t "~a" (solution))
