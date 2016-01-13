;;; code:

(defun load-acl2 ()
  (interactive)
  (load "~/Documents/acl2-7.1/emacs/emacs-acl2.el")
  (setq inferior-acl2-program "~/Documents/acl2-7.1/saved_acl2"))

 (setq prelude-guru nil) ;; better for slime
;; (setq guru-warn-only t) ;; not suitable for slime

(global-hl-line-mode -1)
;; (setq prelude-flyspell nil)
;;(smartparens-global-mode -1)

(require 'magit)
;; (require 'key-bindings-lister)


(prelude-require-packages '(buffer-move paredit underwater-theme
                                        rubocop rvm rinari ruby-block
                                        ruby-refactor rspec-mode rails-log-mode
                                        slime web-mode ))

(require 'helm-descbinds)
(helm-descbinds-mode)

;; magit warning silencing
(setq magit-auto-revert-mode nil)
(setq magit-last-seen-setup-instructions "1.4.0")

(setq whitespace-line '(t (:background "gray16")))

;; Allow hash to be entered on MacOSX
(fset 'insertPound "#")
(global-set-key (kbd "M-3") 'insertPound)

;;; MacOSX style shortcuts
(global-set-key (kbd "s-z") 'undo)
(global-set-key (kbd "s-x") 'clipboard-kill-region)
(global-set-key (kbd "s-c") 'clipboard-kill-ring-save)
(global-set-key (kbd "s-v") 'clipboard-yank)

(global-set-key (kbd "s-a") 'bs-cycle-previous)
(global-set-key (kbd "s-s") 'bs-cycle-next)
(global-set-key (kbd "s-b") 'ibuffer)

;;; MacOSX F keys
(global-set-key (kbd "s-3") 'kmacro-start-macro-or-insert-counter)
(global-set-key (kbd "s-4") 'kmacro-end-or-call-macro)

;;; web mode
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(setq web-mode-code-indent-offset 2)
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)

(fset 'insert-rails-erb-tag [?< ?% ?% ?> left left])
(global-set-key (kbd "s-=") 'insert-rails-erb-tag)

;;; get rid of utf-8 warning in Ruby mode
(setq ruby-insert-encoding-magic-comment nil)

(load (expand-file-name "~/quicklisp/slime-helper.el"))
(setq inferior-lisp-program "sbcl")
(slime-setup '(slime-repl slime-fancy))
(setq slime-default-lisp 'sbcl)

(defun swap-paredit ()
  (paredit-mode +1)
  (smartparens-mode -1))

(autoload 'paredit-mode "paredit"
  "Minor mode for pseudo-structurally editing Lisp code." t)
(add-hook 'emacs-lisp-mode-hook (lambda () (swap-paredit)))
(add-hook 'lisp-mode-hook (lambda () (swap-paredit)))
(add-hook 'lisp-interaction-mode-hook (lambda () (swap-paredit)))
(add-hook 'scheme-mode-hook (lambda () (swap-paredit)))
(add-hook 'slime-repl-mode-hook (lambda () (swap-paredit)))
(add-hook 'slime-repl-mode-hook 'rainbow-delimiters-mode)
(add-hook 'lfe-mode-hook (lambda () (swap-paredit)))
(add-hook 'lfe-mode-hook (lambda () (rainbow-delimiters-mode +1)))

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

;; moving buffers
(require 'buffer-move)
;; need to find unused shortcuts for moving up and down
(global-set-key (kbd "<M-s-up>")     'buf-move-up)
(global-set-key (kbd "<M-s-down>")   'buf-move-down)
(global-set-key (kbd "<M-s-left>")   'buf-move-left)
(global-set-key (kbd "<M-s-right>")  'buf-move-right)


(provide 'personal)
;;; personal ends here
