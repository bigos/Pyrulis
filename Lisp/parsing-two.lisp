;;; parsing TWO - playing with the parsing basics

(declaim (optimize (speed 0) (safety 2) (debug 3)))

(ql:quickload :alexandria)

(defpackage #:parsing-two
  (:use #:cl))

;;; --- put cursor at the end of the next s-expr and press s-e to copy to REPL -
(in-package #:parsing-two)

(defun data ()
  (format nil " 123 + 456 # comment"))

;;; character extraction
(proclaim `(ftype (function ((simple-array character) fixnum) character) at))
(defun at (string index)
  "STRING character at index"
  (aref string index))

;;; character consumption

(defun consume (data index predicates)
  "take character from DATA at INDEX and return on the first of PREDICATES
  giving ok or error"
  (if (null predicates)
      (list 'error (at data index))
      (if (funcall (first predicates) (at data index))
          (list 'ok (at data index))
          (consume data index (cdr predicates)))))

;; (repeat-consume (data) 13 nil (list 'alpha-char-p) nil)
(defun repeat-consume (data index count predicates acc)
  "call consume function at most COUNT times or to the end of the DATA
  if COUNT is nil"
  (if (or (when count (zerop count))
          (>= index (length data)))
      (list 'ok (reverse acc))
      (if (eq 'ok (car (consume data index predicates)))
          (repeat-consume data
                          (1+ index)
                          (when count (1- count))
                          predicates
                          (cons (at data index)
                                acc))
          (list 'error (at data index)))))
