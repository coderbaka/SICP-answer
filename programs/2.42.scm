
(load "b.scm")

(define (queens board-size)
    (define (queen-cols k)
        (if (= k 0)
            (list empty-board)
            (filter
                (lambda (positions) (safe? k positions))
                (flatmap
                    (lambda (rest-of-queens)
                        (map (lambda (new-row)
                                (adjoin-position
                                    new-row k rest-of-queens))
                            (enumerate-n 1 board-size)))
                    (queen-cols (- k 1))))))
    (queen-cols board-size))

(define empty-board nil)

(define (adjoin-position new-row k rest-of-queens)
    (append rest-of-queens (list (cons k new-row))))

(define (safe? k positions)
    (let ((h (head positions))
          (t (tail positions)))
          ;(debug h t)
        (accumulate (lambda (p pre) 
            (if (eq? pre #f)
                #f
                (let ((sub (abs (- (cdr t) (cdr p))))
                      (ksub (abs (- (car t) (car p)))))
                    (and (not (= sub 0)) (not (= sub ksub)))))) #t h)))

(define (queens-pretty board-size)
    (accumulate (lambda (c pre) (cons (map (lambda (x) (cdr x)) c) pre))
                nil (queens board-size)))

;(define (safe? k positions)
    ;#t)

;(queens-pretty 5)
(length (queens-pretty 8))