
(define (p-tri n a) ; 计算第n行a个杨辉三角数
    (if (or (= a 1) (= a n))
        1
        (+ (p-tri (- n 1) a) (p-tri (- n 1) (- a 1))) ))