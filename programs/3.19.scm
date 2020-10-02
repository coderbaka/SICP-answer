 (define (has-circle? x)
    (define (next-turtle turtle)
        (if (null? (cdr turtle))
            #f
            (cdr turtle)))
    (define (next-rabbit rabbit)
        (if (or (null? (cdr rabbit)) (null? (cdr (cdr rabbit))))
            #f
            (cdr (cdr rabbit))))
    (define (helper turtle rabbit)
        (let ((n-turtle (next-turtle turtle))
              (n-rabbit (next-rabbit rabbit)))
              (cond ((or (not n-turtle) (not n-rabbit)) #f)
                    ((eq? n-turtle n-rabbit) #t)
                    (else (helper n-turtle n-rabbit)))))
    (helper x (next-rabbit x)))
; -- test --

(define (make-circle x)
    (set-cdr! (last-pair x) x)
    x)

(has-circle? '(1 2 3))
(has-circle? (make-circle '(1 2 3)))