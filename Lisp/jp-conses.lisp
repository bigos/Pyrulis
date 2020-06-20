;;; jp-conses

(declaim (optimize (debug 3) (speed 0)))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload
   '(:alexandria :draw-cons-tree :tamei)))

(defpackage :jp-conses
  (:use #:cl))

;;; s-e to use it in REPL
(in-package :jp-conses)

(defparameter data " 1 + 2 + (3 - 4) * 5 # comment")

(defun dt (ls)
  (draw-cons-tree:draw-tree ls))

(defun flatten (lx)
  (labels ((atomize (l &optional a)
             (cond ((null  l) a)
                   ((atom  l) (cons l a))
                   ((consp l) (atomize (car l)
                                       (atomize (cdr l) a)) ))))
    (atomize lx)))

(defun deep-reverse (tr)
  (cond ((atom tr)
         tr)
        ((consp tr)
         (cons (deep-reverse (cdr tr))
               (deep-reverse (car tr))))))

(defun flat-reverse (tr &optional acc)
  (cond ((null tr) acc)
        (T         (flat-reverse (cdr tr) (cons (car tr) acc)))))

(defun add-last (el ls)
  (cond
    ((null ls)
     (cons el nil))
    ((atom ls)
     (cons ls (cons el nil)))
    (T (rplacd (last ls)
               (cons el nil))
       ls)))

(defun add-deep-last (el ls)
  (cond
    ((null ls)
     (cons el ls))
    ((atom ls)
     (add-last el ls))
    (T (rplaca ls
               (cons (add-last el (first ls))
                     (rest ls)))
       ls)))

(defun add-deep-first (el ls)
  (cond
    ((null ls)
     (cons el ls))
    ((atom ls)
     (add-last el ls))
    (T  (rplaca ls
                (cons (add-last el (first ls))
                      (rest ls)))
        ls)))

(defun last-els (n ls)
  (let ((lnls (length ls)))
    (subseq ls (max
                (- lnls n)
                0))))
