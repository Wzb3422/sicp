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

**Exercise 1.8:**

Newton’s method for cube roots is based on the fact that if y is an approximation to the cube root of x , then a beer approximation is given by the value
x/y2 +2y. 3
Use this formula to implement a cube-root procedure anal- ogous to the square-root procedure. (In Section 1.3.4 we will see how to implement Newton’s method in general as an abstraction of these square-root and cube-root procedures.)

```scheme
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
```

**Exercise 1.9:**

Each of the following two procedures defines a method for adding two positive integers in terms of the procedures inc, which increments its argument by 1, and dec, which decrements its argument by 1.

```scheme
(define (+ a b)
	(if (= a 0) b (inc (+ (dec a) b))))
(define (+ a b)
	(if (= a 0) b (+ (dec a) (inc b))))
```

Using the substitution model, illustrate the process gener- ated by each procedure in evaluating `(+ 4 5)`. Are these processes iterative or recursive?

**Using substitution model:**

recursive process

```scheme
(+ 4 5)
(inc (+ (dec 4) 5))
(inc (+ 3 5))
(inc (inc (+ (dec 3) 5)))
(inc (inc (+ 2 5)))
(inc (inc (inc (+ ((dec 2) 5)))))
(inc (inc (inc (+ 1 5))))
(inc (inc (inc (inc (+ (dec 1) 5)))))
(inc (inc (inc (inc (+ 0 5)))))
(inc (inc (inc (inc 5))))
(inc (inc (inc 6)))
(inc (inc 7))
(inc 8)
9
```

iterative process

```scheme
(+ 4 5)
(+ (dec 4) (inc 5))
(+ 3 6)
(+ (dec 3) (inc 6))
(+ 2 7)
(+ (dec 2) (inc 7))
(+ 1 8)
(+ dec(1) (inc 8))
(+ 0 9)
9
```



**Exercise 1.10:**

The following procedure computes a mathematical function called Ackermann’s function.

```scheme
(define (A x y)
  (cond ((= y 0) 0)
	((= x 0) (* 2 y))
 	((= y 1) 2)
	(else (A (- x 1) (A x (- y 1))))))
```

What are the values of the following expressions?

```scheme
(A 1 10)
(A 2 4)
(A 3 3)
```

Consider the following procedures, where A is the procedure defined above:

```scheme
(define (f n) (A 0 n))
(define (g n) (A 1 n))
(define (h n) (A 2 n))
(define (k n) (* 5 n n))
```

Give concise mathematical definitions for the functions com- puted by the procedures f, g, and h for positive integer val- ues of n. For example, (k n) computes $5n^2$ 

