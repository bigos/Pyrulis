(in-package #:graph-toy)

(defun com-help ()
  (loop for (k fn hs) in keys-shortcuts-list do
        (format t "~A ~A ~A~%" k fn hs)))

(defun com-quit ()
  (format t "quitting now...~%~%")
  'quit-main-loop)

(defun com-redraw ()
  (format t "~A~%" (digraph *graph*))
  (draw *graph*))

(defun com-add ()
  (push (make-instance 'link :source (prompt "name of new node") :target nil)
        (links *graph*))
  (draw *graph*))

(defun com-link ()
  ;; (format t "~A~%" (digraph *graph*))
  (push (make-instance 'link :source (prompt "name of source node")
                             :action (prompt "link action")
                             :target (prompt "name of target node"))
        (links *graph*))
  (draw *graph*))

(defun com-link2 ()
  ;; (format t "~A~%" (digraph *graph*))
  (let ((lds (uiop:split-string (prompt "space separated source action target"))))
    (if (eq 3 (length lds))
        (push (make-instance 'link :source (elt lds 0)
                                   :action (elt lds 1)
                                   :target (elt lds 2))
              (links *graph*))
        (error "~A does not appear to have 3 elements" lds)))
  (draw *graph*))

(defun com-kill ()
  (let* ((node (prompt "enter the name of source node"))
         (links (loop for l in (links *graph*)
                      when (equalp node (source l))
                        collect l)))
    (when links
      (format t "we can remove following links:~%")
      (loop for l in links
            for n = 0 then (1+ n)
            do (format t "~a ~A~%" n (when l (probe l))))

      (let* ((deleted-number (parse-integer (prompt "Please enter the NUMBER of the link to kill")))
             (deleted-part (elt links deleted-number)))

        (format t "we are going to delete ~A~%" (when deleted-part (probe deleted-part)))
        (delete-link *graph* deleted-part))))
  (draw *graph*))

(defun com-name ()
  (format t "~A~%" (probe *graph*))
  (rename-node *graph* (prompt "name of the renamed node"))
  (draw *graph*))

(defun com-delete ()
  (format t "~A~%" (probe *graph*))
  (remove-node *graph* (prompt "name of the deleted node"))
  (draw *graph*))

(defun com-list ()
  (format t "~A~%" (links-to-list *graph*)))
