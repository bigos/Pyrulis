(declaim (optimize (speed 0) (debug 3)))

#| loading
(load "~/Programming/Pyrulis/Lisp/fistma-graph.lisp")
(in-package #:fistma-graph)
(draw-graph *graph*)
(draw-graph (dot-links *nested*))
|#


(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria serapeum dot-cons-tree)))

(defpackage #:fistma-graph
  (:use #:cl)
  (:local-nicknames (#:se #:serapeum) (#:ax #:alexandria)))

(in-package #:fistma-graph)

(defparameter *graph*
  ;; source action target
  '((closed lock locked)
    (closed open opened)
    (locked "unlock me" closed)
    (opened close closed)))

;; (draw-graph *psalm*)
(defparameter *psalm*
  '((happy is the_man)
    (the_man who)
    (who does not)
    (not walk)
    (walk according to the advice)
    (advice of the wicked)
    (who and)
    (and does not) (not stand)
    (stand on the path)
    (path of sinners)
    (not sit)
    (sit in the seat)
    (seat of scoffers)
    (the_man but his delight)
    (delight is in the law)
    (law of Jehovah)
    (the_man and he)
    (his law)
    (he reads reads)
    (reads in an undertone)
    (reads his)
    (reads day)
    (day and night)))

(defparameter *nested*
  ;; (source (action target))
  '((closed
     (lock locked)
     (open opened))
    (locked
     (unlock closed))
    (opened
     (close closed))))

;; (draw-graph (dot-links *draw*))
(defparameter *draw*
  '((draw
     (init blank))
    result
    (ui_event canvas_result)
    (close_event blank)
    (blank
     (ui_event canvas_result)
     (clear blank))
    (blank (quit_event quit))
    ))

;; cleaning up the
;; (nest (unnest *agape*))
;; REPL use
;; (draw-graph (dot-links *agape*))
(defparameter *agape* '((IT
                         ("was said" YOU2))
                        (YOU2
                         ("must love your" NEIGHBOUR)
                         ("hate your" ENEMY))
                        (THOSE_WHO
                         (PRESECUTE YOU))
                        (ENEMIES
                         (IMPLIES THOSE_WHO))
                        (SUN
                         ("raise on" WICKED)
                         ("raise on" GOOD))
                        (FATHER
                         ("makes his" SUN)
                         ("makes his" RAIN)
                         (IS PERFECT))
                        (RAIN
                         (ON RIGTEOUS)
                         (ON UNRIGHTEOUS))
                        (THE_SONS
                         ("of your" FATHER))
                        (YOU
                         (HEARD IT)
                         ("continue to love your" ENEMIES)
                         ("SHOULD pray for" THOSE_WHO)
                         ("prove yourselves" THE_SONS)
                         ("must accordingly be" PERFECT))
                        (I
                         ("say to"  YOU))
                        (ENEMY
                         (PLURAL ENEMIES))))

(defun example ()
  (draw-graph (dot-links '((n (n n) (ws ws) (dot dot))
                           (begin (mn znmn) (pl znpl))
                           (znmn (n n))
                           (znpl (n n))
                           (dot (ndot dot) (ws ws))))))

(defun dot-links (l)
  "Take a nested graph L and convert it to list of links for draw-graph."
  (let ((a))
    (loop for s in l do
      (unless (atom (car s)) (error "Source must be an atom"))
      (loop for at in (cdr s) do
        (unless (atom (car  at)) (error "Action must be an atom"))
        (unless (atom (cadr at)) (error "Target must be an atom"))
        (push (cons (car s) at) a)))
    (reverse a)))

;; (nest *graph*)
(defun nest (ul)
  (let ((ht (make-hash-table)))
    (loop for n in ul do
      (push
       (cdr n)
       (gethash (first n) ht)))
    (let ((coll))
      (maphash
       (lambda (k v) (push (CONS k v) coll))
       ht)
      coll)))

;; (unnest *nested*)
(defun unnest (nl)
  (let ((ht (make-hash-table)))
    (loop for n in nl do
      (loop for l in (cdr n) do
        (push
         (cons (car n) l)
         (gethash (car n) ht))))
    (let ((coll))
      (maphash
       (lambda (k v) (declare (ignore k)) (loop for x in v do (push x coll)))
       ht)
      (reverse coll))))

;; (sources *nested*)
(defun sources (nl)
  (mapcar #'car nl))

;; (actions *nested*)
(defun actions (nl)
  (ax:flatten
   (mapcar
    (lambda (x) (mapcar #'car (cdr x)))
    nl)))

;; (targets *nested*)
(defun targets (nl)
  (ax:flatten
   (mapcar
    (lambda (x) (mapcar #'cdr (cdr x)))
    nl)))

(defun prepare-graph (file-name data)
  "Take DATA and prepare a digraph to be written into FILE-NAME."
  (with-open-file ( fh file-name :direction :output :if-exists :supersede)
    (format fh "digraph {~%")
    (loop for c in data do
      (format fh "~A -> ~A [label=\"~a\"]~%"
              (car c)
              (car (last c))
              (with-output-to-string (s)
                (loop for ch in (cdr (butlast c))
                      collect (format s " ~A" ch)))
              ))
    (format fh "}~%")))

(defun draw-graph (data)
  (let ((filename "fistma-graph")
        ;; png is better for emailing, svg is better for scaling
        (extension "svg"))
    (let ((gv-file (format nil "/tmp/~A.gv" filename)))
      (prepare-graph gv-file data)

      (let ((the-file(format nil "/tmp/~A.~A" filename extension)))
        (let ((options (list
                        (format nil "-T~A" extension)
                        gv-file
                        "-o"
                        the-file)))
          (format t "dot options ~A~%" options)
          (sb-ext:run-program "/usr/bin/dot" options))))))
