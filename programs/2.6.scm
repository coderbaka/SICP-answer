
(define one 
    (lambda (f) (lambda (x) (f x))))

(define two
    (lambda (f) (lambda (x) (f (f x)))))

(define (plus a b)
    (lambda (f) (lambda (x) 
        ((a f) ((b f) x)))))

(define (inc x)
    (+ x 1))

(define (test-n n)
    ((n inc) 0))