;;; sbcl --load THIS-FILE

(ql:quickload :quickproject)

(defun prompt-input (prompt)
  (format t "~A " prompt)
  (read-line))

(defun main ()
  (let* ((npn (prompt-input "Enter project name" )))
    (format t "Creating project ~A~%" npn)

    (setf quickproject:*author* "Jacek Podkanski")
    (setf quickproject:*license* "Public Domain")
    (setf quickproject:*include-copyright* nil)

    (quickproject:make-project  (merge-pathnames #p "~/Programming/Lisp/" npn)
                                :depends-on '(:cl-cffi-gtk :alexandria))))
