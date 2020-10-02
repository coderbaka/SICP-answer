

(define (cc amount coin-values)
    (cond ((= amount 0) 1)
          ((or (< amount 0) (no-more? coin-values)) 0)
          (else (+
                    (cc amount (except-first coin-values))
                    (cc (- amount (first coin-values)) coin-values)))))

(define (except-first l)
    (cdr l))

(define (first l)
    (car l))

(define (no-more? l)
    (null? l))

(define us-coins (list 50 25 10 5 1))
(define uk-coins (list 100 50 20 10 5 2 1 0.5))
