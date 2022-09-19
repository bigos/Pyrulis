(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria serapeum defclass-std)))

(in-package "COMMON-LISP-USER")

(defun pht (obj &key (test 'eql) (size 7))
  (alexandria:plist-hash-table obj :test test :size size))

(defun valpath (root path)
  (if (endp path)
      root
      (valpath (gethash (first path) root) (rest path))))

(defun hashpath (root path)
  (if (null (cdr path))
      root
      (hashpath (gethash (first path) root) (rest path))))

(defun set-hashpath (root path new-value)
  (if (null (cdr path))
      (setf (gethash (car path) root) new-value)
      (set-hashpath (gethash (first path) root) (rest path) new-value)))

(defun try-me ()
  (let ((dat (pht
              (list
               :windows (pht (list
                              :win1 'win1
                              :win2 'win2))))))
    (hashpath dat '(:windows :win1))
    (set-hashpath dat '(:windows :win1) "win 11111")


    (valpath dat '(:windows :win1))
    ))
