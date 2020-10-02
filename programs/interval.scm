
(define (make-interval a b)
    (cons a b))

(define (lower-bound interval)
    (car interval))

(define (upper-bound interval)
    (cdr interval))

(define (add-interval a b)
    (make-interval (+ (lower-bound a) (lower-bound b))
                   (+ (upper-bound a) (upper-bound b))))

(define (mul-interval a b)
    (let ((p1 (* (lower-bound a) (lower-bound b)))
          (p2 (* (lower-bound a) (upper-bound b)))
          (p3 (* (upper-bound a) (lower-bound b)))
          (p4 (* (upper-bound a) (upper-bound b))))
          (make-interval (min p1 p2 p3 p4)
                         (max p1 p2 p3 p4))))

(define (div-interval a b)
    (if (and (<= (lower-bound b) 0) (>= (upper-bound b) 0))
        (error "FUCK!")
        (mul-interval
            a
            (make-interval (/ 1.0 (upper-bound b))
                           (/ 1.0 (lower-bound b))))))

(define (sub-interval a b)
    (add-interval a (negative b)))

(define (negative a)
    (make-interval (- (upper-bound a) (- (lower-bound b)))))

(define (mul-interval2 a b)
    (define (negative-interval? x)
        (and (< (lower-bound x) 0) (< (upper-bound x) 0)))
    (define (positive-interval? x)
        (and (>= (lower-bound x) 0) (>= (upper-bound x) 0)))
    (define (opposite-interval? x) 
        (not (or (negative-interval? x) (positive-interval? x))))
    (let ((al (lower-bound a))
          (ah (upper-bound a))
          (bl (lower-bound b))
          (bh (upper-bound b)))
        (cond ((and (positive-interval? a) (positive-interval? b))
                (make-interval (* al bl) (* ah bh)))
              ((and (positive-interval? a) (opposite-interval? b))
                (make-interval (* bl ah) (* bh ah)))
              ((and (positive-interval? a) (negative-interval? b))
                (make-interval (* ah bh) (* al bl)))
              ((and (opposite-interval? a) (positive-interval? b))
                (make-interval (* al bh) (* ah bh)))
              ((and (opposite-interval? a) (opposite-interval? b))
                (make-interval (min (* al bh) (* ah bl)) (max (* ah bh) (* al bl))))
              ((and (opposite-interval? a) (negative-interval? b))
                (make-interval (* ah bl) (* al bl)))
              ((and (negative-interval? a) (positive-interval? b))
                (make-interval (* ah bh) (* al bl)))
              ((and (negative-interval? a) (opposite-interval? b))
                (make-interval (* al bh) (* al bl)))
              ((and (negative-interval? a) (negative-interval? b))
                (make-interval (* ah bh) (* al bl)))
              (else (error "mul-interval2: logic error")))))

(define (make-center-percent center percent)
    (make-interval (- center (* center (/ percent 100.0)))
                   (+ center (* center (/ percent 100.0)))))

(define (percent interval)
    (let ((center (/ (+ (lower-bound interval) (upper-bound interval)) 2)))
         (* (/ (- (upper-bound interval) center) center) 100.0))) 
; -- test --

(define a (make-interval 3 5))
(define b (make-interval -1 1))

(define c (make-center-percent 10 50))