
(define (count-pairs x)
    (if (not (pair? x))
        0
        (+ (count-pairs (car x))
           (count-pairs (cdr x))
           1)))

(define visited '())
(define (count-pairs-right x)
    (define (help cur)
        (if (or (not (pair? cur)) (memq cur visited))
            0
            (begin (set! visited (append visited (list cur))) (+ 1 (help (car cur)) (help (cdr cur))))))
    (begin (set! visited '()) (help x)))

; output 3
(count-pairs (list 1 2 3))
(count-pairs-right (list 1 2 3))

; output 4
(define a (list 1))
(define b (cons 2 a))
(define c (cons b a))
(count-pairs c)
(count-pairs-right c)

; output 7
(define x (list 1))
(define y (cons x x))
(define z (cons y y))
(count-pairs z)
(count-pairs-right z)