
(in-package :webtrial)

;; Define callback function to initialize new sessions
(defun init-user-session (root)
  (setf (widget-children root)
	(list (lambda (&rest args)
		(with-html
		  (:p "It says"
		      (:strong " Hello World ")
		      "and Happy Hacking!"
		      (:ul 
		       (:li "1") 
		       (:li "dwa") 
		       (:li "three"))
		      "end of the list"
		      )
		  )
		))))

