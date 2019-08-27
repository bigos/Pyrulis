;;; sbcl --load THIS-FILE

(ql:quickload :quickproject)

(defun prompt-input (prompt)
  (format t "~A " prompt)
  (read-line))

(defun main ()
  (let* ((new-project-name (prompt-input "Enter project name" )))
    (format t "Creating project ~A~%" new-project-name)

    (setf quickproject:*author* "Jacek Podkanski")
    (setf quickproject:*license* "Public Domain")
    (setf quickproject:*include-copyright* nil)

    (quickproject:make-project  (merge-pathnames #p "~/Programming/Lisp/"
                                                 new-project-name)
                                :depends-on '(:cl-cffi-gtk :alexandria))))

(main)
