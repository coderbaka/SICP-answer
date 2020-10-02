
(define (double x)
    (+ x x))

(define (halve x)
    (/ x 2))

(define (*-iter x y a)
    (cond ((= y 1) (+ x a))
          ((even? y) (*-iter (double x) (halve y) a))
          (else (*-iter x (- y 1) (+ a x)))))

(define (* x y)
    (*-iter x y 0))