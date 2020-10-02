
(define (fold-right op init seq)
    (if (null? seq)
        init
        (op (car seq)
            (fold-right op init (cdr seq)))))

(define (fold-left op init seq)
    (define (iter result rest)
        (if (null? rest)
            result
            (iter (op result (car rest))
                  (cdr rest))))
    (iter init seq))

(define (reverse1 seq)
    (fold-right (lambda (x y) (append y (list x))) '() seq))

(define (reverse2 seq)
    (fold-left (lambda (x y) (cons y x)) '() seq))

;(fold-right / 1 (list 1 2 3))
;(fold-left / 1 (list 1 2 3))
;(fold-right list '() (list 1 2 3))
;(fold-left list '() (list 1 2 3))
(reverse1 (list 1 2 3 4))
(reverse2 (list 1 2 3 4))
