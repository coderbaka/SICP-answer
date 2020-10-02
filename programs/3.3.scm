
(define (make-account amount password)
    (define (withdraw x)
        (if (> x amount)
            "No enough money"
            (set! amount (- amount x))))
    (define (deposit x)
        (set! amount (+ amount x)))
    (lambda (pwd op)
        (if (not (equal? pwd password))
            "Incorrect password"
            (cond ((equal? op 'withdraw) withdraw)
                  ((equal? op 'deposit) deposit)
                  (else (error "No such operation"))))))

; -- test --
(define acc (make-account 100 'a))
((acc 'a 'withdraw) 10)
((acc 'b 'withdraw) 10)