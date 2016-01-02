;;; key-bindings-lister.el --- Key Bindings Lister

;;; Commentary:
;; My attempt to have up to date key bindings no matter what modes are used

;;; Code:

(defun print-current-buffer-info ()
  (interactive)
  (let ((the-buffer (current-buffer))
        (my-bindings ""))
    (print the-buffer)
    (describe-bindings nil the-buffer)
    (setq my-bindings (get-content-of-buffer "*Help*"))
    (set-buffer "*Messages*")
    (print "+++++++++++++++++++++++++++++")
    (princ my-bindings)
    (set-buffer the-buffer)
    ))

(defun get-content-of-buffer (buf)
  (let ((current (current-buffer))
        (content))
    (if buf
        (progn
          (set-buffer buf)
          (setq content (buffer-string))
          (set-buffer current)
          content))))

(provide 'key-bindings-lister)

;;; key-bindings-lister.el ends here
