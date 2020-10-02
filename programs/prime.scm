

(define (prime? x)
    (define (smallest-divisor x)
        (define (iter x n)
            (cond ((> (square n) x) x)
                ((divid? x n) n)
                (else (iter x (+ n 1)))))
        (define (divid? x n)
            (= (remainder x n) 0) )
        (iter x 2))
    (= (smallest-divisor x) x))

(define (time-prime-test n)
    (start-prime-test n (process-time-clock)))

(define (start-prime-test n start-time)
    (if (prime? n)
        (report-time n (- (process-time-clock) start-time))
        #f))

(define (report-time n elapsed-time)
    (newline )
    (display n)
    (display " *** ")
    (display elapsed-time)
    #t)

(define (search-for-primes start n)
    (if (not (= n 0))
        (begin (time-prime-test start) (search-for-primes (+ start 1) 
                                                          (- n (if (prime? start) 1 0))))))