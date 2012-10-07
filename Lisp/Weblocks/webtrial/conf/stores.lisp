
(in-package :webtrial)

;;; Multiple stores may be defined. The last defined store will be the
;;; default.
(defstore *webtrial-store* :prevalence
  (merge-pathnames (make-pathname :directory '(:relative "data"))
		   (asdf-system-directory :webtrial)))

