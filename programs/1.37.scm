
(define (cont-frac n d k)
    (define (helper i)
        (if (= i k)
            (/ (n i) (d i))
            (/ (n i) (+ (d i) (helper (+ i 1))))))
    (helper 1))

(define (cont-frac-iter n d k)
    (define (iter c result)
        (if (< c 1) 
            result
            (iter (- c 1) (/ (n c) (+ (d c) result)))))
    (iter k 0))

(define (tan-cf x k)
    (cont-frac (lambda (i) (if (= i 1) x (- (square x))))
               (lambda (i) (- (* 2 i) 1))
               k))

(tan-cf (/ 3.14159 3) 100)