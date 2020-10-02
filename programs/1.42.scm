
(define (compose f g)
    (lambda (x) (f (g x))))

(define (inc x)
    (+ x 1))

;((compose square inc) 6)

(define (repeated f n)
    (if (= n 1)
        f
        (compose f (repeated f (- n 1)))))

;((repeated square 2) 5)

(define (smooth f)
    (lambda (x) (/ (+ (f (- x dx)) (f x) (f (+ x dx))) 3)))

(define (smooth-n n)
    (repeated smooth n))