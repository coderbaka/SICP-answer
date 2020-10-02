
(define (make-point x y)
    (cons x y))

(define (x-point x)
    (car x))

(define (y-point x)
    (cdr x))

(define (make-segment start-point end-point)
    (cons start-point end-point))

(define (start-point x)
    (car x))

(define (end-point x)
    (cdr x))

(define (mid-point x)
    (make-point (average (x-point (start-point x)) (x-point (end-point x)))
                (average (y-point (start-point x)) (y-point (end-point x)))))

(define (print-point x)
    (newline)
    (display "(")
    (display (x-point x))
    (display ",")
    (display (y-point x))
    (display ")"))

(define (average x y)
    (/ (+ x y) 2))

(define p1 (make-point 3 5))
(define p2 (make-point 1 1))
(define s (make-segment p1 p2))

(print-point (mid-point s))