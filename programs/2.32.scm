
(define (subset s)
    (if (null? s)
        (list '())
        (let ((rest (subset (cdr s))))
             (append rest (map (lambda (x) (cons (car s) x)) rest)))))

; -- test --
(subset (list 1 2 3))