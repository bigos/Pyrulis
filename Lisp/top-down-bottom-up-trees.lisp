;;; tree traversal

(defparameter tr '((s
                    (num
                     (dig
                      (1))
                     (diga
                      (da
                       (2a))
                      (da
                       (2b))))
                    (op
                     (+))
                    (num
                     (dig
                      (3))))))

;;; bottom up - (bu tr)
(defun bu(tr)
  (if (consp (car tr))
      (bu (car tr) ))
  (if (consp (cdr tr))
      (progn
        (when (consp (car tr))
          (format t "dt ~a ~%" (car tr)))
        (bu (cdr tr)))
      (progn
        (when (consp (car tr))
          (format t "de ~a ~%" (car tr))))))

;;; top down - (td (car tr))
(defun td (tr)
  (if (consp (car tr))
      (td (car tr)))
  (if (consp (cdr tr))
      (progn
        (unless (consp (car tr))
          (format t "dt ~a~%" tr))
        (td (cdr tr)))
      (progn
        (unless (consp (car tr))
          (format t "de ~a~%" tr)))))

(bu tr)
(format t "^-bottom-up    top-down-v~%")
(td (car tr))
