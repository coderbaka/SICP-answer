
(define (cons x y)
    (* (expt 2 x) (expt 3 y)))

(define (has-factors x n)
    (define (iter result c)
        (if (= (remainder c n) 0)
            (iter (+ 1 result) (/ c n))
            result))
    (iter 0 x))

(define (car z)
    (has-factors z 2))

(define (cdr z)
    (has-factors z 3))

(define n (cons 5 7))