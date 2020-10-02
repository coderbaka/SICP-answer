
(load "b.scm")

(define (p n s)
    (filter (lambda (x) (= s (pick 3 x)))
        (map (lambda (p) (append p (list (+ (pick 0 p) (pick 1 p) (pick 2 p))))) (
            flatmap (lambda (i) (
                flatmap (lambda (j) (
                    map (lambda (k) (list k j i)) (enumerate-n j n)
                )) (enumerate-n i (- n 1))
            )) (enumerate-n 1 (- n 2))
        ))))

(p 6 12)