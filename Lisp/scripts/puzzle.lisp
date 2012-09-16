;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.


(defun read-lines (file-path)
  (let ((structures))
    (with-open-file (stream file-path)
      (do ((line (read-line stream nil)
		 (read-line stream nil)))
	  ((null line))
	(setq structures (concatenate 'list structures (list line)))))
    (car (list  structures)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun main ()
    (let* ((file-path "/home/jacek/Programming/PuzzleTest/data.txt"))
      (format T "~S~%" (read-lines file-path))
      )))

