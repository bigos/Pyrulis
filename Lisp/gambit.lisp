;;; rc4 cipher
;; https://www.cs.purdue.edu/homes/ninghui/courses/Fall05/lectures/355_Fall05_lect13.pdf

;; https://github.com/first20hours/google-10000-english/blob/master/20k.txt
(defparameter *frequent-words*
  '("the" "of" "and" "to" "a" "in" "for" "is" "on" "that" "by" "this" "with" "i"
         "you" "it" "not" "or" "be" "are" "from" "at" "as" "your" "all" "have" "new"
         "more" "an" "was" "we" "will" "home" "can" "us" "about" "if" "page" "my" "has"
         "search" "free" "but" "our" "one" "other" "do" "no" "information" "time"
         "they" "site" "he" "up" "may" "what" "which" "their" "news" "out" "use" "any"
         "there" "see" "only" "so" "his" "when" "contact" "here" "business" "who" "web"
         "also" "now" "help" "get" "pm" "view" "online" "c" "e" "first" "am" "been"
         "would" "how" "were" "me" "s" "services" "some" "these" "click" "its" "like"
         "service" "x" "than" "find" "price" "date" "back" "top" "people" "had" "list"
         "name" "just" "over" "state" "year" "day" "into" "email" "two" "health" "n"
         "world" "re" "next" "used" "go" "b" "work" "last" "most" "products" "music"
         "buy" "data" "make" "them" "should" "product" "system" "post" "her" "city" "t"
         "add" "policy" "number" "such" "please" "available" "copyright" "support"
         "message" "after" "best" "software" "then" "jan" "good" "video" "well" "d"
         "where" "info" "rights" "public" "books" "high" "school" "through" "m" "each"
         "links" "she" "review" "years" "order" "very" "privacy" "book" "items"
         "company" "r" "read" "group" "sex" "need" "many" "user" "said" "de" "does"
         "set" "under" "general" "research" "university" "january" "mail" "full" "map"
         "reviews" "program" "life" "know" "games" "way" "days" "management" "p" "part"
         "could" "great" "united" "hotel" "real" "f" "item" "international" "center"
         "ebay" "must" "store" "travel" "comments" "made" "development" "report" "off"
         "member" "details" "line" "terms" "before" "hotels" "did" "send" "right"
         "type" "because" "local" "those" "using" "results" "office" "education"
         "national" "car" "design" "take" "posted" "internet" "address" "community"
         "within" "states" "area" "want" "phone" "zzzz"))

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

(defparameter *code2*
  '(136 92 141 172 102 77 96 58 144 174 94 147 161 107 150 172 88 149 169 102
    143 179 23 135 175 105 65 179 102 141 182 96 143 167 23 149 168 92 65 135
    88 142 162 96 149 96 90 137 161 99 141 165 101 136 165 37 65 144 99 134 161
    106 134 96 106 134 174 91 65 185 102 150 178 23 148 175 99 150 180 96 144
    174 23 130 174 91 65 131 77 65 180 102 65 169 90 130 174 90 144 164 92 97
    167 88 142 162 96 149 178 92 148 165 88 147 163 95 79 163 102 142 96 104 150
    175 107 138 174 94 65 178 92 135 165 105 134 174 90 134 122 23 82 164 41 88
    114 41 134 117 47 85 110))

(defparameter *guess-numbers*
  '(178 38 177 247 98 167 29 165 255 171 248 6 163 7 216 243 42 174 39 25 1 254
    0 27 251 44 5 166 181 26 31 180 43 33 182 4 169 36 230 121 239 202 117 234
    120 30 242 179 192 170 210 28 152 49 8 112 249 176 250 32 46 133 190))

;;; are they using a polyalphabetic cipher?
(defparameter *guess-letters*
  '(  ))

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

(defun freq (var)
  (let ((ht (make-hash-table))
        (codes))
    ;; get character frequency
    (loop for c in var do
         (setf (gethash c ht) (1+ (gethash c ht 0))))
    ;; convert hash to list
    (maphash (lambda (k v) (push (cons k v) codes)) ht)
    ;; print frequency table
    (format t
            "sorted by freq ~A~%"
            (sort codes (lambda ( x y) (> (cdr x) (cdr y)))))
    ht))


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
