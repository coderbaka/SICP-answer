
(define (last-pair l)
    (if (null? (cdr l))
        (car l)
        (last-pair (cdr l))))

(define (revserse l)
    (if (null? (cdr l))
        (car l)
        (cons (revserse l) (car l))))