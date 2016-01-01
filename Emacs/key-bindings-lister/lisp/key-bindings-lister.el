;;; key-bindings-lister.el --- Key Bindings Lister

;;; Commentary:
;; My attempt to have up to date key bindings no matter what modes are used

;;; Code:

(defun print-current-buffer-info ()
  (interactive)
  (let ((the-buffer (current-buffer)))
    (print the-buffer)))

(provide 'key-bindings-lister)

;;; key-bindings-lister.el ends here
