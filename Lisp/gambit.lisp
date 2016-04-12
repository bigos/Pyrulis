(defparameter *code* '(0 167 254 36 177 190 216 133 1 38 169 4 25 182 7 36 163
                       6 33 177 0 43 98 248 39 180 178 43 177 254 46 171 0 31
                       98 6 32 167 178 255 163 255 26 171 6 216 165 250 25 174
                       254 29 176 249 29 112 178 8 174 247 25 181 247 216 181
                       247 38 166 178 49 177 7 42 98 5 39 174 7 44 171 1 38 98
                       243 38 166 178 251 152 178 44 177 178 33 165 243 38 165
                       1 28 167 210 31 163 255 26 171 6 42 167 5 29 163 4 27
                       170 192 27 177 255 216 179 7 39 182 251 38 169 178 42 167
                       248 29 180 247 38 165 247 242 98 248 30 120 243 234 117
                       202 239 121 248 230))

(defparameter *guess*
  '((178 . "e") (38 . "a") (177 . "t") (247 . "n") (98 . "I") (167 . "o") (29 . "s")
    (165 . "r") (255 . "h") (171 . "d") (248 . "l") (6 . "u") (163 . "c") (7 . "m")
    (216 . "f") (243 . "y") (42 . "w") (174 . "g") (39 . "p") (25 . "b") (1 . "v")
    (254 . "k") (0 . "I") (27 . "q") (251 . "j") (44 . "z") (5 . "*") (166 . "*")
    (181 . "*") (26 . "*") (31 . "*") (180 . "*") (43 . "*") (33 . "*") (182 . "*")
    (4 . "*") (169 . "*") (36 . "*") (230 . "*") (121 . "*") (239 . "*") (202 . "*")
    (117 . "*") (234 . "*") (120 . "*") (30 . "*") (242 . "*") (179 . "*") (192 . "*")
    (170 . "*") (210 . "*") (28 . "*") (152 . "*") (49 . "*") (8 . "*") (112 . "*")
    (249 . "*") (176 . "*") (250 . "*") (32 . "*") (46 . "*") (133 . "*") (190 . "*")))

(defun check-guess ()
  (let ((ht (make-hash-table :test 'equalp)))
    (loop for k in *guess* do
                  (setf (gethash (cdr k) ht) (1+ (gethash (cdr k) ht 0))))
    (maphash (lambda (k v) (when (> v 1) (format t "~&~a is used ~a times~%" k v))) ht)
    ht))

(defun freq ()
  (let ((ht (make-hash-table))
        (codes)
        (codes2)
        (uniq))
    ;; get character frequency
    (loop for c in *code* do
         (setf (gethash c ht) (1+ (gethash c ht 0))))
    ;; convert hash to list
    (maphash (lambda (k v) (push (cons k v) codes)) ht)
    ;; print frequency table
    (format t
            "sorted by freq ~A~%"
            (sort codes (lambda ( x y) (> (cdr x) (cdr y)))))
    ;; prepare guess table
    ;; convert hash to list
    (maphash (lambda (k v) (push (cons k v) codes2)) ht)
    (format nil
            "guess me ~A~%"
            (loop for c in (sort codes2 (lambda ( x y) (> (cdr x) (cdr y))))
               collect (cons (car c) "*"))
            )
    ;; unique codes
    (setf uniq (loop for key being the hash-keys of ht collect key))

    ))


(defun guess ()
  (let ((guess-ht (make-hash-table)))
    ;; set hash for guessing
    (loop for g in *guess* do (setf (gethash (car g) guess-ht) (cdr g)))
    ;; print guesses
    (print (loop for c in *code* collect (if (equalp "*" (gethash c guess-ht))
                                             c
                                             (gethash c guess-ht))))
    guess-ht))
