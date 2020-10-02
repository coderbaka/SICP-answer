
(define (fringe t)
    (if (not (pair? t))
        (if (null? t) '() (list t))
        (append (fringe (car t)) (fringe (cdr t)))))

(define l (list (list 1 2) (list 3 4)))
(fringe (list l l))