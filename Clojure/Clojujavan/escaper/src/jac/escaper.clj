(ns jac.escaper
  (:gen-class
   :methods [#^{:static true} [foo [String] void]]))

(defn -foo
  "I don't do a whole lot."
  [x]
  (prn x "Hello, World!"))
