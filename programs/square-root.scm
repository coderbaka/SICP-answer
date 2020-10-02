
(define (square x)
    (* x x))

(define (sqrt-iter x guess)
    (if (good-enough?v2 guess (improve x guess))
        guess
        (sqrt-iter x (improve x guess))))

(define (good-enough? x guess)
    (< (abs (- x (square guess))) 0.001))

(define (good-enough?v2 old-guess new-guess)
    (< (abs (- old-guess new-guess)) (* old-guess 0.001)))

(define (improve x guess)
    (average guess (/ x guess)))

(define (average x y)
    (/ (+ x y) 2))

(define (sqrt x)
    (sqrt-iter x 1.0))   