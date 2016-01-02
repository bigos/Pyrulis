;;; key-bindings-lister.el --- Key Bindings Lister

;;; Commentary:
;; My attempt to have up to date key bindings no matter what modes are used

;;; Code:

;;; notes

;; I can get key bindings for sinple shortcut like C-s this way:

;; find the code for C-s

;; ELISP> ?\C-s
;; 19 (#o23, #x13, ?\C-s)

;; which is 19

;; ELISP> (key-binding [19])
;; isearch-forward

;; now C-x s

;; ELISP> 24
;; 24 (#o30, #x18, ?\C-x)

;; ELISP> ?s
;; 115 (#o163, #x73, ?s)

;; ELISP> (key-binding [24 115])
;; save-some-buffers

;; now M-g
;; ?\M-g

;; BOOOO got inactive key bibdings as well

;; perhaps (current-active-maps) is the way to go
;; (elt (current-active-maps) 11)

(defun print-current-buffer-info ()
  (interactive)
  (let ((the-buffer (current-buffer))
        (my-bindings ""))
    (print the-buffer)
    (describe-bindings nil the-buffer)
    (setq my-bindings (get-content-of-buffer "*Help*"))
    (set-buffer "*Messages*")
    (print "+++++++++++++++++++++++++++++")
    (dolist (x (split-string my-bindings "\n"))
      (print "=====================")
      (print x))
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
