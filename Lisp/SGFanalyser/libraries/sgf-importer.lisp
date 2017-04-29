(in-package :sgf-importer)

;; parsing documentation
;; https://nikodemus.github.io/esrap/

(defrule integer (+ (or "0" "1" "2" "3" "4" "5" "6" "7" "8" "9"))
  (:lambda (list)
    (parse-integer (text list) :radix 10)))

;;;-----------------------------------------------------------------------------
(defrule s (+ game-tree))
(defrule game-tree (and (* new-line) "(" (+ node) (* game-tree) ")" (* new-line)))
(defrule node (and ";" (* (or move (and  key val ) comment)) (* new-line)))

(defrule comment (and "C" val-start text val-end))
(defrule move (and (or "B" "W") val-start coordinates val-end))
(defrule key (and uc-letter (? uc-letter)) (:text T))
(defrule val (and val-start c-value-type val-end (* new-line)))
(defrule val-start "[")
(defrule val-end "]")
(defrule c-value-type (or value-type compose))
(defrule value-type (or text range none))
(defrule uc-letter (or "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M"
                       "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))
(defrule compose (and value-type ":" value-type))
(defrule none "")
(defrule space #\space)
(defrule new-line (or #\return (and #\linefeed (? #\return))))
(defrule escaped-newline (and #\\ new-line))
(defrule number (and (? (or "-" "+")) (+ integer)))

(defrule text (+  (not (or "[" "]"))) (:text T))

(defrule coordinate (or "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n"
                        "o" "p" "q" "r" "s"))
(defrule coordinates (and coordinate coordinate))
(defrule range (and coordinates ":" coordinates))
;;;-----------------------------------------------------------------------------

(defun get-move-list (filename)
  (let ((buffer (alexandria:read-file-into-string filename
                                                  :external-format :latin-1)))
    buffer))

(defun import-sgf (&optional (filename "~/Documents/Go/Pro_collection/Cao Dayuan/cao_001.sgf"))
  (let* ((nodes
          (destructuring-bind ((ign1 ign2 nodes ign3 ign4 ign5 ))
              (parse 's (get-move-list filename))
            nodes))
         (first-node
          (destructuring-bind ((colon node &rest ign1) &rest ign2)
              nodes
            node))
         (game-stats (loop for en in first-node
                        collect (cons (car en)
                                      (destructuring-bind ((ob v cb &rest ign1))
                                          (cdr en)
                                        v)))))
    game-stats))
