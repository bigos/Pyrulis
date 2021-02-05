(defsystem "verti"
  :version "0.1.0"
  :author "Jacek Podkanski"
  :license ""
  :depends-on (#:alexandria)
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "verti/tests"))))

(defsystem "verti/tests"
  :author "Jacek Podkansdki"
  :license ""
  :depends-on (#:verti
               #:fiveam)
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for verti"
  :perform (test-op (op c) (symbol-call :fiveam :run! (find-symbol*
                                                       '#:all-tests
                                                       '#:verti/tests/main))))
