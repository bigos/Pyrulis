(defun show-file (fn)
  (with-open-file (s fn)
    (loop for line = (read-line s nil)
       until (eq line nil)
       do
         (format t "~A~%" line))))

(defun main (load-args)
  (format t "log parser ~A~%" load-args)

  (show-file load-args))
