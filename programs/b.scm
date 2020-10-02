
; some basic definition

(define nil '())

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

(define (flatmap op seq)
    (accumulate append nil (map op seq)))

(define (enumerate-n s e)
    (if (> s e)
        nil
        (cons s (enumerate-n (+ s 1) e))))

(define (filter p seq)
    (if (null? seq)
        nil
        (if (p (car seq))
            (cons (car seq) (filter p (cdr seq)))
            (filter p (cdr seq)))))

(define (find l f)
    (if (null? l)
        #f
        (if (f (car l))
            (car l)
            (find (cdr l) f))))

(define (pick n seq)
    (if (= n 0)
        (car seq)
        (pick (- n 1) (cdr seq))))

(define (head seq)
    (if (null? (cdr seq))
        nil
        (cons (car seq) (head (cdr seq)))))

(define (tail seq)
    (if (null? (cdr seq))
        (car seq)
        (tail (cdr seq))))

(define (cut n l)
    (if (= n 0)
        l
        (cut (- n 1) (cdr l))))

(define (len l)
    (if (null? l)
        0
        (+ 1 (len (cdr l)))))

(define (assert p word)
    (if p
        nil
        (error word)))

(define (num-to-bool n)
    (if (= n 0)
        #f
        #t))

(define (bool-to-num b)
    (if b
        1
        0))

; 类型分派实现
(define (attach-tag tag data)
    (list 'taged-data tag data))

(define (taged-data? data)
    (and (pair? data) (eq? (car data) 'taged-data)))

(define (type-tag data)
    (if (not (taged-data? data))
        (error "not taged-data -- TYPE-TAG")
        (pick 1 data)))

(define (contents data)
    (if (not (taged-data? data))
        (error "not taged-data -- CONTENTS")
        (pick 2 data)))

(define global-type-derive-table '())

(define (put op tags func)
    (set! global-type-derive-table (append global-type-derive-table (list (list op tags func)))))

(define (get op tags)
    (let ((result (find global-type-derive-table (lambda (item) (and (eq? (pick 0 item) op) (eq? (pick 1 item) tags))))))
        (if result
            (pick 2 result)
            (error "can not find -- GET -- The argument is" op tags))))

(define (apply-generic op . args)
    (let ((type-tags (map type-tag args)))
         (let ((proc (get op type-tags)))
              (apply proc (map contents args)))))

; queue
(define (make-queue)
    (let ((queue (cons '() '())))
         (define (empty-queue?)
            (null? (front-ptr)))
         (define (front-ptr)
            (car queue))
         (define (rear-ptr)
            (cdr queue))
         (define (set-front-ptr! item)
            (set-car! queue item))
         (define (set-rear-ptr! item)
            (set-cdr! queue item))
         (define (front-queue)
            (if (empty-queue?)
                (error "QUEUE -- call on empty queue")
                (car (front-ptr))))
         (define (insert-queue! item)
            (let ((new-pair (cons item '())))
                (cond ((empty-queue?)
                        (set-front-ptr! new-pair)
                        (set-rear-ptr! new-pair)
                        queue)
                      (else
                        (set-cdr! (rear-ptr ) new-pair)
                        (set-rear-ptr! new-pair)
                        queue))))
         (define (delete-queue!)
            (cond ((empty-queue? ) (error "DELETE -- call on empty queue"))
                  (else (set-front-ptr! (cdr (front-ptr)))
                        queue)))
         (define (print-queue)
            (newline)
            (if (empty-queue?)
                (display "<empty queue>")
                (display (front-ptr))))
         (define (dispatch op)
             (cond ((eq? op 'empty?) (empty-queue?))
                   ((eq? op 'insert!) insert-queue!)
                   ((eq? op 'delete!) (delete-queue!))
                   ((eq? op 'front) (front-queue))
                   ((eq? op 'print) (print-queue))
                   (else (error "QUEUE -- Unknown operation"))))
         dispatch))

(define (empty-queue? q)
    (q 'empty?))

(define (insert-queue! q item)
    ((q 'insert!) item))

(define (delete-queue! q)
    (q 'delete!))

(define (front-queue q)
    (q 'front))

(define (print-queue q)
    (q 'print))


; -- test --
;(cut '(a + b) 1)
;(len '(a + b + c + d))

;(put 'plus 'number +)
;(put 'minus 'number -)
;(newline )
;(display global-type-derive-table)
;((get 'plus 'number ) 3 5)
;((get 'minus 'number) 6 5)
;((get '() '()) 1 1)

; -- queue test --
;(define q (make-queue))
;(print-queue q)
;(insert-queue! q 'a)
;(print-queue q)
;(insert-queue! q 'b)
;(insert-queue! q 'c)
;(print-queue q)
;(delete-queue! q)
;(delete-queue! q)
;(print-queue q)