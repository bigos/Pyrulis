(defparameter squares (loop for x from 1 to 1000000
                         for y = (expt x 2)
                         when (<= y 1000000) collect y))

;;; find abc
(nthcdr 6
        (caar
         (remove-if 'null
                    (loop
                       for x in squares
                       for z = (loop
                                  for y in squares
                                  when (= (sqrt (+ x y))
                                          (floor (sqrt (+ x y))))
                                  collect (list (+ (sqrt x)
                                                   (sqrt y)
                                                   (sqrt (+ x y)))
                                                'abc x y (+ x y)
                                                'r (sqrt x)
                                                (sqrt y)
                                                (sqrt (+ x y))))
                       collect (remove-if (lambda (x)
                                            (not (equalp (car x)
                                                         1000)))
                                          z)))))
