
(define (f-recursive n)
    (if (< n 3)
        n
        (+ (f-recursive (- n 1)) (* 2 (f-recursive (- n 2))) (* 3 (f-recursive (- n 3))) )))

(define (f-iter a b c n)
    (if (= n 0)
        c
        (f-iter b c (+ (* 3 a) (* 2 b) c) (- n 1))))

(define (f n)
    (if (< n 3)
        n
        (f-iter 0 1 2 (- n 2))))