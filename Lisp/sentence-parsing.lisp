;;; a toy for experimenting wth parsing text

(defparameter sample-text "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.")

(ql:quickload :draw-cons-tree)

(draw-cons-tree:draw-tree '(sentence
                            (i i)
                            (like l i k e)
                            (lisp l i s p)))

(defun findnext (seq start)
  (loop for c across (subseq seq start)
        for index = start then (1+ index)
        for res = (some (lambda (x) (eq c x))
                        '(#\Space #\Newline #\, #\.))
        until res
        finally (return (when res index))))
