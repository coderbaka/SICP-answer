
(load "b.scm")

(define (reduce exp)
    (cond ((null? (other-part exp)) (add-into-list exp))
          ((>= (propority (op (part exp))) (propority (op (right-side exp))))
            (reduce (append (add-into-list (part exp)) (other-part exp))))
          (else (reduce (append (left-side exp) (reduce (right-side exp)))))))

(define (part exp)
    (list (pick 0 exp) (pick 1 exp) (pick 2 exp)))

(define (other-part exp)
    (cut 3 exp))

(define (left-side exp)
    (list (pick 0 exp) (pick 1 exp)))

(define (right-side exp)
    (cut 2 exp))

(define (add-into-list exp)
    (list exp))

(define (op exp)
    (pick 1 exp))

(define (propority op)
    (cond ((eq? op '+) 0)
          ((eq? op '*) 1)
          (else (error "wrong op: " op))))

(define (deriv exp var)
    (cond ((and (pair? exp) (= 1 (len exp))) (deriv (pick 0 exp) var))
          ((number? exp) 0)
          ((variable? exp) (if (is-same-variable? exp var) 1 exp ))
          ((sum? exp) (make-sum (deriv (left-op exp) var) (deriv (right-op exp) var)))
          ((product? exp) (make-sum (make-product (left-op exp) (deriv (right-op exp) var)) 
                                    (make-product (right-op exp) (deriv (left-op exp) var))))))

(define (deriv-r exp var)
    (deriv (reduce exp) var))

(define (left-op exp)
    (pick 0 exp))

(define (right-op exp)
    (pick 2 exp))

(define (variable? exp)
    (symbol? exp))

(define (is-same-variable? x y)
    (eq? x y))

(define (sum? exp)
    (eq? (op exp) '+))

(define (product? exp)
    (eq? (op exp) '*))

(define (make-sum a1 a2)
    (cond ((=number? a1 0) a2)
          ((=number? a2 0) a1)
          ((and (number? a1) (number? a2)) (+ a1 a2))
          (else (list a1 '+ a2))))

(define (make-product m1 m2)
    (cond ((or (=number? m1 0) (=number? m2 0)) 0)
          ((=number? m1 1) m2)
          ((=number? m2 1) m1)
          ((and (number? m1) (number? m2)) (* m1 m2))
          (else (list m1 '* m2))))

(define (=number? x y)
    (and (number? x) (number? y) (= x y)))

; -- test --
;(reduce '(a + c * d))
;(reduce '(a + b * d * (c + d)))
(deriv-r '(x + 3 * (x + y + 2)) 'x)