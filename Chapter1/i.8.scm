(define (square x) (* x x))
(define (cube x) (* x (* x x)))

(define (abs x)
  (cond ((x < 0) -x)
        (else x)))

(define (improve guess x)
        (/ (+ (/ x (square y)) (* 2 guess)) 3))

(define (within-delta guess x delta)
  (< abs(- (cube guess) x) delta))

(define (cbrt guess x)
  (if (within-delta guess x 0.001)
      guess
      (cbrt (improve guess x) x)))


(cbrt 1 23)
