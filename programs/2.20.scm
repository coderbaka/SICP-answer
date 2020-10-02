
(define (same-parity f . l)
    (define (helper p l)
        (if (null? l)
            '()
            (if (eq? (even? (car l)) p)
                (cons (car l) (helper p (cdr l)))
                (helper p (cdr l)))))
    (cons f (helper (even? f) l)))