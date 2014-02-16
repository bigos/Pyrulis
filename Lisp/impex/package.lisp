(defpackage #:impex
  (:use #:cl))

(defpackage #:foo
  (:use #:cl) (:export :foo1))

(defpackage #:bar
  (:use #:cl) (:export :bar1))

(defpackage #:baz
  (:use #:cl) (:export :baz1))
