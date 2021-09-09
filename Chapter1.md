**Exercise 1.1:** 

Below is a sequence of expressions. What is the result printed by the interpreter in response to each expression? Assume that the sequence is to be evaluated in the order in which it is presented.

```scheme
10 ; 10
(+ 5 3 4) ; 12
(- 9 1) ; 8
(/ 6 2) ; 3
(+ (* 2 4) (- 4 6)) ; 6
(define a 3)
(define b (+ a 1))
(+ a b (* a b)) ; 19
(= a b) ; #f
(if (and (> b a) (< b (* a b)))
		b
    a) ; 4
(cond ((= a 4) 6)
			((= b 4) (+ 6 7 a))
			(else 25)) ; 16
(+ 2 (if (> b a) b a)) ; 6
(* (cond ((> a b) a)
     		 ((< a b) b)
				 (else -1))
   (+ a 1)) ; 16
```

**Exercise 1.2:**

Translate the following expression into prefix form:

```scheme
(/ (+ 5 4 (- 2 (- 3 (+ 6 (/ 4 5)))))
   (* 3 (- 6 2) (- 2 7))
```

**Exercise 1.3:**

Define a procedure that takes three numbers as arguments and returns the sum of the squares of the two larger numbers.

```scheme
(define (sum-of-squares a b) (+ (* a a) (* b b)))
(define (two-largest a b c)
  			(cond (and (< a b) (< a c)) (sum-of-squares b c)
              (and (< b a) (< b c)) (sum-of-squares a c)
              (and (< c b) (< c a)) (sum-of-squares a b)))
```

**Exercise 1.4:**

Observe that our model of evaluation allows for combinations whose operators are compound expressions. Use this observation to describe the behavior of the following procedure:

```scheme
(define (a-plus-abs-b a b)
  			((if (> b 0) + -) a b))
```

**Answer:**

The procedure defined above, which is named `a-plus-abs-b`, accepts two formal parameters. The operator of the body is a compound expression which evaluates `+`  when `b` is larger than `0`, otherwise `-`, then applies the operation to `a` and `b` to retrieve the result.

**Exercise 1.5:**

Ben Bitdiddle has invented a test to determine whether the interpreter he is faced with is using applicative- order evaluation or normal-order evaluation. He defines the following two procedures:

```scheme
(define (p) (p))
(define (test x y)(if (= x 0) 0 y))
```


Then he evaluates the expression

```scheme
(test 0 (p))
```

What behavior will Ben observe with an interpreter that uses applicative-order evaluation? What behavior will he observe with an interpreter that uses normal-order evaluation? Explain your answer.

(Assume that the evaluation rule for the special form if is the same whether the interpreter is using normal or applicative order: The predicate expression is evaluated first, and the result determines whether to evaluate the consequent or the alternative expression.)

**Answer:**

Applicative-Order Evaluation: Interpreter retrieves the definition of `(p)` which is still `(p)`, as it's defined `(define (p) (p))`. Hence, The evaluation is caught in a loop that can never stop.

![image-20210909141417918](/Users/wuzhenbin/Library/Application Support/typora-user-images/image-20210909141417918.png)

Normal- Order Evaluation:

```scheme
(test 0 (p)) =>
(if (= 0 0) 0 (p))
```

For `0` equals `0`, the expression is evaluate to `0`, and successfully exits.

**Exercise 1.6:**

Alyssa P. Hacker doesn’t see why `if` needs to be provided as a special form. “Why can’t I just define it as an ordinary procedure in terms of `cond?`” she asks. Alyssa’s friend Eva Lu Ator claims this can indeed be done, and she defines a new version of `if`:

```scheme
(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
				(else else-clause)))
```


 Eva demonstrates the program for Alyssa:

```scheme
(new-if (= 2 3) 0 5)
5
(new-if (= 1 1) 0 5)
0
```

Delighted, Alyssa uses `new-if` to rewrite the square-root program:

```scheme
(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
          guess
          (sqrt-iter (improve guess x) x)))
```

What happens when Alyssa attempts to use this to compute square roots? Explain.

**My Explanation:**

What will happen? 

The program never exits. It is caught in infinite recursion.

Alyssa substitutes `new-if` function for `if` express. The difference is that when a function is called, Scheme attempts to evaluate all of the arguments. While `(good-enough? guess x)` can be successfully evaluated, `(sqrt-iter (improve guess x) x)))` will be caught in a infinite recursion.

**Exercise 1.7:**

The `good-enough?` test used in computing square roots will not be very effective for finding the square roots of very small numbers. Also, in real computers, arithmetic operations are almost always performed with limited precision. This makes our test inadequate for very large numbers. Explain these statements, with examples showing how the test fails for small and large numbers. An alternative strategy for implementing `good-enough?` is to watch how guess changes from one iteration to the next and to stop when the change is a very small fraction of the guess. Design a square-root procedure that uses this kind of end test. Does this work better for small and large numbers?

**My Explanation:**

The problem with `good-enough?` procedure for small numbers is that when the radicant is much smaller than 0.001, the hardcoded threshold. The logic does NOT improves the result any further, for the guess has passed the threshold.

The problem with larger numbers: when you enter a super large number, like `891289367812936781283671986123` , the program will be stuck in a endless loop, as the it can't imporve the guess any further.

Hence, the threshold should NOT be hardcoded. 

```scheme
(define (within-delta? x y delta)
  (<= (abs (- x y)) delta))
```

