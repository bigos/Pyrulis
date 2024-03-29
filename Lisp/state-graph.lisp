;;; Draw a state transition diagram.

;; (load (compile-file "~/Programming/Pyrulis/Lisp/state-graph.lisp"))

(defun draw-states (g)
  (labels ((gv-print (l)
             (if (null (nth 1 l))
                 (format nil "~&  ~s;~%" (nth 0 l))
                 (format nil "~&  ~s -> ~s [label=~s];~%" (nth 0 l) (nth 1 l) (nth 2 l))))
           (digraph (g)
             (format nil "digraph m {~%~A~&}~%"
                     (reduce (lambda (a b) (concatenate 'string a b) )
                             (loop for l in g
                                   collect (gv-print l))
                             :initial-value "")))
           (convert-state-list (state-list)
                               (apply #'append
                                      (loop for state-actions in state-list
                                            collect
                                            (loop for action in (rest  state-actions)
                                                  collect (cons (first state-actions)
                                                                action))))))

    ;; filename, extension and options
    (let* ((filename "the-graph")
           (extension "png")   ; edit extension to change image format
           (gv-file (format nil "/tmp/~A.gv" filename)))

      ;; create gv file
      (with-open-file (stream gv-file :direction :output :if-exists :supersede)
                      (write-sequence (digraph (convert-state-list g)) stream))

      (let ((options (list
                      (format nil "-T~A" extension)
                      gv-file
                      "-o"
                      (format nil "/tmp/~A.~A" filename extension))))
        ;; (format t "dot options ~A~%" options)

        ;; draw graphical output
        (let ((outcome (sb-ext:run-program "/usr/bin/dot" options)))
          ;; report outcome of drawing
          (format nil "~&~A"
                  (if (eq 1 (sb-impl::process-exit-code outcome))
                      "We had a problem, possibly invalid dot file generated"
                      "All went OK")))))))

;;; ============================================================================

(defun tryme ()
  (draw-states '(
                 ;; ("FSM states" (opened) (closed) (locked))
                 (opened
                  (closed "Close door"))
                 (closed
                  (opened "Open door") (locked "Lock door"))
                 (locked
                  (closed "Unlock door")))))
