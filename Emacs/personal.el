;;;

(setq prelude-guru nil)
(global-hl-line-mode -1)
;(setq prelude-whitespace nil)
(setq prelude-flyspell nil)
;(smartparens-global-mode -1)

(global-linum-mode )

;;; MacOSX style shortcuts
(global-set-key (kbd "s-z") 'undo)
(global-set-key (kbd "s-x") 'clipboard-kill-region)
(global-set-key (kbd "s-c") 'clipboard-kill-ring-save)
(global-set-key (kbd "s-v") 'clipboard-yank)

(global-set-key (kbd "s-a") 'bs-cycle-previous)
(global-set-key (kbd "s-s") 'bs-cycle-next)
(global-set-key (kbd "s-b") 'ibuffer)
(global-set-key (kbd "s-w") (lambda () (interactive) (switch-to-buffer "*slime-repl sbcl*")))
(global-set-key (kbd "s-q") 'ido-switch-buffer)

(slime-setup '(slime-repl slime-fancy))
(setq common-lisp-hyperspec-root
      "file:/home/jacek/Documents/Manuals/Lisp/HyperSpec-7-0/HyperSpec/")
;(setq browse-url-browser-function 'browse-url-generic)
;(setq browse-url-generic-program "google-chrome")


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

(defun colorise-brackets ()
  (require 'rainbow-delimiters)
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(rainbow-delimiters-depth-1-face ((t (:foreground "grey"))))
   '(rainbow-delimiters-depth-2-face ((t (:foreground "blue"))))
   '(rainbow-delimiters-depth-3-face ((t (:foreground "green"))))
   '(rainbow-delimiters-depth-4-face ((t (:foreground "yellow"))))
   '(rainbow-delimiters-depth-5-face ((t (:foreground "red"))))
   '(rainbow-delimiters-depth-6-face ((t (:foreground "blue"))))
   '(rainbow-delimiters-depth-7-face ((t (:foreground "green"))))
   '(rainbow-delimiters-depth-8-face ((t (:foreground "yellow"))))
   '(rainbow-delimiters-depth-9-face ((t (:foreground "red"))))
   '(rainbow-delimiters-unmatched-face ((t (:foreground "white" :background "red"))))
   '(highlight ((t (:foreground "#ff0000" :background "grey"))))
   ))

(colorise-brackets)
