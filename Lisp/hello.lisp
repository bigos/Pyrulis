#! /usr/bin/sbcl --script

(format T "Hello World~%")

(defun range (start end)
  (labels ((range2 (s e a)
             (if (eq s (car a))
                 a
                 (range2 s e (cons (if (> s e)
                                       (1+ (car a))
                                       (1- (car a)))
                                   a)))))
    (range2 start end (list end))))
