### Notes

Use MIT-Scheme on Linux (Manjaro),the newest version from official repo.

Use http://community.schemewiki.org/?SICP-Solutions as standard answer.

### 1.1
10
12
8
3
6
a
b
19
#f
4
16
6
16

### 1.2
```scheme
(/ 
    (+ 5 4 
        (- 2 
            (- 3 
                (+ 6 (/ 4 5))))) 
    (* 3 (- 6 2) (- 2 7)))
```
### 1.3
```scheme
(define (sum-of-sqaure x y)
    (+ (* x x) (* y y)))

(define (sum-of-the-squares-two-big-number a b c)
    (cond ((> a b) (if (> b c) (sum-of-square a b) (sum-of-square a c)))
          ((> a c) (sum-of-square a b))  
          (else (sum-of-square b c)) ))
```
### 1.4
As the name of this procedure,it returns a plus absolute value of b.

### 1.5
Use applicative order,it will never get result;use normal order,it will get 0.

### 1.6
It will nerver get a result.

### 1.7
For small number, absolute tolerance of 0.001 is too large.For big number,improve keeps giving a same result but good-enough? keeps giving #f. The alternative works better both for small and big number.
The code is:
```scheme
(define (good-enough?v2 old-guess new-guess)
    (< (abs (- old-guess new-guess)) (* old-guess 0.001)))
```

### 1.8
omitted.

### 1.9
The first one is recursive,because it can be expanded as a "chain".The second one is iterative,beacause it need only 2 variables to describe its state.

### 1.10
(A 1 10) = 1024  
(A 2 4) = 65536  
(A 3 3) = 65536  
$f(n) = 2n$  
$g(n) = 2^n$  
$h(n) = \begin{cases}
    1,&n=1 \\
    2^{h(n-1)},&otherwise
\end{cases}$

### 1.11
```scheme
(define (f-recursive n)
    (if (< n 3)
        n
        (+ (f-recursive (- n 1)) (* 2 (f-recursive (- n 2))) (* 3 (f-recursive (- n 3))) )))

(define (f-iter a b c n)
    (if (= n 0)
        c
        (f-iter b c (+ (* 3 a) (* 2 b) c) (- n 1))))

(define (f n)
    (if (< n 3)
        n
        (f-iter 0 1 2 (- n 2))))
```

### 1.12
```scheme
(define (p-tri n a) ; 计算第n行a个杨辉三角数
    (if (or (= a 1) (= a n))
        1
        (+ (p-tri (- n 1) a) (p-tri (- n 1) (- a 1))) ))
```

### 1.13
先使用数学归纳法证明提示的结论，再求极限即可。

### 1.14
omitted

### 1.15
a. 5
b. log3(a)

### 1.16
```scheme
(define (fast-exp b n)
    (define (fast-exp-iter a b n)
        (cond ((= n 1) (* a b))
              ((even? n) (fast-exp-iter a (square b) (/ n 2)) )
              (else (fast-exp-iter (* a b) (square b) (/ (- n 1) 2)))))
    (fast-exp-iter 1 b n))
```

### 1.17
```scheme
(define (multiply x y)
    (cond ((= y 1) x)
          ((even? y) (multiply (double x) (halve y)))  
          (else (+ x (multiply (double x) (halve (- y 1)))))))
```

### 1.18
```scheme
(define (*-iter x y a)
    (cond ((= y 1) (+ x a))
          ((even? y) (*-iter (double x) (halve y) a))
          (else (*-iter x (- y 1) (+ a x)))))

(define (* x y)
    (*-iter x y 0))
```

### 1.19
```scheme
(define (fib n)
  (fib-iter 1 0 0 1 n))
 
(define (fib-iter a b p q count)
  (cond ((= count 0) b)
        ((even? count)
         (fib-iter a
                   b
                   (+ (square p) (square q))  ; p'
                   (+ (* 2 p q)  (square q))  ; q'
                   (/ count 2)))
        (else (fib-iter (+ (* b q) (* a q) (* a p))
                        (+ (* b p) (* a q))
                        p
                        q
                        (- count 1)))))
```

### 1.20
The applicative order apply remainder less times than normal order.

### 1.21
199
1999
7

### 1.29
```scheme
(define (integral f a b n)
    (define (h) (/ (- b a) n))
    (define (term x)
        (cond ((or (= x a) (= x b)) (f x))
              ((even? (/ (- x a) (h))) (* 2 (f x)))
              (else (* 4 (f x)))))
    (define (next x)
        (+ x (h)))
    (* (/ (h) 3) (sum term a next b)))
```

### 1.30
```scheme
(define (sum-iter term a next b)
    (define (iter a result)
        (if (> a b)
            result
            (iter (next a) (+ result (term a)))))
    (iter a 0))
```
### 1.31
```scheme
(define (product term a next b)
    (if (> a b)
        1
        (* (term a) (product term (next a) next b))))

(define (factorial x)
    (product id 1 inc x))

(define (pi-product n)
    (define (next x) (+ x 2))
    (/ (* 8 (product square 4 next (+ 4 (* 2 (- n 1)))))
       (* (+ 4 (* 2 (- n 1))) (product square 3 next (+ 3 (* 2 (- n 1)))))))

(define (product-iter term a next b)
    (define (iter a result)
        (if (> a b)
            result
            (iter (next a) (* result (term a)))))
    (iter a 1))
```

### 1.32
```scheme
(define (accumulate combiner null-value term a next b)
    (if (> a b)
        null-value
        (combiner (term a) (accumulate combiner null-value term (next a) b))))

(define (accumulate-iter combiner null-value term a next b)
    (define (iter a result)
        (if (> a b)
            result
            (iter (next a) (combiner result (term a)))))
    (iter a null-value))

(define (sum a b)
    (accumulate + 0 identity a inc b))

(define (product a b)
    (accumulate * 1 identity a inc b))
```

### 1.33
```scheme
(define (filtered-accumulate pred? combiner null-value term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (if (pred? a)
                           (combiner result (term a))
                           result))))
  (iter a null-value))
```

### 1.34
It will raise an error that object 2 isn't applicable.
Use subtleties model:
(f f) => (f 2) => (2 2)

### 1.37
```scheme
(define (cont-frac n d k)
    (define (helper i)
        (if (= i k)
            (/ (n i) (d i))
            (/ (n i) (+ (d i) (helper (+ i 1))))))
    (helper 1))

(define (cont-frac-iter n d k)
    (define (iter c result)
        (if (< c 1) 
            result
            (iter (- c 1) (/ (n c) (+ (d c) result)))))
    (iter k 0))
```

### 1.38
```scheme
(define (D i)
    (cond ((= i 1) 1)
          ((= i 2) 2)
          ((not (= (remainder (- i 2) 3) 0)) 1)
          (else (+ 2 (* 2 (/ (- i 2) 3))))))

(+ 2 (cont-frac (lambda (x) 1.0) D 100))
```

### 1.39
```scheme
(define (tan-cf x k)
    (cont-frac (lambda (i) (if (= i 1) x (- (square x))))
               (lambda (i) (- (* 2 i) 1))
               k))
```

### 1.40
```scheme
(define dx 0.00001)

(define (fixed-point f fisrt-guess)
    (define tolerance 0.00001)
    (define (close-enough? v1 v2)
        (< (abs (- v1 v2))
            tolerance))
    (define (try guess)
        (let ((next (f guess)))
            (if (close-enough? guess next)
                next
                (try next))))
    (try fisrt-guess))

(define (deriv g)
    (lambda (x) (/ (- (g (+ x dx)) (g x)) dx)))

(define (newton-transform g)
    (lambda (x) (- x (/ (g x) ((deriv g) x)))))

(define (newton-method g guess)
    (fixed-point (newton-transform g) guess))

(define (cubic a b c)
    (lambda (x) (+ (* x x x) (* a x x) (* b x) c)))

(define (cubic-solve a b c)
    (newton-method (cubic a b c) 1.0))
```

### 1.41
```scheme
(define (double f)
    (lambda (x) (f (f x))))
```
The answer is 21.Here is the expansion:
Write f(f(f(...))) as f\*f\*f...
double double => double * double
double (double double) inc => (double double) * (double double) => double \* double \* double \* double \* inc => double \* double \* double \* (inc * inc) => double \* double (f \* f \* f \* f) =>...=> inc \* ...\* inc (totally 16 inc)

### 1.42
```scheme
(define (compose f g)
    (lambda (x) (f (g x))))
```

### 1.43
```scheme
define (repeated f n)
    (if (= n 1)
        f
        (compose f (repeated f (- n 1)))))
```

### 1.44
```scheme
(define (smooth f)
    (lambda (x) (/ (+ (f (- x dx)) (f x) (f (+ x dx))) 3)))

(define (smooth-n n)
    (repeated smooth n))
```

### 1.45
```scheme
(define (log2 x)
    (/ (log x) (log 2)))

(define (n-root x n)
    (fixed-point 
        ((repeated average-dump (floor (log2 n))) (lambda (y) (/ x (n-times y (- n 1)))) ) 1.0))
```

### 1.46
```scheme
(define (iterative-improve good-enough? improve)
  (lambda (guess)
    (if (good-enough? guess) 
        guess
        ((iterative-improve good-enough? improve) (improve guess)))))
 
(define (sqrt-iterative x)
  ((iterative-improve (lambda (guess)
                        (< (abs (- (square guess) x)) 0.001))
                      (lambda (guess)
                        (/ (+ guess 
                              (/ x guess))
                           2))) x)) 
 
(define (fixed-point-iterative f first-guess)
  (define tolerance 0.00001)
   
  ((iterative-improve (lambda (guess)
                        (let ((next (f guess)))
                          (< (abs (- guess next)) tolerance)))
                      f) first-guess))
```

### 2.2
```scheme
(define (make-point x y)
    (cons x y))

(define (x-point x)
    (car x))

(define (y-point x)
    (cdr x))

(define (make-segment start-point end-point)
    (cons start-point end-point))

(define (start-point x)
    (car x))

(define (end-point x)
    (cdr x))

(define (mid-point x)
    (make-point (average (x-point (start-point x)) (x-point (end-point x)))
                (average (y-point (start-point x)) (y-point (end-point x)))))

(define (print-point x)
    (newline)
    (display "(")
    (display (x-point x))
    (display ",")
    (display (y-point x))
    (display ")"))

(define (average x y)
    (/ (+ x y) 2))

(define p1 (make-point 3 5))
(define p2 (make-point 1 1))
(define s (make-segment p1 p2))

(print-point (mid-point s))
```

### 2.3
```scheme

(define (make-point x y)
    (cons x y))

(define (x-codr p)
    (car p))

(define (y-codr p)
    (cdr p))

(define (make-rect p1 p2)
    (cons p1 p2))

(define (rect-length rect)
    (- (x-codr (cdr rect)) (x-codr (car rect))))

(define (rect-width rect)
    (- (y-codr (cdr rect)) (y-codr (car rect))))

(define (area rect)
    (* (rect-width rect) (rect-length rect)))

(define (perimeter rect)
    (+ (* 2 (rect-width rect)) (* 2 (rect-length rect))))
```

### 2.4

(car z) => (z (lambda (p q) p)) => ((lambda (m) (m x y)) (lambda (p q) p)) => ((lamda (p q) p) x y) => (x)
The definition of `cdr` is
```scheme
(define (cdr z)
    (z (lambda (p q) q)))
```

### 2.5
```scheme
(define (cons x y)
    (* (expt 2 x) (expt 3 y)))

(define (has-factors x n)
    (define (iter result c)
        (if (= (remainder c n) 0)
            (iter (+ 1 result) (/ c n))
            result))
    (iter 0 x))

(define (car z)
    (has-factors z 2))

(define (cdr z)
    (has-factors z 3))
```

### 2.6
由于我的屑英文水平，此题使用中文描述答案。  
原文中的Church numerals翻译过来是邱奇数，一个n的邱奇数的定义如下：  
n是一个lambda，n接受一个函数f，产生一个新的lambda，这个lambda接受一个参数x后将套娃地调用fn次，用数学描述如下：  
$n(f)(x) = f(f(f(...f(x)...)))$  
所以：  
```scheme
(define one 
    (lambda (f) (lambda (x) (f x))))

(define two
    (lambda (f) (lambda (x) (f (f x)))))

(define (plus a b)
    (lambda (f) (lambda (x) 
        ((a f) ((b f) x)))))
```

### 2.7 2.8 2.10
```scheme
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
```
### 2.16
我认为不太可能，因为有些恒等式在区间算术上不起效，例如：  
a = (2,4),b = (-2,0),c = (3,8),a*(b + c) = (2,32),a\*b + a\*c = (-2,32)。  
哪一种形式是正确的？其实，只要能确定哪种形式是正确的，那我们就可以将原表达式化为正确的形式计算。问题是，确定哪一种形式是正确的是非常困难的。

### 2.17 2.18
```scheme
(define (last-pair l)
    (if (null? (cdr l))
        (car l)
        (last-pair (cdr l))))

(define (revserse l)
    (if (null? (cdr l))
        (car l)
        (cons (revserse l) (car l))))
```

### 2.19
```scheme
(define (cc amount coin-values)
    (cond ((= amount 0) 1)
          ((or (< amount 0) (no-more? coin-values)) 0)
          (else (+
                    (cc amount (except-first coin-values))
                    (cc (- amount (first coin-values)) coin-values)))))

(define (except-first l)
    (cdr l))

(define (first l)
    (car l))

(define (no-more? l)
    (null? l))

(define us-coins (list 50 25 10 5 1))
(define uk-coins (list 100 50 20 10 5 2 1 0.5))
```

### 2.21
```scheme
(define (square-list l)
    (if (null? l)
        '()
        (cons (square (car l)) (square-list (cdr l)))))

(define (square-list l)
    (map square l))
```

### 2.22
The first problem is obvious.The second problem is that,it will get a list like this: nil,1,2,3,...

### 2.23
```scheme
(define (for-each f l)
    (if (null? l)
        #t
        (begin (f (car l) (for-each (cdr l))))))
```

### 2.25
1. (cdar (cddr l))
2. (caar l)
3. (cdadr (cadadr (cadadr l)))

### 2.26
1. (1 2 3 4 5 6)
2. ((1 2 3) 4 5 6)
3. ((1 2 3) (4 5 6))
   
### 2.27
```scheme
(define (deep-reverse l)
    (define (iter l result)
        (if (null? l)
            result
            (if (pair? (car l))
                (iter (cdr l) (cons (deep-reverse (car l)) result))
                (iter (cdr l) (cons (car l) result)))))
    (iter l '() ))
```

### 2.28
```scheme
(define (fringe t)
    (if (not (pair? t))
        (if (null? t) '() (list t))
        (append (fringe (car t)) (fringe (cdr t)))))
```

### 2.29
```scheme
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
```

### 2.30 2.31
```scheme
(define (map-tree f tree)
    (if (null? tree)
        '()
        (if (pair? tree)
            (cons (map-tree f (car tree)) (map-tree f (cdr tree)))
            (f tree))))
```

### 2.32
```scheme
(define (subset s)
    (if (null? s)
        (list '())
        (let ((rest (subset (cdr s))))
             (append rest (map (lambda (x) (cons (car s) x)) rest)))))
```
All subsets of a set s is the subsets of s without first element plus the subsets of s with first element.
The subsets of s with element are subsets of s without first element appending first element.

### 2.33
```scheme
(define (map p seq)
    (accumulate (lambda (x y) (cons (p x) y)) '() seq))

(define (append l1 l2)
    (accumulate cons l2 l1))

(define (length seq)
    (accumulate (lambda (x y) (+ y 1)) 0 seq))
```

### 2.34
```scheme
(define (horner-eval x coefficient-sequence)
    (accumulate (lambda (this-coeff higher-terms) (+ this-coeff (* x higher-terms)))
                0
                coefficient-sequence))
```

### 2.35
```scheme
(define (count-leaves t)
    (accumulate (lambda (x y) (+ y x)) 0
                (map (lambda (x) (if (pair? x) (count-leaves x) 1)) t)))
```

### 2.36
```scheme
(define (accumulate-n op init seqs)
    (if (null? (car seqs))
        '()
        (cons (accumulate op init (accumulate (lambda (x y) (cons (car x) y)) '() seqs))
              (accumulate-n op init (accumulate (lambda (x y) (cons (cdr x) y)) '() seqs) ))))
```

### 2.37
```scheme
(define (dot-product v w)
    (accumulate + 0 (map * v w)))

(define (matrix-*-vector m v)
    (map (lambda (t) (dot-product t v)) m))

(define (transpose mat)
    (accumulate-n cons '() mat))

(define (matrix-*-matrix m n)
    (let ((cols (transpose n)))
         (map (lambda (t) (accumulate (lambda (x y) (cons (dot-product t x) y)) '() cols)) m)))
```

### 2.38
3/2
1/6
(1 (2 (3 ())))
(((() 1) 2) 3)
op必须满足交换律和结合律

### 2.39
```scheme
(define (reverse1 seq)
    (fold-right (lambda (x y) (append y (list x))) '() seq))

(define (reverse2 seq)
    (fold-left (lambda (x y) (cons y x)) '() seq))
```

### 2.41
```scheme
(define (p n s)
    (filter (lambda (x) (= s (pick 3 x)))
        (map (lambda (p) (append p (list (+ (pick 0 p) (pick 1 p) (pick 2 p))))) (
            flatmap (lambda (i) (
                flatmap (lambda (j) (
                    map (lambda (k) (list k j i)) (enumerate-n j n)
                )) (enumerate-n i (- n 1))
            )) (enumerate-n 1 (- n 2))
        ))))
```

### 2.42
```scheme
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
```

### 2.53
1. (a b c)
2. ((george))
3. (y1 y2)
4. #f
5. #f
6. #t

### 2.54
```scheme
(define (equal? a b)
    (cond ((and (pair? a) (pair? b)) 
            (and (eq? (car a) (car b)) (equal? (cdr a) (cdr b))))
          ((and (not (pair? a)) (not (pair? b)))
            (eq? a b))
          (else #f)))
```

### 2.55
(car ''a) => (car (quote (quote a))) => (car '(quote a)) => quote

### 2.56 2.57
```scheme
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
```

### 2.58
```scheme

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
```

### 2.63
结果一样，但是第二个更快一些（复杂度为n）。

### 2.64
想要解释真的很困难。复杂度大概是这样（鉴于这个算法是正确的，我们省略多余的参数，用n代表处理的表的规模）：
partical-tree n =
pt n/2 + pt n/2 =
pt n/4 + pt n/4 + pt n/4 + pt n/4 =
...
1 1 1 1 ... n个一
所以算法复杂度为n。

### 2.65
先转为有序表，应用有序表的操作，再转回二叉树即可。

### 2.67
(a d a b b c a)

### 2.68
```scheme
(define (encode-symbol symbol tree)
    (cond ((leaf? tree) '())
          ((memq symbol (symbols (left-branch tree))) (cons 0 (encode-symbol symbol (left-branch tree))))
          ((memq symbol (symbols (right-branch tree))) (cons 1 (encode-symbol symbol (right-branch tree))))
          (else (error "bad symbol -- ENCODE-SYMBOL"))))
```

### 2.69
```scheme
(define (sucessive-merge set)
    (display set)
    (if (eq? (cdr set) '())
        (car set)
        (sucessive-merge (adjoin-set (make-code-tree (pick 0 set) (pick 1 set)) (cut 2 set) ))))
```

### 2.70
84 vs 108

### 2.71
1,n - 1

### 2.72
最频繁的符号Θ(n)
最不频繁的符号Θ(n^2)

### 3.1
```scheme
(define (make-accumulator num)
    (lambda (x) 
        (begin (set! num (+ num x)) num)))
```

### 3.4
```scheme
(define (make-account amount password)
    (define (withdraw x)
        (if (> x amount)
            "No enough money"
            (set! amount (- amount x))))
    (define (deposit x)
        (set! amount (+ amount x)))
    (lambda (pwd op)
        (if (not (equal? pwd password))
            "Incorrect password"
            (cond ((equal? op 'withdraw) withdraw)
                  ((equal? op 'deposit) deposit)
                  (else (error "No such operation"))))))
```

### 3.8
```scheme
(define f
    (let ((a 1))
        (lambda (x)
            (set! count (* count x))
            count)))
```

### 3.16
```scheme
; output 3
(count-pairs (list 1 2 3))

; output 4
(define a (list 1))
(define b (cons 2 a))
(count-pairs (cons b a))

; output 7
(define x (list 1))
(define y (cons x x))
(define z (cons y y))
(count-pairs z)
```

### 3.17
```scheme
(define visited '())
(define (count-pairs-right x)
    (define (help cur)
        (if (or (not (pair? cur)) (memq cur visited))
            0
            (begin (set! visited (append visited (list cur))) (+ 1 (help (car cur)) (help (cdr cur))))))
    (begin (set! visited '()) (help x)))
```

### 3.19
```scheme
 (define (has-circle? x)
    (define (next-turtle turtle)
        (if (null? (cdr turtle))
            #f
            (cdr turtle)))
    (define (next-rabbit rabbit)
        (if (or (null? (cdr rabbit)) (null? (cdr (cdr rabbit))))
            #f
            (cdr (cdr rabbit))))
    (define (helper turtle rabbit)
        (let ((n-turtle (next-turtle turtle))
              (n-rabbit (next-rabbit rabbit)))
              (cond ((or (not n-turtle) (not n-rabbit)) #f)
                    ((eq? n-turtle n-rabbit) #t)
                    (else (helper n-turtle n-rabbit)))))
    (helper x (next-rabbit x)))
```

### 3.21
```scheme
(define (print-queue queue)
    (newline)
    (if (empty-queue? queue)
        (display "<empty queue>")
        (display (front-ptr queue))))
```

### 3.28
```scheme
(define or-gate-delay 4)

(define (or-gate a1 a2 output)
    (define (or)
        (let ((new-value (logical-or (get-signal a1) (get-signal a2))))
             (after-delay or-gate-delay (lambda () (set-signal! output new-value)))))
    (add-action! a1 or)
    (add-action! a2 or)
    'ok)

(define (logical-or a1 a2)
    (bool-to-num (or (num-to-bool a1) (num-to-bool a2))))
```

### 3.33
```python
def average(a, b, c):
    u1 = Connector()
    u2 = Connector()
    Adder(a, b, u1)
    Constant(u2, 0.5)
    Multipier(u1, u2, c)
```

### 3.34
When set b,the value of a won't change.

### 3.39
这个问题其实颇为复杂。让我们将这几个过程重写为以下三个过程
``` 
P1: lock
    get x * x
    unlock
P2: set x = P1's result
P3: 1.lock
    2.get x + 1
    3.set x + 1 to x
    4. unlock
```
注意到P2必须在P1执行完毕之后执行。上面列的每一步都是原子化的。下面就几个可能的步骤序列进行分析。
* P1 -> P2 -> P3
* P3 -> P1 -> P2
* P1 -> P3.1 -> P2 -> P3.rest
* P1 -> P3.2 -> P2 -> P3.rest
* P1 -> P3.3 -> P2 -> P3.rest  

可以得到四个结果：`(11 101 121 100)`

### 3.40
(100,1000,10000,100000,1000000)
未并行化的：(1000000)

### 3.41
it doesn't matter

### 3.42
it doesn't matter

### 3.44
Louis is wrong.

### 3.45
从串行化器的基本性质来看，serialized-exchange保护了a1和a2的状态，其他任何操作如果正确的实施了串行化，那么会被暂停执行。在Louis的代码中，exchange现在也会将操作串行化，这就导致exchange被暂停执行。根本原因是一个procedure内使用了两次串行化。从锁的角度理解容易许多。

### 3.50
```scheme
(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      the-empty-stream
      (cons-stream
       (apply proc (map stream-car argstreams))
       (apply stream-map
              (cons proc (map stream-cdr argstreams))))))
```

### 3.51
0  
1 2 3 4 5  
6 7

### 3.52
2^n-1

### 3.53
```scheme
(define factorials  
   (cons-stream 1  
        (mul-streams factorials (stream-cdr integers))))
``` 

### 3.56
```scheme
(define S (cons-stream 1 (merge (scale-stream 2 S) (merge (scale-stream 3 S) (scale-stream 5 S)))))
```

### 3.57
由于流本身并不保存状态，隐式定义的流等同于递归。而保存状态的流等同于记忆化的递归。

### 3.58
若num/den < 1，则是以radix为底的num/den的以小数表示的各个位。若num/den>1，则我不能描述。例证：
```scheme
(expand (1 7 10))
; (1 4 2 8 5 7 1 4 2 8 ... )
(/ 1.0 7)
;.14285714285714285
(expand (13 16 2))
; (1 1 0 1 ...)
; 13 / 16 in base 2 is 0.1101 
```

### 3.59
```scheme
(define cosine-series (cons-stream 1 (stream-map - (integerate-series sine-series))))
(define sine-series (cons-stream 0 (integerate-series cosine-series)))
```

### 3.60
```scheme
(define (mul-series s1 s2)
    (cons-stream (* (stream-car s1) (stream-car s2))
            (add-stream (scale-stream (stream-car s2) (stream-cdr s1)) (mul-series s1 (stream-cdr s2)))))
```
解析：注意到$S_1 * S_2 = S_1 * (a + S_2') = S_1 * a + S_1 * S_2'$。初始条件已经给出给出，故后续需要排除初始条件，即`scale-stream`调用中的`(stream-cdr s1)`

### 3.61
```scheme
(define (get-x S)
    (cons-stream 1 (mul-series (stream-map - (stream-cdr S)) (get-x S))))
```

### 3.62
```scheme
(define (div-series s1 s2)
    (mul-series s1 (get-x s2)))
```

### 3.66
通过小学水平的找规律可知：  
$$
when \quad n - m = 0;\quad P(m,n) = 2^m - 1 \\
when \quad n - m = 1;\quad P(m,n) = 2^m - 1 + 2^{m - 1} \\
when \quad n - m >= 2;\quad P(m,n) = 2^m - 1 + 2^{m - 1} + (n - m + 1)*2^m
$$
