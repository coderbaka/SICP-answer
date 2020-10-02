
(define (deep-reverse l)
    (define (iter l result)
        (if (null? l)
            result
            (if (pair? (car l))
                (iter (cdr l) (cons (deep-reverse (car l)) result))
                (iter (cdr l) (cons (car l) result)))))
    (iter l '() ))

(deep-reverse (list 1 2 (list 3 4) (list 5 6)))