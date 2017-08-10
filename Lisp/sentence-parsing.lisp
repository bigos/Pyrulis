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

(defun findstart (seq start)
  (loop for c across (subseq seq start)
        for index = start then (1+ index)
        for res = (notany (lambda (x) (eq c x))
                        '(#\Space #\Newline #\, #\.))
        until res
        finally (return (when res index))))

;;; mutually recursive functions
(defun rfs (seq start acc)
  (format t "rfs ~A ~A~%" start acc)
  (if (null start)
      (reverse acc)
      (rfn seq (findstart seq start) (cons (findstart seq start) acc))))

(defun rfn (seq start acc)
  (format t "rfn ~A ~A~%" start acc)
  (if (null start)
      (reverse acc)
      (rfs seq (findnext seq start) (cons (findnext seq start) acc))))

(defun ws (seq)
  (let ((ii (rfs seq 0 nil)))
    (loop for a in ii
          for b in (cdr ii)
          collect (subseq seq a (or b (1+ a))))))
