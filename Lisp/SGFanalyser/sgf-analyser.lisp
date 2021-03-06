(in-package :sgf-analyser)

(defvar *board-column-letters* "abcdefghjklmnopqrst")
(defvar *sgf-letters* "abcdefghijklmnopqrs")
(defparameter *board-size* 19)

(defun game-stats ()
  (let ((stats `(("white" . "PW") ("white rank" . "WR") ("black" . "PB")
                 ("black rank" . "BR") ("~%board size" . "SZ") ("rules" . "RU")
                 ("result" . "RE") ("komi" . "KM") ("~%handicap" . "HA")
                 ,(cond  ((not (zerop (length (header-value "AB")))) '("black handicap list" . "AB"))
                         ((not (zerop (length (header-value "AW")))) '("white handicap list" . "AW"))))))
    (dolist (el stats)
      ;; ~? explanation: http://www.lispworks.com/documentation/HyperSpec/Body/22_cgf.htm
      (format t "~@?: ~S   " (car  el) (header-value (cdr el))))))

(defun sgf-to-i (coordinates)
  (labels ((coord (i)
             (position (char coordinates i)
                       *sgf-letters*)))
    (cons (coord 0)
          (coord 1))))

(defun board-edge-p (coordinate)
  (or (eq coordinate 0)
      (eq coordinate (1- *board-size*))))

(defun valid-coordinate-p (coordinate)
  (and (>= coordinate 0)
       (<= coordinate (1- *board-size*))))

;;;----------------------------------------------------------------
(defclass goban ()
  ((size :reader size :initarg :size)
   (board :accessor board :initarg :board)))

(defgeneric add-handicaps (goban))
(defgeneric print-board (goban))
(defgeneric stone-at (goban coordinates))
(defgeneric place-stone (goban colour coordinates))
(defgeneric neighbours (goban coordinates))
(defgeneric each-neighbour (goban coordinates func))

(defmethod stone-at ((self goban) coordinates)
  (if (and (valid-coordinate-p (car coordinates))
           (valid-coordinate-p (cdr coordinates)))
      (aref (board self) (car coordinates) (cdr coordinates))
      :outside))

(defmethod add-handicaps ((self goban))
  (dolist (handis `(("B" ,(header-value "AB"))
                    ("W" ,(header-value "AW"))))
    (dolist (pos (cadr handis))
      (format t "#### going to place ~A at ~A ~A~%" (car handis) pos (sgf-to-i pos))
      (place-stone self (car handis)
                   (sgf-to-i pos)))))

(defmethod print-board ((self goban))
  (format t "in print-board")
  (let ((size (car (array-dimensions (board self))))
        (stone))
    (format t "~%    ")
    (dotimes (c (length *board-column-letters*))
      (format t "~a " (char *board-column-letters* c )))
    (dotimes (r size)
      (format T "~&~2d  " (- size r ))
      (dotimes (c size)
        (setf stone (aref (board self)
                          c r))
        (format t "~2a" (if stone stone "."))))
    (format t
            "~%~%")))

(defmethod place-stone ((self goban) colour coordinates)
  (setf (aref (slot-value self 'board) (car coordinates) (cdr coordinates)) colour))

(defmethod neighbours ((self goban) coordinates)
  (format t "~&will try to find neighbours for ~s     edges ~s:~s   ~%"
          coordinates (board-edge-p (car coordinates)) (board-edge-p (cdr coordinates)))
  (let ((lives) (whites) (blacks))
    (dolist (neighbour '((0 . -1)
                         (1 . 0)
                         (0 . 1)
                         (-1 . 0)))
      (format t "~s ~s~%" neighbour (stone-at self (cons (+ (car neighbour)
                                                            (car coordinates))
                                                         (+ (cdr neighbour)
                                                            (cdr coordinates))))))))

(defmethod each-neighbour ((self goban) coordinates func)
  (let ((neighbour-coord-offsets '((0 . -1) (1 . 0) (0 . 1) (-1 . 0)))
        (coord)
        (result))
    (format t "~&~S <<<<~%"
            (mapcar
             #'(lambda (offset)
                 (progn
                   (setf coord (cons (+ (car offset) (car coordinates))
                                     (+ (cdr offset) (cdr coordinates))))
                   (setf result (stone-at *goban* coord))
                   (if (eq result :outside)
                       (list result)
                       (list coord result))))
             neighbour-coord-offsets ))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun run ()
  (let ((a 1))


    (setf *goban* (make-instance 'goban
                                 :size *board-size*
                                 :board (make-array `(,*board-size* ,*board-size*)
                                                    :initial-element nil)))
    (add-handicaps *goban*)

    (print-board *goban*)
    (setq coordinates (enter-coordinates))
    (format t "the coordinates are: ~A~%"  coordinates)
    (format t "stone at given coordinates >~A<"  (stone-at *goban* coordinates))
    (each-neighbour *goban* coordinates 'stone-at)
                                        ;(format t ">>>>>>>> ~S" *goban*)

    ))

;;;==================================================
(format t "~&Type (sgf-analyser:run) to start the program")
