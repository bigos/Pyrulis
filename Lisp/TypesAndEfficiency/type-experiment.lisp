;; https://chriskohlhepp.wordpress.com/convergence-of-modern-cplusplus-and-lisp/

;; Template Specialization

;; We have already met template specialization. When we wrote…

;; Screen Shot 2014-04-08 at 5.31.26 PM
; xplusone<int>

;; we completed the type definition of xplusone. You might say, we annotated the template with its type. xplusone is now fully specified. What we are saying here is: we know. We know that this algorithm will work with integers, much the same as declaring a function Foo() to take arguments of type Stack. Nothing is left for the compiler to infer. The problem of type has been solved at compile time. How then does Lisp compare here as a dynamically typed language? Can we similarly annotate xplusone in Lisp ? As it turns out, we can. In the spirit of Haskell Curry’s U-language, we might expect this to read something like the English sentence: “I DECLARE that the TYPE of the FUNCTION xplusone is integer -> integer.” Lisp uses the operators proclaim and declaim for the purpose.

;; Screen Shot 2014-04-08 at 5.32.17 PM
;; (declaim
;;  (ftype
;;   (function (integer) integer)
;;   xplusone))

;; So we have a function that takes an (integer) argument and is itself and integer. We are further saying this relation is a function type and xplusone satisfies is. One thing to note is the correspondence between the manner in which declaim in Lisp and decltype in C++ both declare the type of our expression external to the expression itself. In any event, we have specified the full signature of our algorithm. We may now ask Lisp to describe what it knows about our function.

;; Screen Shot 2014-04-08 at 5.33.13 PM
;; in repl
;; running above lisp code with declaim
;; then
;; (defun xplusone (x) (+ x 1))
;; then
;; (describe #'xplusone)

;; But what of Lisp’s dynamic nature? Is this not merely an optimization hint? Let’s see. Instead of evaluating xplusone with a non integer type, let us write another function that would violate our type constraints and attempt to compile that.

;; Screen Shot 2014-04-08 at 5.34.47 PM
;; catching the type error at function definition stage
;; in repl
;; (defun more (x) (* 2 (xplusone "foo")))
;; gives compilation error

;; We note that the type mismatch has been detected at compile type, not at run time. This is because the whole of the Lisp system is available both at run time and compile time, a key feature needed to support Lisp’s macro system. So in principle, features available at runtime can also be made available at compile time. It is up to the implementation how to handle type mismatch conditions. More importantly, it is up to the developer to elicit them.

(declaim (optimize (speed 3) (safety 0) (space 0) (debug 3)))

(defun foo (x y)
  (logxor x y))

(defun bar (x y)
  (declare (type (integer 0 255) x y))
  (+ (logior x 1) (logior y 2)))

(defun wrong-me ()
  (bar "wrong" 'me))
