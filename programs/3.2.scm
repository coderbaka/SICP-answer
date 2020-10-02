
(define (make-monitored f)
    (let ((call-times 0))
        (lambda (in)
            (cond ((equal? in 'how-many-calls?) call-times)
                  ((equal? in 'reset-count) (set! call-times 0))
                  (else (begin (set! call-times (+ call-times 1)) (f in)))))))

; -- test --
(define t (make-monitored sqrt))

(t 100)
(t 'how-many-calls?)
(t 'reset-count)
(t 'how-many-calls?)