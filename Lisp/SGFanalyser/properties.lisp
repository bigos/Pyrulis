;;;#! /usr/bin/sbcl --script

(defun opening-bracket (buffer pos)
  (position #\[ buffer :start pos))

(defun closing-bracket (buffer pos)
  (let ((last-ltr) (ltr))    
    (loop while (< pos  (length buffer)) do
	 (setf ltr (char buffer pos))	 
	 (if (and (eq #\] ltr) (not (eq #\\ last-ltr)))
	     (return pos))
	 (setf last-ltr (char buffer  pos))
	 (incf pos))))

(defun last-closing-bracket (buffer pos)
  (let ((clb))    
    (loop while (< pos  (length buffer)) do
	 (setf clb (closing-bracket buffer pos))
	 (unless (eq #\[ (char buffer (1+ clb)))	   
	   (return clb))
	 (setf pos (1+ clb)))))

(defun find-key-position  (buffer pos)
  (let ((key) (res ))		 
    (dolist (el (keys-list))
      (setf key (search el buffer :start2 pos :end2 (opening-bracket buffer pos)))   
      (if key (progn (setf res key))))
    res))

(defun get-key-value-position (buffer pos) 
  (let* ((key-pos) (opb) (clb) (key) (val))
    (setf key-pos (find-key-position buffer pos)) 
    (setf opb (opening-bracket buffer pos))  
    (setf key (subseq buffer key-pos opb)) 
    (setf clb (last-closing-bracket buffer pos))
    (setf val (subseq buffer opb (1+ clb)))
    (list  (1+ clb) key val )
    ))

(defun val-to-list (val)
  (let ((pos 0) (opb) (clb) (res) (x))
    (loop while (< pos (length val)) do
	 (setf opb (opening-bracket val pos))
	 (setf clb (closing-bracket val pos))
	 (setf pos (1+ clb))
	 ;(format t "~%AAA ~a  ~a  ~a        ~a~%" pos opb clb val)
	 (setf x (subseq val (1+ opb) clb))
	 ;(format t " |~a|    " x)
	 (setf res (append  res (list x) ))
	 )
    res
    ))

(defun main ()
  (let ((buffer "W[]WL[1314.814]TW[ga][ha][ia][ja][ka][la][ma] ") (pos 0) (res) (key) (val))
    (dotimes (x 3) 
      (setf res (get-key-value-position buffer pos))
      (setf pos (car res))
      (setf key (cadr res))
      (setf val (caddr res))
      (format t "~a | k:~a v:~a ~%" res key val)
      (format t "~s~%" (val-to-list val))
      )))

(main)
