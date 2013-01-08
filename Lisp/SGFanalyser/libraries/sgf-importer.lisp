
(in-package :sgf-importer)

(defun keys-list ()
  (list "B" "W" "C" "N" "V"
	"KO" "MN" "AB" "AE" "AW" "PL" "DM" "GB" "GW" "HO" "UC" "BM"
	"DO" "IT" "TE" "AR" "CR" "DD" "LB" "LN" "MA" "SL" "SQ" "TR"
	"AP" "CA" "FF" "GM" "ST" "SZ" "AN" "BR" "BT" "CP" "DT" "EV"
	"GN" "GC" "ON" "OT" "PB" "PC" "PW" "RE" "RO" "RU" "SO" "TM"
	"US" "WR" "WT" "BL" "OB" "OW" "WL" "FG" "PM" "VW" "HA" "KM" "TW" "TB"))

(defun opening-bracket (pos)
  (position #\[ *buffer* :start pos))

(defun closing-bracket (pos)
  (let ((last-ltr) (ltr))
    (loop while (< pos (length *buffer*)) do
	 (setf ltr (char *buffer* pos))	
	 (if (and (eq #\] ltr) (not (eq #\\ last-ltr)))
	     (return pos))
	 (setf last-ltr (char *buffer* pos))
	 (incf pos))))

(defun last-closing-bracket (pos)
  (let ((clb))
    (loop while (< pos (length *buffer*)) do
	 (setf clb (closing-bracket pos))
	 (unless (eq #\[ (char *buffer* (1+ clb)))	
	   (return clb))
	 (setf pos (1+ clb)))))

(defun split-string (string separator)
  (loop with l = (length separator)
     for n = 0 then (+ pos l)
     for pos = (search separator string :start2 n)
     if pos collect (subseq string n pos)
     else collect (subseq string n)
     while pos))

(defun find-key-position (pos)
  (let ((key) (res ))	
    (dolist (el (keys-list))
      (setf key (search el *buffer* :start2 pos :end2 (opening-bracket pos)))
      (if key (progn (setf res key))))
    res))

(defun get-key-value-position (pos)
  (let* ((key-pos) (opb) (clb) (key) (val) (new-move))
    (setf key-pos (find-key-position  pos))
    (if (eq (char *buffer* (1- key-pos)) #\;)
	(setf new-move t))
    (setf opb (opening-bracket pos))
    (setf clb (last-closing-bracket pos))
    (setf key (subseq *buffer* key-pos opb))
    (setf val (subseq *buffer* (1+ opb)  clb))
    (list (1+ clb) key val new-move )))

(defun read-file-to-string (filename)
  (let ((file-content))
    (with-open-file (stream filename)
      (setf file-content (make-string (file-length stream)))
      (read-sequence file-content stream ))
    file-content ))

(defun get-move-list (filename)
  (let ( (key-pos 0) (result) (val-list) (all-moves) (this-move))
    (defparameter *buffer* (read-file-to-string filename))
    (loop while (< key-pos (- (length *buffer*) 3)) do	
	   (if (last-closing-bracket key-pos)	
	       (setf result (get-key-value-position  key-pos)))
	   (if (car result)
	       (setf key-pos (car result)))
	   (setf val-list (split-string (nth 2 result) "]["   ))
	   (if (nth 3 result)
	       (progn	
		 (setf all-moves (append all-moves (list this-move)))
		 (setf this-move () )))
	   (setf this-move (append this-move (list (list (nth 1 result) val-list))))
	   )
    (setf all-moves (append all-moves (list this-move)))
    ;; skipping firs empty list element
    (cdr all-moves)))
