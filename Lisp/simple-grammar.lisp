;;; parsing ip numbers, arguments to grammar nodes are either seq or alt
(defparameter better-grammar '((ip (seq num dot num dot num dot num))
                               (dot (alt
                                     #\.))
                               (num (seq dig dig dig))
                               (dig (alt
                                     #\0
                                     #\1
                                     #\2
                                     #\3
                                     #\4
                                     #\5
                                     #\6
                                     #\7
                                     #\8
                                     #\9))))
