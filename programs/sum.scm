
(define (sum term a next b)
        (if (> a b)
            0
            (+ (term a)
               (sum term (next a) next b))))

(define (sum-iter term a next b)
    (define (iter a result)
        (if (> a b)
            result
            (iter (next a) (+ result (term a)))))
    (iter a 0))

(define (integral f a b n)
    (define (h) (/ (- b a) n))
    (define (term x)
        (cond ((or (= x a) (= x b)) (f x))
              ((even? (/ (- x a) (h))) (* 2 (f x)))
              (else (* 4 (f x)))))
    (define (next x)
        (+ x (h)))
    (* (/ (h) 3) (sum term a next b)))

(define (f x) ; this function is used to test integral
    (+ (square x) (* 3 x) 5))

(integral f 0 5 1000)