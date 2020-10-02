
(define (map-tree f tree)
    (if (null? tree)
        '()
        (if (pair? tree)
            (cons (map-tree f (car tree)) (map-tree f (cdr tree)))
            (f tree))))

; -- test --
(define (square x)
    (* x x))

(define t1 (list 1 (list 2 (list 3 4) 5) (list 6 7)))

(map-tree square t1)