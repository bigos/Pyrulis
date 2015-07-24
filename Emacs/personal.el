;;; Code:
(setq prelude-guru nil)
(global-hl-line-mode -1)
;; (setq prelude-whitespace nil)
;; (setq prelude-flyspell nil)
;;(smartparens-global-mode -1)

(require 'magit)

(prelude-require-packages '(buffer-move paredit underwater-theme
                                        rubocop rvm rinari ruby-block
                                        ruby-refactor rspec-mode rails-log-mode
                                        slime))

;; magit warning silencing
(setq magit-auto-revert-mode nil)
(setq magit-last-seen-setup-instructions "1.4.0")



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

(setq inferior-lisp-program "/usr/local/bin/sbcl")
(slime-setup '(slime-repl slime-fancy))
(setq slime-default-lisp 'sbcl)

(when (not(package-installed-p 'paredit))
  (package-initialize 'paredit))

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
(add-hook 'lfe-mode-hook (lambda () (swap-paredit)))
(add-hook 'lfe-mode-hook (lambda () (rainbow-delimiters-mode +1)))



(defun colorise-brackets ()
  (require 'rainbow-delimiters)
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(rainbow-delimiters-depth-1-face ((t (:foreground "grey"))))
   '(rainbow-delimiters-depth-2-face ((t (:foreground "RoyalBlue"))))
   '(rainbow-delimiters-depth-3-face ((t (:foreground "lime green"))))
   '(rainbow-delimiters-depth-4-face ((t (:foreground "yellow"))))
   '(rainbow-delimiters-depth-5-face ((t (:foreground "red"))))
   '(rainbow-delimiters-depth-6-face ((t (:foreground "RoyalBlue"))))
   '(rainbow-delimiters-depth-7-face ((t (:foreground "lime green"))))
   '(rainbow-delimiters-depth-8-face ((t (:foreground "yellow"))))
   '(rainbow-delimiters-depth-9-face ((t (:foreground "red"))))
   '(rainbow-delimiters-unmatched-face ((t (:foreground "white" :background "red"))))
   '(highlight ((t (:foreground "#ff0000" :background "grey"))))
   ))
(colorise-brackets)

(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook 'linum-mode)

;; (defun dark-colorise-brackets ()
;;   (require 'rainbow-delimiters)
;;   (custom-set-faces
;;    ;; custom-set-faces was added by Custom.
;;    ;; If you edit it by hand, you could mess it up, so be careful.
;;    ;; Your init file should contain only one such instance.
;;    ;; If there is more than one, they won't work right.
;;    '(rainbow-delimiters-depth-1-face ((t (:foreground "#888888"))))
;;    '(rainbow-delimiters-depth-2-face ((t (:foreground "#0000cc"))))
;;    '(rainbow-delimiters-depth-3-face ((t (:foreground "#00dd00"))))
;;    '(rainbow-delimiters-depth-4-face ((t (:foreground "#ffdd00"))))
;;    '(rainbow-delimiters-depth-5-face ((t (:foreground "#aa0000"))))
;;    '(rainbow-delimiters-depth-6-face ((t (:foreground "blue"))))
;;    '(rainbow-delimiters-depth-7-face ((t (:foreground "#00dd00"))))
;;    '(rainbow-delimiters-depth-8-face ((t (:foreground "#ffdd00"))))
;;    '(rainbow-delimiters-depth-9-face ((t (:foreground "#cc0000"))))
;;    '(rainbow-delimiters-unmatched-face ((t (:foreground "white" :background "red"))))
;;    '(highlight ((t (:foreground "#ff0000" :background "grey"))))
;;    ))
;; (dark-colorise-brackets)

;; moving buffers
(require 'buffer-move)
;; need to find unused shortcuts for moving up and down
(global-set-key (kbd "<M-s-up>")     'buf-move-up)
(global-set-key (kbd "<M-s-down>")   'buf-move-down)
(global-set-key (kbd "<M-s-left>")   'buf-move-left)
(global-set-key (kbd "<M-s-right>")  'buf-move-right)


(provide 'personal)
;;; personal ends here
