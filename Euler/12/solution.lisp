;;;

(defun dividesp (n d)
  (zerop (mod n d)))

(defun divisors (n)
  (loop for x from 1 to n for y = (dividesp n x) when y collect x))

(defun divisors-len (n)
  (let* ((s1 (sqrt n))
         (s2 (floor s1))
         (sd (1+ (length
                  (loop
                     for x from 2 to s2
                     when (dividesp n x)
                     collect x)))))
    (cond ((eq n 1) 1)
          ((equalp s1 s2) (- (* 2 sd) 1))
          (T
           (* 2 sd)))))

(defun solution ()
  (loop for x = 0 then (1+ x)
     for y = x then (+ y x)
     for z = (divisors-len y)
     ;collect (list x y z)
     until (> z 500)
     finally (return y)))
