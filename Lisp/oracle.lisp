;;; oracle

;; to make it work we need my fork of dbd-oracle
;; https://github.com/bigos/dbd-oracle
;; git cloned in: ~/quicklisp/local-projects
;; and evaluate: (ql:register-local-projects)
;; also we need ld config like:
;;   $ cat /etc/ld.so.conf.d/oracle.conf
;;   # instaclient config
;;   /home/jacek/instantclient_19_8
;;; and execute: sudo ldconfig

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(:dbd-oracle)))

(defvar *connection*
  (dbi:connect :oracle
               :database-name "XE"
               :username "c##jacek"
               :password "secret"
               :encoding :utf-8))


(let* ((query (dbi:prepare *connection*
                           "SELECT * FROM comments"))
       (result (dbi:execute query '())))
  (loop for row = (dbi:fetch result)
        while row do
        (format t "~A~%" row)
        ))
