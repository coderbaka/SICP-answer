(define (accumulate op init seq)
    (if (null? seq)
        init
        (op (car seq)
            (accumulate op init (cdr seq)))))

(define (count-leaves t)
    (accumulate (lambda (x y) (+ y x)) 0
                (map (lambda (x) (if (pair? x) (count-leaves x) 1)) t)))

; -- test --
(count-leaves (list (list 1 2 3) (list 4 5 6) (list 1 (list 2 3))))