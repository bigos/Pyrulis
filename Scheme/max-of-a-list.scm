(define (max-of-list-1 lst)
  (cond
   [(= (length lst) 0) (error "Empty list")]
   [(= (length lst) 1) (first lst)]
   [else (max (first lst) (max-of-list-1 (rest lst)))]))
