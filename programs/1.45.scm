
(define (repeated f n)
    (if (= n 1)
        f
        (compose f (repeated f (- n 1)))))

(define (fixed-point f fisrt-guess)
    (define tolerance 0.00001)
    (define (close-enough? v1 v2)
        (< (abs (- v1 v2))
            tolerance))
    (define (try guess)
        (newline)
        (display guess)
        (let ((next (f guess)))
            (if (close-enough? guess next)
                next
                (try next))))
    (try fisrt-guess))

(define (average-dump f)
    (lambda (x) (/ (+ x (f x)) 2)))

(define (n-times x n)
    (if (= n 0)
        1
        (* x (n-times x (- n 1)))))

(define (log2 x)
    (/ (log x) (log 2)))

(define (n-root x n)
    (fixed-point 
        ((repeated average-dump (floor (log2 n))) (lambda (y) (/ x (n-times y (- n 1)))) ) 1.0))

(define (test-n-root c)
    (newline)
    (display c)
    (n-root (n-times 2 c) c)
    (read-line)
    (test-n-root (+ c 1)))

(test-n-root 16)