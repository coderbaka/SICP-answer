; simple electric simulator

(load "b.scm")

(define (make-wired)
    (let ((signal-value 0) (action-procedures '()))
        (define (set-signal! new-value)
            (if (not (= signal-value new-value))
                (begin (set! signal-value new-value) (call-each action-procedures))
                'done))
        (define (add-action-procedures! proc)
            (set! action-procedures (cons proc action-procedures))
            (proc))
        (define (dispatch op)
            (cond ((eq? op 'get-signal) signal-value)
                  ((eq? op 'set-signal!) set-signal!)
                  ((eq? op 'add-action!) add-action-procedures!)
                  (else (error "WIRED -- Unknown operations"))))
    dispatch))

(define (call-each procedures)
    (if (null? procedures)
        'done
        (begin ((car procedures)) (call-each (cdr procedures)))))

(define (get-signal wired)
    (wired 'get-signal))

(define (set-signal! wired new-value)
    ((wired 'set-signal!) new-value))

(define (add-action! wired proc)
    ((wired 'add-action!) proc))

(define (make-time-segment time queue)
    (cons time queue))

(define (segment-time seg)
    (car seg))

(define (segment-queue seg)
    (cdr seg))

(define (make-agenda)
    (list 0))

(define (current-time agenda)
    (car agenda))

(define (set-current-time! agenda time)
    (set-car! agenda time))

(define (segments agenda)
    (cdr agenda))

(define (set-segments! agenda segments)
    (set-cdr! agenda segments))

(define (first-segment agenda)
    (car (segments agenda)))

(define (rest-segments agenda)
    (cdr (segments agenda)))

(define (empty-agenda? agenda)
    (null? (segments agenda)))

(define (add-to-agenda! time action agenda)
    (define (belongs-before? segments)
            (or (null? segments)
                (< time (segment-time (car segments)))))
    (define (make-new-time-segment time action)
        (let ((q (make-queue)))
            (insert-queue! q action)
            (make-time-segment time q)))
    (define (add-to-segments segments)
        (if (= (segment-time (car segments)) time)
            (insert-queue! (segment-queue (car segments)) action)
            (let ((rest (cdr segments)))
                 (if (belongs-before? rest)
                     (set-cdr! segments (cons (make-new-time-segment time action) (cdr segments)))
                     (add-to-segments rest)))))
    (let ((segments (segments agenda)))
        (if (belongs-before? segments)
            (set-segments! agenda (cons (make-new-time-segment time action) segments))
            (add-to-segments segments))))

(define (remove-first-item-agenda! agenda)
    (let ((q (segment-queue (first-segment agenda))))
         (delete-queue! q)
         (if (empty-queue? q)
             (set-segments! agenda (rest-segments agenda))
             #f)))

(define (first-item-agenda agenda)
    (if (empty-agenda? agenda)
        (error "FIRST AGENDA ITEM -- on empty agenda")
        (let ((first-segment (first-segment agenda)))
             (set-current-time! agenda (segment-time first-segment))
             (front-queue (segment-queue first-segment)))))

(define the-agenda (make-agenda))

(define (after-delay delay action)
    (add-to-agenda! (+ delay (current-time the-agenda))
                    action
                    the-agenda))

(define (propagate)
    (if (empty-agenda? the-agenda)
        'done
        (let ((first-item (first-item-agenda the-agenda)))
             (first-item)
             (remove-first-item-agenda! the-agenda)
             (propagate))))

(define (probe name wire)
    (add-action! wire (lambda ()
                        (newline)
                        (display name)
                        (display " at time ")
                        (display (current-time the-agenda))
                        (display " new value is ")
                        (display (get-signal wire)))))

(define inverter-delay 2)

(define (inverter input output)
    (define (invert)
        (let ((new-value (logical-not (get-signal input))))
            (after-delay inverter-delay (lambda () (set-signal! output new-value)))))
    (add-action! input invert)
    'ok)

(define (logical-not s)
    (cond ((= s 0) 1)
          ((= s 1) 0)
          (else (error "LOGICAL NOT -- invalid signal"))))

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

; -- test --
;(define w (make-wired))
;(probe "test-wire" w)
;(set-signal! w 1)

;(define in (make-wired))
;(probe 'in in)
;(define out (make-wired))
;(probe 'out out)
;(inverter in out)
;(propagate)

;(define a1 (make-wired))
;(define a2 (make-wired))
;(define out (make-wired))
;(probe 'out out)
;(probe 'a1 a1)
;(probe 'a2 a2)
;(or-gate a1 a2 out)
;(set-signal! a1 1)
;(propagate)
;(set-signal! a2 1)
;(propagate)
;(begin (set-signal! a1 0) (set-signal! a2 0))
;(propagate)