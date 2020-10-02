
(define (product term a next b)
    (if (> a b)
        1
        (* (term a) (product term (next a) next b))))

(define (factorial x)
    (product id 1 inc x))

(define (pi-product n)
    (define (next x) (+ x 2))
    (/ (* 8 (product square 4 next (+ 4 (* 2 (- n 1)))))
       (* (+ 4 (* 2 (- n 1))) (product square 3 next (+ 3 (* 2 (- n 1)))))))

(define (product-iter term a next b)
    (define (iter a result)
        (if (> a b)
            result
            (iter (next a) (* result (term a)))))
    (iter a 1))

; auxiliary procedures below

(define (inc x)
    (+ x 1))

(define (id x)
    x)