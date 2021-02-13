;;;; graph-toy.asd

;;; testing
;; (asdf:test-system 'graph-toy)
(asdf:defsystem #:graph-toy
  :description "Describe graph-toy here"
  :author "Jacek Podkanski"
  :license  "public domain"
  :version "0.0.1"
  :serial t
  :depends-on (#:alexandria)
  :components ((:file "package")
               (:file "key-shortcuts")
               (:file "link")
               (:file "graph")
               (:file "com")
               (:file "graph-toy"))
  :in-order-to ((test-op (test-op "graph-toy/tests"))))

;; http://turtleware.eu/posts/Tutorial-Working-with-FiveAM.html
(asdf:defsystem #:graph-toy/tests
  :depends-on (:graph-toy :fiveam)
  :components ((:module "tests"
                :serial t
                :components ((:file "package")
                             (:file "main"))))
  :perform (test-op (o s)
                    (uiop:symbol-call
                     :fiveam :run! (find-symbol*
                                    '#:all-tests
                                    '#:graph-toy/tests))))
