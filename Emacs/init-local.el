;;; package --- My custom settings for purcell Emacs strarter kit

;;; Commentary:

;;; Code:

(require-package 'ruby-mode)
(require-package 'rubocop)
(require-package 'rinari)
(require-package 'helm-descbinds)
(require-package 'web-mode)
(require-package 'underwater-theme)
(require-package 'rubocop)
(require-package 'rvm)
(require-package 'neotree)

(helm-descbinds-mode)
;;; disable paredit everywhere mode
(add-hook 'minibuffer-setup-hook (lambda () (electric-pair-mode 0)))

(require 'neotree)
(global-set-key [f8] 'neotree-toggle)


;;; MacOSX style shortcuts
(global-set-key (kbd "s-z") 'undo)
(global-set-key (kbd "s-x") 'clipboard-kill-region)
(global-set-key (kbd "s-c") 'clipboard-kill-ring-save)
(global-set-key (kbd "s-v") 'clipboard-yank)

;;(load (expand-file-name "C:/Users/Jacek/quicklisp/slime-helper.el"))
(load (expand-file-name "~/quicklisp/slime-helper.el"))

;; (setq inferior-lisp-program "sbcl")
(slime-setup '(slime-repl slime-fancy))

;; (setq slime-default-lisp 'sbcl)
(setq slime-lisp-implementations
      '((sbcl ("/usr/local/bin/sbcl"))) ; giving a command arg
      slime-default-lisp 'sbcl)

;; (setq slime-default-lisp "C:/Program Files/Steel Bank Common Lisp/1.3.2/sbcl.exe --core sbcl.core")

(require 'color)
(defun hsl-to-hex (h s l)
  (let (rgb)
    (setq rgb (color-hsl-to-rgb h s l))
    (color-rgb-to-hex (nth 0 rgb)
                      (nth 1 rgb)
                      (nth 2 rgb))))

(defun bracket-colors ()
  (let (hexcolors)
    (concatenate 'list
                 (dolist (n'(.71 .3 .11 .01))
                   (push (hsl-to-hex (+ n 0.0) 1.0 0.65) hexcolors))
                 (dolist (n '(.81 .49 .17 .05))
                   (push (hsl-to-hex (+ n 0.0) 1.0 0.55) hexcolors)))
    (reverse hexcolors)))


(defun colorise-brackets ()
  (require 'rainbow-delimiters)
  (custom-set-faces
   ;; emacs colours
   ;; http://raebear.net/comp/emacscolors.html
   ;; or use (list-colors-display)
   `(rainbow-delimiters-depth-1-face ((t (:foreground "grey"))))
   `(rainbow-delimiters-depth-2-face ((t (:foreground ,(nth 0 (bracket-colors))))))
   `(rainbow-delimiters-depth-3-face ((t (:foreground ,(nth 1 (bracket-colors))))))
   `(rainbow-delimiters-depth-4-face ((t (:foreground ,(nth 2 (bracket-colors))))))
   `(rainbow-delimiters-depth-5-face ((t (:foreground ,(nth 3 (bracket-colors))))))
   `(rainbow-delimiters-depth-6-face ((t (:foreground ,(nth 4 (bracket-colors))))))
   `(rainbow-delimiters-depth-7-face ((t (:foreground ,(nth 5 (bracket-colors))))))
   `(rainbow-delimiters-depth-8-face ((t (:foreground ,(nth 6 (bracket-colors))))))
   `(rainbow-delimiters-depth-9-face ((t (:foreground ,(nth 7 (bracket-colors))))))
   `(rainbow-delimiters-unmatched-face ((t (:foreground "white" :background "red"))))
   `(highlight ((t (:foreground "#ff0000" :background "grey"))))
   ))

(colorise-brackets)

(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook 'linum-mode)

(provide 'init-local)
;;; init-local.el ends here
