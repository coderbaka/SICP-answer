

(define (make-point x y)
    (cons x y))

(define (x-codr p)
    (car p))

(define (y-codr p)
    (cdr p))

(define (make-rect p1 p2)
    (cons p1 p2))

(define (rect-length rect)
    (- (x-codr (cdr rect)) (x-codr (car rect))))

(define (rect-width rect)
    (- (y-codr (cdr rect)) (y-codr (car rect))))

(define (area rect)
    (* (rect-width rect) (rect-length rect)))

(define (perimeter rect)
    (+ (* 2 (rect-width rect)) (* 2 (rect-length rect))))
