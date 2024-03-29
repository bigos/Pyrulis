;; sbcl --load ~/Programming/Pyrulis/Lisp/aliengtk.lisp


;; (load (compile-file "~/Programming/Pyrulis/Lisp/aliengtk.lisp"))

;; (cl:defpackage "TEST-C-CALL" (:use "CL" "SB-ALIEN" "SB-C-CALL"))
;; (cl:in-package "TEST-C-CALL")

(load-shared-object
 "/usr/lib/x86_64-linux-gnu/libgtk-3.so.0.2404.29")

;; This will exclude :divide-by-zero which might be caused in the GTK lib.
;; The default traps are (:OVERFLOW :INVALID :DIVIDE-BY-ZERO).
;; See: (sb-int:get-floating-point-modes)
(sb-int:set-floating-point-modes :traps '(:overflow :invalid))

(define-alien-routine gtk_application_window_new (* t) (app (* t)))

(define-alien-routine gtk_application_new (* t) (txt c-string) (flags int))

(define-alien-routine g_application_run int
  (app (* t)) (argc int) (argv (* t)))

(define-alien-routine g_signal_connect_data long
  (instance (* t)) (sig c-string)
  (cback (function void (* t) (* t)))
  (data (* t)) (unusedptr (* t)) (unusedint int))

(define-alien-routine gtk_window_set_title void (win (* t)) (ttl (c-string)))

(define-alien-routine gtk_window_set_default_size void
  (win (* t)) (x int) (y int))

(define-alien-routine g_object_unref void
  (win (* t)))

(define-alien-routine gtk_widget_show_all void (win (* t)))

(define-alien-callable mycallback void ((app (* t)) (u (* t)))
                                 (with-alien ((win (* t)))
                                   (setf win (gtk_application_window_new app))
                                   (gtk_window_set_title win "That")
                                   (gtk_window_set_default_size win 400 300)
                                   (gtk_widget_show_all win)))

(with-alien ((app (* t)) (status int))
  (setf app (gtk_application_new "org.gtk.example" 0))
  (g_signal_connect_data app "activate" mycallback  nil nil 0)
  (g_application_run app 0 nil)
  (g_object_unref app))

(format t "finished~%")
