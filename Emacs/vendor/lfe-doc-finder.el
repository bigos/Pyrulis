;;; lfe-doc-finder --- Code for finding LFE documentation

;;; Commentary:

;;; This is supposed to make easier to look up documentation
;;; downside of this approach is reliance on paredit

;;; Usage:

;;; Load this file by adding it in the load-path and running:
;;; (load "lfe-doc-finder.el")


;;; M-x helpme
;;; Will hopefully take you to a relevant page in Erlang documentation.

;;; M-x lfedoc
;;; Will print to the mini buffer the sexp at the cursor.

;;; Code:

(require 'browse-url)

(defun lfedoc ()
  "Find LFE documentation."
  (interactive)
  (let ((sexp-str (sexp-at-point)))
    (princ sexp-str)))

(defun sexp-at-point ()
  "Find the s-exp string using paredit."
  ;; paredit-backward-up goes to the left of the opening bracket
  ;; paredit-forward-up goes to the right of the closing bracket
  (let ((original-buffer (current-buffer))
        (original-marker (point-marker))
        (opening-bracket)
        (closing-bracket))
    ;; find opening bracket
    (paredit-backward-up)
    (setq opening-bracket (point-marker))
    (forward-char)
    ;; find closing bracket
    (paredit-forward-up)
    (setq closing-bracket (point-marker))
    ;; return to the original position
    (goto-char (marker-position original-marker))
    ;; and finally return the string containing the s-exp
    (buffer-substring (marker-position opening-bracket) (marker-position closing-bracket))))

(defun helpme ()
  "Go to Erlang website for help."
  (interactive)
  (let ((my-sexp (read (sexp-at-point)))
        (help-url))
    (setq help-url
     (apply 'format
              (cons "http://erlang.org/doc/man/%s.html#%s-%d"
                    (cond ((new-erlang-callp my-sexp)
                           (new-erlang-call-args my-sexp))
                          ((old-erlang-callp my-sexp)
                           (old-erlang-call-args my-sexp))
                          (t (unknown-code my-sexp))))))
    (browse-url help-url)))

(defun new-erlang-callp (sl)
  "Check id the SL is the new Erlang call syntax."
  (eql (car sl) :))

(defun new-erlang-call-args (sl)
  "Get new Erlang call info for the documentation look-up list SL."
  (list (nth 1 sl) (nth 2 sl) (- (length sl) 3)))

(defun old-erlang-callp (sl)
  "Check id the SL is the old Erlang call syntax."
  (eql (length (split-string (symbol-name (car sl))
                             ":"))
       2))

(defun old-erlang-call-args (sl)
  "Get old Erlang call info for the documentation look-up list SL."
  (let ((call-str (split-string (symbol-name (car sl)) ":")))
    (list (nth 0 call-str)
          (nth 1 call-str)
          (- (length sl) 1))))

(defun unknown-code (sl)
  "Provide unrecognised information from SL."
  (list nil nil nil))

(provide 'lfe-doc-finder)
;;; lfe-doc-finder.el ends here
