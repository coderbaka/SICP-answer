
(define (fast-exp b n)
    (define (fast-exp-iter a b n)
        (cond ((= n 1) (* a b))
              ((even? n) (fast-exp-iter a (square b) (/ n 2)) )
              (else (fast-exp-iter (* a b) (square b) (/ (- n 1) 2)))))
    (fast-exp-iter 1 b n))