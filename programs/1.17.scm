
(define (double x)
    (+ x x))

(define (halve x)
    (/ x 2))

(define (multiply x y)
    (cond ((= y 1) x)
          ((even? y) (multiply (double x) (halve y)))  
          (else (+ x (multiply (double x) (halve (- y 1)))))))