;;; lfedoc-finder --- Code for finding LFE documentation

;;; Commentary:

;;; This is supposed to make easier to look up documentation.
;;; Now you can select smartparens or paredit to search for sexp boundaries.
;;; Reading still breaks on LFE vector syntax.

;;; Usage:

;;; Load this file by adding it in the load-path and running:
;;; (load "lfe-doc-finder.el")


;;; M-x lfedoc-helpme
;;; Will hopefully take you to a relevant page in Erlang documentation.

;;; M-x lfedoc-inspect
;;; Will print to the mini buffer the sexp at the cursor.

;;; Code:

(require 'browse-url)
(require 'paredit)

(defun lfedoc-inspect ()
  "Print sexp."
  (interactive)
  (let ((sexp-str (sexp-at-point)))
    (princ sexp-str)))

(defun sexp-at-point ()
  "find the sexp string"
  (sexp-at-point-emacs)
  ;; (sexp-at-point-paredit)
  )

(defun sexp-at-point-emacs ()
  "Find the sexp string using smartparens."
  ;; sp-backward-up-sexp goes to the left of the opening bracket
  ;; sp-forward-sexp goes to the right of the closing bracket, provided you are
  ;; to the left of the opening bracket
  (let ((original-buffer (current-buffer))
        (original-marker (point-marker))
        (opening-bracket)
        (closing-bracket))
    ;; find opening bracket
    (backward-up-list)
    (setq opening-bracket (point-marker))
    ;; find closing bracket
    (forward-list)
    (setq closing-bracket (point-marker))
    ;; return to the original position
    (goto-char (marker-position original-marker))
    ;; and finally return the string containing the sexp
    (buffer-substring (marker-position opening-bracket) (marker-position closing-bracket))))

(defun sexp-at-point-paredit ()
  "Find the sexp string using paredit."
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

(defun lfedoc-helpme ()
  "Go to Erlang website for help."
  (interactive)
  ;; Read sanitised sexp and extract model and function for browse-url look-up
  (let ((call-struct (lfedoc-call-struct (read
                                          (lfedoc-sanitise
                                           (sexp-at-point))))))
    (if (car call-struct)
        (browse-url
         (apply 'format
                (cons "http://erlang.org/doc/man/%s.html#%s-%d"
                      call-struct)))
      (princ (list "search LFE specific documentation for"
                   'function (nth 1 call-struct)
                   'arity (nth 2 call-struct))))))

(defun lfedoc-call-struct (my-sexp)
  "Examine MY-SEXP and return a structure representing module function and arity."
  (cond ((lfedoc-new-erlang-callp my-sexp)
         (lfedoc-new-erlang-call-args my-sexp))
        ((lfedoc-old-erlang-callp my-sexp)
         (lfedoc-old-erlang-call-args my-sexp))
        (t (lfedoc-unknown-code my-sexp))))

(defun lfedoc-sanitise (str)
  "Sanitise the string STR for reading."
  ;; now lfedoc helpme does not trip over some lfe specific constructs

  ;; TODO: Elisp read might trip over other constructs, I need to find them
  (replace-regexp-in-string "#("        ;vector
                            " ("
                            (replace-regexp-in-string "#B(" ;binary string
                                                      "  ("
                                                      (replace-regexp-in-string "#M(" ;map
                                                                                "  ("
                                                                                str))))

(defun lfedoc-new-erlang-callp (sl)
  "Check id the SL is the new Erlang call syntax."
  (eql (car sl) :))

(defun lfedoc-new-erlang-call-args (sl)
  "Get new Erlang call info for the documentation look-up list SL."
  (list (nth 1 sl) (nth 2 sl) (- (length sl) 3)))

(defun lfedoc-old-erlang-callp (sl)
  "Check id the SL is the old Erlang call syntax."
  (eql (length (split-string (symbol-name (car sl))
                             ":"))
       2))

(defun lfedoc-old-erlang-call-args (sl)
  "Get old Erlang call info for the documentation look-up list SL."
  (let ((call-str (split-string (symbol-name (car sl)) ":")))
    (list (nth 0 call-str)
          (nth 1 call-str)
          (- (length sl) 1))))

(defun lfedoc-unknown-code (sl)
  "Provide unrecognised module information from SL."
  ;; because it's not a module:function of : module function
  ;; we returm nil as module but still return the function and arity
  (list nil (car sl) (- (length sl) 1)))

(provide 'lfedoc)
;;; lfe-doc-finder.el ends here
