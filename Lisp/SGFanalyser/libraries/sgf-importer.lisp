(in-package :sgf-importer)

(defun sgf-keys-list ()
  (list "B" "W" "C" "N" "V"
        "KO" "MN" "AB" "AE" "AW" "PL" "DM" "GB" "GW" "HO" "UC" "BM"
        "DO" "IT" "TE" "AR" "CR" "DD" "LB" "LN" "MA" "SL" "SQ" "TR"
        "AP" "CA" "FF" "GM" "ST" "SZ" "AN" "BR" "BT" "CP" "DT" "EV"
        "GN" "GC" "ON" "OT" "PB" "PC" "PW" "RE" "RO" "RU" "SO" "TM"
        "US" "WR" "WT" "BL" "OB" "OW" "WL" "FG" "PM" "VW" "HA" "KM" "TW" "TB"))


(defun anything (char)
  T)


(defrule integer (+ (or "0" "1" "2" "3" "4" "5" "6" "7" "8" "9"))
  (:lambda (list)
    (parse-integer (text list) :radix 10)))

;;;-----------------------------------------------------------------------------
(defrule s (+ game-tree))
(defrule game-tree (and (* new-line) "(" (+ node) (* game-tree) ")" (* new-line)))
(defrule node (and ";" (* data) (* new-line)))
(defrule data (or (and "(" key (+ val) ")") move comment))
(defrule comment (and "C" val-start text val-end))
(defrule move (and (or "B" "W") val-start coordinates val-end))
(defrule key (and uc-letter (? uc-letter)))
(defrule val (and val-start c-value-type val-end (* new-line)))
(defrule val-start "[")
(defrule val-end "]")
(defrule c-value-type (or value-type compose))
(defrule value-type (or none text range))
(defrule uc-letter (or "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M"
                       "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))
(defrule compose (and value-type ":" value-type))
(defrule none "")
(defrule space #\space)
(defrule new-line (or #\return (and #\linefeed (? #\return))))
(defrule escaped-newline (and #\\ new-line))
(defrule number (and (? (or "-" "+")) (+ integer)))
(defrule text (+ (or new-line (anything character))))
(defrule coordinate (or "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n"
                        "o" "p" "q" "r" "s") )
(defrule coordinates (and coordinate coordinate))
(defrule range (and coordinates ":" coordinates))
;;;-----------------------------------------------------------------------------

(defun get-move-list (filename)
  (let ((buffer (alexandria:read-file-into-string filename)))
    buffer))
