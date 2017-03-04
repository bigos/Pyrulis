;;; code:

(defun load-acl2 ()
  (interactive)
  (load "~/Documents/acl2-7.2/emacs/emacs-acl2.el")
  (setq inferior-acl2-program "~/Documents/acl2-7.2/saved_acl2"))
;;; run M-x lisp mode when you see the prompt to get paredit and the rest

 (setq prelude-guru nil) ;; better for slime
;; (setq guru-warn-only t) ;; not suitable for slime

(global-set-key (kbd "M-s-g") 'vc-git-grep)

(global-hl-line-mode -1)
(menu-bar-mode 1)
;; (setq prelude-flyspell nil)
;;(smartparens-global-mode -1)

(require 'magit)

(prelude-require-packages '(buffer-move paredit underwater-theme
                                        rubocop rvm rinari ruby-block
                                        ruby-refactor rspec-mode rails-log-mode
                                        ruby-hash-syntax
                                        ido-ubiquitous helm-projectile
                                        slime web-mode switch-window
                                        helm-descbinds load-theme-buffer-local
                                        projectile-rails
                                        redshank))

(helm-descbinds-mode)
(require 'rubocop)
(require 'load-theme-buffer-local)

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

;;; switch-window
(global-set-key (kbd "C-x o") 'switch-window)

;;; web mode
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(setq web-mode-code-indent-offset 2)
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(add-hook 'web-mode-hook #'(lambda () (smartparens-mode -1)))

;;; insert only <% side of erb tag, autopairing wi
(fset 'insert-rails-erb-tag [?< ?%  ?% ?>])
(global-set-key (kbd "s-=") 'insert-rails-erb-tag)

;; Open .v files with Proof General's Coq mode
(load "~/.emacs.d/lisp/PG/generic/proof-site")

;;; get rid of utf-8 warning in Ruby mode
(setq ruby-insert-encoding-magic-comment nil)

(load (expand-file-name "~/quicklisp/slime-helper.el"))
;; Set your lisp system and, optionally, some contribs
;;(setq inferior-lisp-program "sbcl")
(setq slime-contribs '(slime-fancy))

;; (setq slime-default-lisp 'sbcl)
(setq slime-lisp-implementations
      '((sbcl ("/usr/local/bin/sbcl")))
      slime-default-lisp 'sbcl)

(defun swap-paredit ()
  (smartparens-mode -1)
  (paredit-mode +1))

(add-hook 'lfe-mode-hook (lambda () (swap-paredit)))
(add-hook 'lfe-mode-hook 'rainbow-delimiters-mode)

(add-hook 'inferior-lfe-mode-hook (lambda () (swap-paredit)))
(add-hook 'inferior-lfe-mode-hook 'rainbow-delimiters-mode)

(autoload 'paredit-mode "paredit"
  "Minor mode for pseudo-structurally editing Lisp code." t)
(add-hook 'emacs-lisp-mode-hook (lambda () (swap-paredit)))
(add-hook 'lisp-mode-hook (lambda () (swap-paredit)))
(add-hook 'lisp-interaction-mode-hook (lambda () (swap-paredit)))
(add-hook 'scheme-mode-hook (lambda () (swap-paredit)))
(add-hook 'slime-repl-mode-hook (lambda () (swap-paredit)))
(add-hook 'slime-repl-mode-hook 'rainbow-delimiters-mode)
(add-hook 'clojure-mode-hook #'paredit-mode)

(require 'redshank-loader)
(eval-after-load "redshank-loader"
  `(redshank-setup '(lisp-mode-hook
                     slime-repl-mode-hook)
                   t))


;; LFE mode.
;; Set lfe-dir to point to where the lfe emacs files are.
(defvar lfe-dir (concat (getenv "HOME") "/Programming/lfe/emacs"))
(setq load-path (cons lfe-dir load-path))
(require 'lfe-start)

;;; bracket colorization done in elpa module
(obvious-parentheses-colorize)

(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook 'linum-mode)
(add-hook 'prog-mode-hook 'magit-wip-after-save-local-mode)

;; moving buffers
(require 'buffer-move)
;; need to find unused shortcuts for moving up and down
(global-set-key (kbd "<M-s-up>")     'buf-move-up)
(global-set-key (kbd "<M-s-down>")   'buf-move-down)
(global-set-key (kbd "<M-s-left>")   'buf-move-left)
(global-set-key (kbd "<M-s-right>")  'buf-move-right)

(defun unfold-lisp ()
       "Unfold lisp code."
     (interactive)
     (search-forward ")")
     (backward-char)
     (search-forward " ")
     (newline-and-indent))

(global-set-key (kbd "s-0") 'unfold-lisp)

(load "server")
(unless (server-running-p) (server-start))

(provide 'personal)
;;; personal ends here
