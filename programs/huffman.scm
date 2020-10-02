
(define (make-leaf symbol weight)
    (list 'leaf symbol weight))

(define (leaf? obj)
    (eq? (car obj) 'leaf))

(define (symbol-leaf x)
    (cadr x))

(define (weight-leaf x)
    (caddr x))

(define (make-code-tree left right)
    (list left
          right
          (append (symbols left) (symbols right))
          (+ (weight left) (weight right))))

(define (left-branch tree)
    (car tree))

(define (right-branch tree)
    (cadr tree))

(define (symbols tree)
    (if (leaf? tree)
        (list (symbol-leaf tree))
        (caddr tree)))

(define (weight tree)
    (if (leaf? tree)
        (weight-leaf tree)
        (cadddr tree)))

(define (decode bits tree)
    (define (decode-1 bits current-branch)
        (if (null? bits)
            '()
            (let ((next-branch (choose-branch (car bits) current-branch) ))
                (if (leaf? next-branch)
                    (cons (symbol-leaf next-branch)
                          (decode-1 (cdr bits) tree))
                    (decode-1 (cdr bits) next-branch)))))
    (decode-1 bits tree))

(define (choose-branch bit branch)
    (cond ((= bit 0) (left-branch branch))
          ((= bit 1) (right-branch branch))
          (else (error "bad bit -- CHOOSE-BRANCH"))))

(define (adjoin-set x set)
    (cond ((null? set) (list x))
          ((< (weight x) (weight (car set))) (cons x set))
          (else (cons (car set)
                      (adjoin-set x (cdr set))))))

(define (make-leaf-set pairs)
    (if (null? pairs)
        '()
        (let ((pair (car pairs)))
             (adjoin-set (make-leaf (car pair)
                                    (cadr pair))
                         (make-leaf-set (cdr pairs))))))

(define (encode message tree)
    (if (null? message)
        '()
        (append (encode-symbol (car message) tree)
                (encode (cdr message) tree))))

(define (encode-symbol symbol tree)
    (cond ((leaf? tree) '())
          ((memq symbol (symbols (left-branch tree))) (cons 0 (encode-symbol symbol (left-branch tree))))
          ((memq symbol (symbols (right-branch tree))) (cons 1 (encode-symbol symbol (right-branch tree))))
          (else (error "bad symbol -- ENCODE-SYMBOL"))))

(define (generate-huffman-tree pairs)
    (sucessive-merge (make-leaf-set pairs)))

(load "b.scm")

(define (sucessive-merge set)
    (display set)
    (if (eq? (cdr set) '())
        (car set)
        (sucessive-merge (adjoin-set (make-code-tree (pick 0 set) (pick 1 set)) (cut 2 set) ))))

; test
(define sample-tree
    (make-code-tree (make-leaf 'A 4)
                    (make-code-tree
                        (make-leaf 'B 2)
                        (make-code-tree (make-leaf 'D 1)
                                        (make-leaf 'C 1)))))

(define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))

;(define tree2 (generate-huffman-tree '( (A 4) (B 2) (C 1) (D 1) )))

(define tree3 (generate-huffman-tree '( (a 2) (na 16) (boom 1) (sha 3) (get 2) (yip 9) (job 2) (wah 1) )))

(encode '(get a job sha na na na na na na na na get a job sha na na na na na na na na wah yip yip yip yip sha boom) tree3)

;(decode sample-message sample-tree)
;(encode '(a d a b b c a) tree2)