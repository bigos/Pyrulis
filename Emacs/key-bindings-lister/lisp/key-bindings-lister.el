;;; key-bindings-lister.el --- Key Bindings Lister

;;; Commentary:
;; My attempt to have up to date key bindings no matter what modes are used

;;; Code:

;;; notes

;; I can get key bindings for sinple shortcut like C-s this way:

;; find the code for C-s

;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Ctl_002dChar-Syntax.html#Ctl_002dChar-Syntax
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

;; super bindings
;; ELISP> ?\s-=
;; 8388669 (#o40000075, #x80003d)
;; ELISP> (key-binding [8388669])
;; insert-rails-erb-tag

;; BOOOO got inactive key bibdings as well

;; perhaps (current-active-maps) is the way to go
;; (elt (current-active-maps) 11)

;; (elt (elt (current-active-maps) 11) 1)
;; char-tables
;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Char_002dTable-Type.html#Char_002dTable-Type

;; (type-of  (elt (elt (current-active-maps) 11) 1) )
;; char-table

;; commands in char-table
;; (dotimes (x 130 y) (progn (princ x) (print  (elt (elt (elt (current-active-maps) 11) 1) x))))

;; more key-binding
;; ELISP> (key-binding "\C-@" )
;; set-mark-command
;; ELISP> (key-binding "\C-a" )
;; prelude-move-beginning-of-line
;; ELISP> (key-binding "\C-b" )
;; backward-char
;; ELISP> (key-binding "\M-=" )
;; count-words-region
;; ELISP> (key-binding "<f2>" )
;; nil
;; ELISP> (kbd "a")
;; "a"
;; ELISP> (kbd "<f2>")
;; [f2]

;; ELISP> (key-binding [f2] )
;; 2C-command
;; ELISP> (key-binding [f10] )
;; menu-bar-open
;; ELISP> (key-binding [home] )
;; prelude-move-beginning-of-line
;; ELISP> (key-binding [down] )
;; next-line

;; very promising find
;; (lookup-key (elt (current-active-maps) 11) "\C-a")

;; clean way of finding the bindings
;; (map-keymap (lambda (x y)(print "!!!!!!!!!!!!!!!!!!!!!")(princ x)(print y)) (elt (current-active-maps) 11) )

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
