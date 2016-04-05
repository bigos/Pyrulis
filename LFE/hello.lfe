;;; lfe examples to show off working rainbow-delimiters

(list '((((((((((((((((((nested list)))))))))))))))))))

(+ 1 (+ 2 (+ 3 0)))

(io:format "Hello World.~n")

(io:format "Hurray!!!~n")



;;; not working sbcl version
(defun loop-up (start end acc)
  (if (>= start end)
    (reverse acc)
    (loop-up (+ start 1) end (push start acc)))) 

;;; working lfe equivalent
(defun loop-up2 (start end)
  (lists:reverse (lists:foldl #'cons/2 '() (lists:seq start end)))) 
