
(define (monte-carlo times exp)
    (define (iter times-remain times-pass)
        (cond ((= times-remain 0) (/ times-pass times))
              ((exp) (iter (- times-remain 1) (+ times-pass 1)))
              (else (iter (- times-remain 1) times-pass))))
    (iter times 0))

(define (random-in-range low high)
    (let ((range (- high low)))
        (+ low (random range))))

(define (estimate-integral p x1 x2 y1 y2 times)
    (monte-carlo times (lambda () (p (random-in-range x1 x2) (random-in-range y1 y2)))))

; -- test --
(define (p x y) (<= (+ (square (- x 0.5)) (square y)) 0.25))

; 蒙特卡罗方法垃圾！
(* 4.0 (estimate-integral p 0.0 1.0 (- 0.5) 0.5 10000))
