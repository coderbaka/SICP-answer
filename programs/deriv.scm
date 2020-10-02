
(define (deriv exp var)
    (cond ((number? exp) 0)
          ((variable? exp)
              (if (same-variable? exp var) 1 0))
          ((sum? exp)
              (make-sum (deriv (addend exp) var) 
                        (deriv (augend exp) var)))
          ((product? exp)
              (make-sum
                    (make-product (multiplier exp)
                                  (deriv (multiplicand exp) var))
                    (make-product (multiplicand exp)
                                  (deriv (multiplier exp) var))))
          ((exp? exp) (make-product (exponet exp) (make-exp (base exp) (- (exponet exp) 1))))
          (else (error "unkown expression type -- DERIV" exp))))

(define (variable? x)
    (symbol? x))

(define (same-variable? v1 v2)
    (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (make-sum a1 a2)
    (cond ((=number? a1 0) a2)
          ((=number? a2 0) a1)
          ((and (number? a1) (number? a2)) (+ a1 a2))
          (else (list '+ a1 a2))))

(define (make-product m1 m2)
    (cond ((or (=number? m1 0) (=number? m2 0)) 0)
          ((=number? m1 1) m2)
          ((=number? m2 1) m1)
          ((and (number? m1) (number? m2)) (* m1 m2))
          (else (list '* m1 m2))))

(define (sum? x)
    (and (pair? x) (eq? (car x) '+)))

(define (addend s)
    (cadr s))

(define (augend s)
    (let ((first (caddr s))
          (rest (cdddr s)))
          (if (null? rest)
              first
              (append (list '+) (append (list first) rest))))) 

(define (product? x)
    (and (pair? x) (eq? (car x) '*)))

(define (multiplier p)
    (cadr p))

(define (multiplicand p)
    (let ((first (caddr p))
          (rest (cdddr p)))
          (if (null? rest)
              first
              (append (list '*) (append (list first) rest)))))

(define (=number? x y)
    (and (number? x) (number? y) (= x y)))

(define (exp? x)
    (and (pair? x) (eq? (car x) '^)))

(define (base x)
    (cadr x))

(define (exponet x)
    (caddr x))

(define (make-exp base exp)
    (cond ((=number? exp 0) 1)
          ((=number? exp 1) base)
          (else (list '^ base exp))))

; -- test --
;(deriv '(+ x 3) 'x)
;(deriv '(* x y) 'x)
;(deriv '(* (* x y) (+ x 3)) 'x)
;(deriv '(* y (^ x 3)) 'x)
;(augend '(+ 3 3 3 3))
(deriv '(* x x x) 'x)