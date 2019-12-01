(declaim (optimize (speed 0) (safety 3) (debug 3)))

(defun identical (&rest args)
  args)

(defun rewrite (test source rewriter &optional (ignorer 'identical))
  (apply (if test rewriter ignorer)
           source))
