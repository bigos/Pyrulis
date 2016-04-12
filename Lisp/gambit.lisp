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

(defparameter *guess-numbers*
  '(178 38 177 247 98 167 29 165 255 171 248 6 163 7 216 243 42 174 39 25 1 254
    0 27 251 44 5 166 181 26 31 180 43 33 182 4 169 36 230 121 239 202 117 234
    120 30 242 179 192 170 210 28 152 49 8 112 249 176 250 32 46 133 190))

;;; are they using a polyalphabetic cipher?
(defparameter *guess-letters*
  '( "E" "t" "e" "T" "a" "o" "i" "s" "n" "r" "h" "l" "d" "c" "m" "u" "g" "f" "p" "w" "y"
    "b" "v" "k" "*" "q" "j" "z" "*" "*" "*" "*" "*" "*" "*" "*" "*" "*" "*" "*"
    "*" "*" "*" "*" "*" "*" "*" "*" "*" "*" "*" "*" "*" "*" "*" "*" "*" "*" "*"
    "*" "*" "*" "*" ))

(defun check-guess ()
  (let ((ht (make-hash-table :test 'equal))
        (ht2 (make-hash-table :test 'equal)))
    (loop for k in *guess* do
         (setf (gethash (cdr k) ht) (1+ (gethash (cdr k) ht 0))))
    (loop for k in *guess-letters* do
         (setf (gethash k ht2) (1+ (gethash k ht2 0))))
    (maphash (lambda (k v) (when (> v 1) (format t "~&~a is used ~a times~%" k v))) ht)
    (maphash (lambda (k v) (when (> v 1) (format t "~&~a IS USED ~A TIMES~%" k v))) ht2)
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
    (format T
            "guess me ~A~%"
            (loop for c in (sort codes2 (lambda ( x y) (> (cdr x) (cdr y))))
               collect (car c) )
            )
    ;; unique codes
    (setf uniq (loop for key being the hash-keys of ht collect key))))


(defun guess ()
  (let ((guess-ht (make-hash-table)))
    ;; set hash for guessing
    (loop for gn in *guess-numbers*
       for i = 0 then (1+ i)
       for g = (elt *guess-letters* i)
       do (setf (gethash gn guess-ht) g))
    (loop for x in *code* do (format t "~a" (gethash x guess-ht)))
    ;;guess-ht
    ))
