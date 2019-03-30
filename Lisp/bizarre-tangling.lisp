#+PROPERTY: header-args :tangle yes

* Header 1
This Emacs code pasted in the scratch buffer and executed adds a cool tangling
function.

#+BEGIN_EXAMPLE
(defun bizarro-tangle (comment-string)
  "Comment out every line but src blocks in chosen syntax"
  (interactive "sComment string: ")
  (outline-show-all)
  (beginning-of-buffer)
  (while (not (eobp))
    (unless (org-in-src-block-p t)   ; comment out BEGIN and END lines
      (save-excursion (beginning-of-line)
              (insert comment-string)))
    (next-line)))
#+END_EXAMPLE

** code

will go here

#+BEGIN_SRC common-lisp
  (format t "hello~%")
#+END_SRC
