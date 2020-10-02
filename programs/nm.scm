
(define dx 0.00001)

(define (fixed-point f fisrt-guess)
    (define tolerance 0.00001)
    (define (close-enough? v1 v2)
        (< (abs (- v1 v2))
            tolerance))
    (define (try guess)
        (let ((next (f guess)))
            (if (close-enough? guess next)
                next
                (try next))))
    (try fisrt-guess))

(define (deriv g)
    (lambda (x) (/ (- (g (+ x dx)) (g x)) dx)))

(define (newton-transform g)
    (lambda (x) (- x (/ (g x) ((deriv g) x)))))

(define (newton-method g guess)
    (fixed-point (newton-transform g) guess))

(define (sqrt x)
    (newton-method (lambda (y) (- (square y) x)) 1.0))

(define (cubic a b c)
    (lambda (x) (+ (* x x x) (* a x x) (* b x) c)))

(define (cubic-solve a b c)
    (newton-method (cubic a b c) 1.0))


