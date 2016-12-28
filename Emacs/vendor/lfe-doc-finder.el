;;; lfe-doc-finder --- Code for finding LFE documentation

;;; Commentary:

;;; This is supposed to make easier to look up documentation

;;; Usage:

;;; M-x lfedoc

;;; Code:

(defun lfedoc ()
  "Find LFE documentation."
  (interactive)
  (princ "going to look for LFE documentation")
  (terpri)
  ;; paredit-backward-up goes to the left of the opening bracket
  ;; paredit-forward-up goes to the right of the closing bracket
  (let ((original-buffer (current-buffer))
        (original-marker (point-marker))
        (opening-bracket)
        (closing-bracket)
        (bracketed))
    (princ "original marker ")
    (princ original-marker)
    (princ " - ")
    (princ (current-buffer))
    (terpri)
    (princ "zzzz")
    (paredit-backward-up)
    (setq opening-bracket (point-marker))
    (forward-char)
    (paredit-forward-up)
    ;(backward-char)
    (setq closing-bracket (point-marker))
    (terpri)
    (princ (cons opening-bracket closing-bracket))
    (terpri)
    (setq bracketed
          (buffer-substring (marker-position opening-bracket)  (marker-position closing-bracket)))

    (princ bracketed)
    (goto-char (marker-position original-marker))
    )
  )

(provide 'lfe-doc-finder)
;;; lfe-doc-finder.el ends here
