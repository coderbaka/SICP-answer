
(define-syntax cons-stream
  (syntax-rules ()
    ((_ A B) (cons A (delay B)))))

(define (stream-car stream)
    (car stream))

(define (stream-cdr stream)
    (force (cdr stream)))

(define (stream-null? stream)
    (null? stream))

(define (any-stream-null? streams)
    (if (null? streams)
        #f
        (if (stream-null? (car streams))
            #t
            (any-stream-null? (cdr streams)))))

(define the-empty-stream '())

(define (make-stream-from-list list)
    (if (null? list)
        the-empty-stream
        (cons-stream (car list) (make-stream-from-list (cdr list)))))

(define (print-stream stream)
    (define (print-in-newline v) (newline) (display v))
    (stream-for-each print-in-newline stream))

(define (stream-map proc . argstreams)
  (if (any-stream-null? argstreams)
      the-empty-stream
      (cons-stream
       (apply proc (map stream-car argstreams))
       (apply stream-map
              (cons proc (map stream-cdr argstreams))))))

(define (stream-ref stream n)
    (if (= n 0)
        (stream-car stream)
        (stream-ref (stream-cdr stream) (- n 1))))

(define (stream-for-each proc stream)
    (if (stream-null? stream)
        the-empty-stream
        (begin (proc (stream-car stream)) (stream-for-each proc (stream-cdr stream)))))

(define (add-stream s1 s2)
    (stream-map + s1 s2))

(define (add-stream-single s n)
    (cons-stream (+ n (stream-car s)) (add-stream-single (stream-cdr s) n)))

(define (mul-stream s1 s2)
    (stream-map * s1 s2))

(define (constant-stream n)
    (cons-stream n (constant-stream n)))

(define (integers-start-from n)
    (cons-stream n (integers-start-from (+ n 1))))

(define integers (integers-start-from 1))

(define (partial-sums s)
    (add-stream s (cons-stream 0 (partial-sums s))))

(define (scale-stream n s)
    (stream-map (lambda (x) (* x n)) s))

(define (stream-filter proc stream)
    (cond ((stream-null? stream) the-empty-stream)
          ((proc (stream-car stream))
           (cons-stream (stream-car stream)
                        (stream-filter proc (stream-cdr stream))))
          (else (stream-filter proc (stream-cdr stream)))))

(define (slice-stream start end stream)
    (let ((index 0))
        (define (set-to-start)
            (if (< index start)
                (begin (set! index (+ index 1)) (set! stream (stream-cdr stream)) (set-to-start))
                'done))
        (stream-filter (lambda (x)
                            (if (< index end)
                                (begin (set! index (+ index 1)) #t) 
                                #f)) stream)))

(define (merge s1 s2)
    (cond ((stream-null? s1) s2)
          ((stream-null? s2) s1)
          (else
            (let ((s1car (stream-car s1))
                  (s2car (stream-car s2)))
                (cond ((< s1car s2car) (cons-stream s1car (merge (stream-cdr s1) s2)))
                      ((> s1car s2car) (cons-stream s2car (merge s1 (stream-cdr s2))))
                      (else 
                        (cons-stream s1car
                                     (merge (stream-cdr s1)
                                            (stream-cdr s2)))))))))

(define S (cons-stream 1 (merge (scale-stream 2 S) (merge (scale-stream 3 S) (scale-stream 5 S)))))

(define (expand num den radix)
    (cons-stream
         (quotient (* num radix) den)
         (expand (remainder (* num radix) den) den radix)))

(define (integerate-series s)
    (mul-stream (stream-map / (constant-stream 1) integers) s))

(define cosine-series (cons-stream 1 (stream-map - (integerate-series sine-series))))
(define sine-series (cons-stream 0 (integerate-series cosine-series)))

(define (mul-series s1 s2)
    (cons-stream (* (stream-car s1) (stream-car s2))
            (add-stream (scale-stream (stream-car s2) (stream-cdr s1)) (mul-series s1 (stream-cdr s2)))))

(define (get-x S)
    (cons-stream 1 (mul-series (stream-map - (stream-cdr S)) (get-x S))))

(define (div-series s1 s2)
    (mul-series s1 (get-x s2)))

(define (interleave s1 s2)
    (if (stream-null? s1)
        s2
        (cons-stream (stream-car s1) (interleave s2 (stream-cdr s1)))))

(define (pairs s t)
    (cons-stream 
        (list (stream-car s) (stream-car t))
        (interleave
            (stream-map (lambda (x) (list (stream-car s) x)) (stream-cdr t))
            (pairs (stream-cdr s) (stream-cdr t)))))

(define (triples s t u)
    (cons-stream 
        (list (stream-car s) (stream-car t) (stream-car u))
        (interleave
            (stream-map (lambda (x) (cons (stream-car s) x)) (stream-cdr (pairs t u)))
            (triples (stream-cdr s) (stream-cdr t) (stream-cdr u)))))

(define (a-triples s t u)
    (stream-filter 
        (lambda (x) (= (+ (square (list-ref x 0)) (square (list-ref x 1))) (square (list-ref x 2))))
        (triples s t u)))

(define (merge-weighted s1 s2 w)
    (let ((s1car (stream-car s1))
          (s2car (stream-car s2))
          (s1w (w (stream-car s1)))
          (s2w (w (stream-car s2))))
        (cond ((= s1w s2w)
                (cons-stream s1car (cons-stream s2car (merge-weighted (stream-cdr s1) (stream-cdr s2) w))))
              ((< s1w s2w)
                (cons-stream s2car (merge-weighted s1 (stream-cdr s2) w)))
              (else (cons-stream s1car (merge-weighted (stream-cdr s1) s2 w))))))

(define (pair-weighted s1 s2 w)
    (let ((s1car (stream-car s1))
          (s2car (stream-car s2))
          (s1cdr (stream-cdr s1))
          (s2cdr (stream-cdr s2)))
        (cons-stream
            (list s1car s2car)
            (merge-weighted
                (merge-weighted (stream-map (lambda (x) (list s1car x)) s2cdr)
                                (stream-map (lambda (x) (list x s2car)) s1cdr)
                                w)
                (pair-weighted s1cdr s2cdr w)
                w))))

(define (first-less-than-second s)
    (stream-filter (lambda (x) (< (list-ref x 0) (list-ref x 1))) s))

;(define i-plus-j (first-less-than-second 
                    ;(pair-weighted integers integers (lambda (x) (+ (list-ref x 0) (list-ref x 1))))))

; -- test --

(define (stream-for-each-test)
    (define (display-new-line v) (newline) (display v))
    (define s (make-stream-from-list '(1 2 3 4 5 test)))
    (stream-for-each display-new-line s))

(define (stream-map-test)
    (define s (map make-stream-from-list '( (1 2 3 4) (5 6 7 8) (9 10 11 12) )))
    (print-stream (apply stream-map (cons + s))))

;(stream-for-each-test)
;(stream-map-test)
;(print-stream (partial-sums integers))
 (define (partial-sums-2 s) 
   (define ps (add-stream s (cons-stream 0 ps))) 
   ps)

;(print-stream (partial-sums-2 integers))
;(print-stream (scale-stream 3 (slice-stream 1 10 integers))))

(define (test-stream-filter)
    (print-stream (stream-filter (lambda (x) (< x 10)) integers)))

;(test-stream-filter)

;(print-stream (slice-stream 0 100 S))
;(print-stream (slice-stream 0 100 (expand 13 16 2)))

(define (test-integerate-series)
    (define s0 (make-stream-from-list '(1 1 1 1)))
    (print-stream (integerate-series s0)))

;(print-stream (stream-map / (constant-stream 1) integers))
;(print-stream (mul-stream (stream-map / (constant-stream 1) integers) (constant-stream 2)))

;(test-integerate-series)

(define circle-series 
     (add-stream (mul-series cosine-series cosine-series) 
                  (mul-series sine-series sine-series)))

;(print-stream (slice-stream 0 30 circle-series))
(define (test-get-x)
    (define s (make-stream-from-list '(1 2 3 4)))
    (print-stream (mul-series s (get-x s))))

;(test-get-x)
;(print-stream (div-series sine-series cosine-series))
;(print-stream (slice-stream 0 100 (triples integers integers integers)))
;(print-stream (slice-stream 0 100 (a-triples integers integers integers)))

;(print-stream i-plus-j)
(print-stream (pair-weighted integers integers (lambda (x) 1))))