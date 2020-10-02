
(define (make-mobile left right)
    (list left right))

(define (make-branch length structure)
    (list length structure))

(define (left-branch mb)
    (car mb))

(define (right-branch mb)
    (car (cdr mb)))

(define (branch-length b)
    (car b))

(define (branch-structure b)
    (car (cdr b)))

(define (is-branch? b)
    (not (pair? (car b))))

(define (total-weight b)
    (if (is-branch? b)
        (if (pair? (branch-structure b))
            (total-weight (branch-structure b))
            (branch-structure b))
        (+ (total-weight (left-branch b))
           (total-weight (right-branch b)))))

(define (balanced? mb)
    (if (is-branch? mb)
        (if (pair? (branch-structure mb))
            (balanced? (branch-structure mb))
            #t)
        (and (= (* (total-weight (left-branch mb)) (branch-length (left-branch mb)))
                (* (total-weight (right-branch mb)) (branch-length (right-branch mb))))
             (balanced? (left-branch mb))
             (balanced? (right-branch mb)))))

; -- test

(define b1 (make-branch 10 15))
(define b2 (make-branch 10 5))
(define b3 (make-branch 5 10))
(define b4 (make-branch 4 5))
(define mb1 (make-mobile b1 (make-branch 10 (make-mobile b2 b3))))

(balanced? mb1)