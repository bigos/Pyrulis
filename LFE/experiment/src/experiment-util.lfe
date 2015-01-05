(defmodule experiment-util
  (export all))

(defun get-experiment-version ()
  (lutil:get-app-src-version "src/experiment.app.src"))

(defun get-versions ()
  (++ (lutil:get-version)
      `(#(experiment ,(get-experiment-version)))))
