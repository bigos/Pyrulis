;;; file

(def dat "abbcccddecccc")

(defn group-same [seq last sames acc]
  (print seq last sames " ---- " acc "\n")
  (if (= (first seq) :end)
    (rest (reverse  acc))
    (let [nv (if (empty? seq)
               (list :end)
               (rest seq))]
        (if (= last (first seq))
          (recur nv
                 (first seq)
                 (cons (first seq) sames)
                 acc)
          (recur nv
                 (first seq)
                 []
                 (if (empty? sames)
                   (cons (list last) acc)
                   (cons (cons last sames) acc)))))))
