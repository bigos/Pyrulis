(declaim (optimize (speed 1) (safety 3) (debug 3)))

(defun identical (&rest args)
  args)

(defun rewrite (test source rewriter &optional (ignorer 'identical))
  (apply (if test rewriter ignorer)
           source))

;;; types on hyperspec
;; http://clhs.lisp.se/Body/d_type.htm
