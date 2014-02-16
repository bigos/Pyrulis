(defpackage #:foo
  (:use #:cl) (:export :foo1))

(defpackage #:bar
  (:use #:cl) (:export :bar1))

(defpackage #:baz
  (:use #:cl) (:export :baz1))

;; this package should go last in order
;; to correctly use above packages
(defpackage #:impex
  (:use #:cl #:foo #:bar #:baz))
