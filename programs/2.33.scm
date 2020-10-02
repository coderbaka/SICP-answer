

(define (accumulate op init seq)
    (if (null? seq)
        init
        (op (car seq)
            (accumulate op init (cdr seq)))))

(define (map p seq)
    (accumulate (lambda (x y) (cons (p x) y)) '() seq))

(define (append l1 l2)
    (accumulate cons l2 l1))

(define (length seq)
    (accumulate (lambda (x y) (+ y 1)) 0 seq))
; -- test --
;(map (lambda (x) (* x x)) (list 1 2 3 4))
;(accumulate + 0 (list 1 2 3 4))
;(append (list 1 2 3 4) (list  5 6 7))
(length (list 1 2 3 4))