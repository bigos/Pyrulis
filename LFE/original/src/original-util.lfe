(defmodule original-util
  (export all))

(defun get-original-version ()
  (lutil:get-app-src-version "src/original.app.src"))

(defun get-versions ()
  (++ (lutil:get-version)
      `(#(original ,(get-original-version)))))
