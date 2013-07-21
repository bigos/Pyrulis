(feature "try to log in"
	 '("in order to see if it can be done"
	   "as a lisp developer"
	   "i want to log in")
	 (scenario "visiting login page"
		   '((given i-have-test-user-in-the-database)
		     (and i-visit-login-page)		   
		     (and i-enter-correct-login-details)
		     (when i-click-login-button)
		     (then the-page-should-contain-login-ip))))

;;steps
(defun i-visit-login-page ()
  (visit "/login"))

(defun i-have-test-user-in-the-database ()
  (do-something))

(defun i-enter-correct-login-details ()
  (do-something))

(defun i-click-login-button ()
  (do-something))

(defun the-page-should-contain-login-ip ()
  (do-something))
