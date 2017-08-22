(defun seq (sequence start elements)
  "Check if the SEQUENCE at START contains sequence of ELEMENTS."
  (let ((end-index (+ start (length elements))))
    (and (< start (length sequence))
         (<= end-index (length sequence))
         (equalp (subseq sequence start end-index)
                 elements))))

(defun rep (sequence start min max element)
  "Check if the SEQUENCE at START contains ELEMENT repeated from MIN to MAX times."
  (let ((found (loop
                 for seen = 0 then (1+ seen)
                 for i from start below (length sequence)
                 while (and (<= seen max)
                            (equalp (elt sequence i) element))
                 finally (return seen))))
    (if (and (>= min found)
             (<= max found))
        found)))

(defun alt (sequence start elements)
  "Check if the SEQUENCE at START is one of the ELEMENTS."
  (some (lambda (x) (equalp x (elt sequence start)))
        elements))
