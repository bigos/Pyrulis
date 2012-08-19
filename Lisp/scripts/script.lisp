#!/usr/bin/sbcl --script

(defun plural-form (singular)
  (let ((guessed-plural (concatenate 'string singular "s")) (entered-plural))
    (format t "if ~S is correct plural press Enter, ~%otherwise enter correct version~%" guessed-plural)
    (setq entered-plural (read-line))
    (if (string= "" entered-plural) 
	guessed-plural
	entered-plural)))

(defun underscorize (str)
  (let ((myword (with-output-to-string (r)
		  (loop for c across str
		     do	 
		       (if (upper-case-p c)
			   (format r "_~C" (char-downcase c))
			   (format r "~C" c))))))
    (string-left-trim "_" myword)))



(list '(index  (plu_under) all)
      '(show () find (params id))
      '(new () new)
      '(edit () find (params ))
      '(create ()  new (params sing-under)
	(if sing-under save))
      '(update () find (params id)
	(if sing-under update_attrinutes (params sing-under)))
      '(destroy () find (params id)
	(sing-under destroy)))

(defun generate (sing_camel sing_under plu_camel plu_under)  
  (let* ((methods `(("index" "all" )
		   ("show" "find" "id")
		   ("new" "new")
		   ("edit" "find" "id")
		   ("create" "new" ,sing_under ,(format nil "if @~A.save" sing_under))
		   ("update" "find" "id"
			     ,(format nil "if @~A.update_attributes(params[:~A])" sing_under sing_under))
		   ("destroy" "find" "id")))	
	(obj)	
	(result (with-output-to-string (r) 
		  (format r "class ~AController < ApplicationController~%  respond_to :html, :json, :xml" plu_camel)
		  (dolist (e methods)      
		    (format r "~2&~2Tdef ~A~%" (first e))
		    (setq obj (if (string= "index" (first e)) plu_under sing_under))

		    (format r "~4T@~A = ~A.~A" obj sing_camel (second e)) 
		    (if (third e) (format r "(params[:~A])~%" (third e)))
		    (if (fourth e) (format r "~4T~A~%~6T#~%~4Telse~%~6T#~%~4Tend" (fourth e)))
		    (if (string= "destroy" (first e)) (format r "~4T@~A.destroy" obj))
		    (format r "~1&~4Trespond_with(@~A)" obj)
		    (format r "~%~2Tend"))
		  (format r "~%end~%"))))
    (format t "~A~%" result)))

(defun application (singular)
  (let ((plural (plural-form singular)))
    (generate
     singular
     (underscorize singular)
     plural     
     (underscorize plural))))

(defun main (args)
  (let* ((options (cdr args))
	 (singular-form (car options)))
    (if (or (string= (car options) "--help") (eq options NIL))
	(format t "Enter singular form as an argument, eg.  $ script.lisp Post~%")
	(application singular-form))))

;;;;;;;;;;;;;;;;;;;;;;;;;;
(main sb-ext:*posix-argv*)
