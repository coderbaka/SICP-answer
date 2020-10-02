
(define (make-accumulator num)
    (lambda (x) 
        (begin (set! num (+ num x)) num)))

;-- test --
(define A (make-accumulator 10))
(A 10)
(A 15)
(A (- 10))