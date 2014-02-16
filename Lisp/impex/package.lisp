(defpackage #:impex
  (:use #:cl #:foo #:bar #:baz))

(defpackage #:foo
  (:use #:cl) (:export :foo1))

(defpackage #:bar
  (:use #:cl) (:export :bar1))

(defpackage #:baz
  (:use #:cl) (:export :baz1))
