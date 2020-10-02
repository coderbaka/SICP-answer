
(define f
    (let ((a 1))
        (lambda (x)
            (set! count (* count x))
            count)))