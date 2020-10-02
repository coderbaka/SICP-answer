
(define (equal? a b)
    (cond ((and (pair? a) (pair? b)) 
            (and (eq? (car a) (car b)) (equal? (cdr a) (cdr b))))
          ((and (not (pair? a)) (not (pair? b)))
            (eq? a b))
          (else #f)))

; -- test --
(equal? '(1 2 3 4 5) '(1 2 3 4 5))
(equal? '(1 2 3 4 5) '(1 2 3 4))
(equal? '(This is a list) '(This (is a) list))