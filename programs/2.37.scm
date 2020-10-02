
(define (accumulate op init seq)
    (if (null? seq)
        init
        (op (car seq)
            (accumulate op init (cdr seq)))))

(define (accumulate-n op init seqs)
    (if (null? (car seqs))
        '()
        (cons (accumulate op init (accumulate (lambda (x y) (cons (car x) y)) '() seqs))
              (accumulate-n op init (accumulate (lambda (x y) (cons (cdr x) y)) '() seqs) ))))

(define (dot-product v w)
    (accumulate + 0 (map * v w)))

(define (matrix-*-vector m v)
    (map (lambda (t) (dot-product t v)) m))

(define (transpose mat)
    (accumulate-n cons '() mat))

(define (matrix-*-matrix m n)
    (let ((cols (transpose n)))
         (map (lambda (t) (accumulate (lambda (x y) (cons (dot-product t x) y)) '() cols)) m)))

; -- test --
(define m1 (list (list 1 3) (list 2 -1)))
(define m2 (list (list 2 -4) (list 3 0)))
(matrix-*-matrix m1 m2)