;;; code:

(defun load-acl2 ()
  (interactive)
  (load "~/Documents/acl2-7.4/emacs/emacs-acl2.el")
  (setq inferior-acl2-program "~/Documents/acl2-7.4/saved_acl2"))
;;; run M-x lisp-mode when you see the prompt to get paredit and the rest

 (setq prelude-guru nil) ;; better for slime
;; (setq guru-warn-only t) ;; not suitable for slime

(menu-bar-mode 1)
(global-hl-line-mode -1)
;; (setq prelude-flyspell nil)
;;(smartparens-global-mode -1)

(global-set-key (kbd "M-s-g") 'vc-git-grep)

(prelude-require-packages '(buffer-move paredit underwater-theme projectile
                                        rubocop rvm rinari ruby-block
                                        ruby-hash-syntax
                                        ruby-refactor rspec-mode rails-log-mode
                                        ido-ubiquitous helm-projectile
                                        slime web-mode switch-window
                                        helm-descbinds load-theme-buffer-local
                                        projectile-rails magit kurecolor
                                        redshank))

(setq org-src-fontify-natively t)

(helm-descbinds-mode)
(require 'load-theme-buffer-local)

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

;;; switch-window
(global-set-key (kbd "C-x o") 'switch-window)

;;; web mode
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(setq web-mode-code-indent-offset 2)
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(add-hook 'web-mode-hook #'(lambda () (smartparens-mode -1)))

;;; insert only <% side of erb tag, autopairing wi
(fset 'insert-rails-erb-tag [?< ?% ])
(global-set-key (kbd "s-=") 'insert-rails-erb-tag)

;;; get rid of utf-8 warning in Ruby mode
(setq ruby-insert-encoding-magic-comment nil)

(load (expand-file-name "~/quicklisp/slime-helper.el"))
;; Set your lisp system and, optionally, some contribs
(setq inferior-lisp-program "sbcl")
(setq slime-contribs '(slime-fancy))


(defun swap-paredit ()
  "Replace smartparens with superior paredit."
  (smartparens-mode -1)
  (paredit-mode +1))

(autoload 'paredit-mode "paredit"
  "Minor mode for pseudo-structurally editing Lisp code." t)
(add-hook 'emacs-lisp-mode-hook (lambda () (swap-paredit)))
(add-hook 'lisp-mode-hook (lambda () (swap-paredit)))
(add-hook 'lisp-interaction-mode-hook (lambda () (swap-paredit)))
(add-hook 'scheme-mode-hook (lambda () (swap-paredit)))
(add-hook 'slime-repl-mode-hook (lambda () (swap-paredit)))
(add-hook 'slime-repl-mode-hook 'rainbow-delimiters-mode)
(add-hook 'clojure-mode-hook (lambda () (swap-paredit)))
(add-hook 'cider-repl-mode-hook (lambda () (swap-paredit)))

;; LFE mode.
;; Set lfe-dir to point to where the lfe emacs files are.
(defvar lfe-dir (concat (getenv "HOME") "/Programming/lfe/emacs"))
(setq load-path (cons lfe-dir load-path))
;;; clean-up the LFE REPL
(global-set-key (kbd "s-q") 'inferior-lfe-clear-buffer)


(add-hook 'lfe-mode-hook (lambda ()
                           (swap-paredit)
                           (rainbow-delimiters-mode)))

(add-hook 'inferior-lfe-mode-hook (lambda ()
                                    (swap-paredit)
                                    (rainbow-delimiters-mode)))

(require 'lfe-start)

(require 'lfe-doc-finder)

(require 'redshank-loader)
(eval-after-load "redshank-loader"
  `(redshank-setup '(lisp-mode-hook
                     slime-repl-mode-hook)
                   t))

(defun unfold-lisp ()
    "Unfold lisp code."
  (interactive)
  (search-forward ")")
  (backward-char)
  (search-forward " ")
  (newline-and-indent))

(global-set-key (kbd "s-0") 'unfold-lisp)

(defun capitalise-backwards ()
  "Go back to nearest space and capitalise following string."
  (interactive)
  (let ((original-buffer (current-buffer))
        (original-marker (point-marker))
        (start-marker)
        (end-marker))
    (search-backward " ")
    (delete-char 1)
    (setf start-marker (point-marker))
    (forward-char)
    (setf end-marker (point-marker))
    (capitalize-region start-marker end-marker)
    (goto-char original-marker)))

(global-set-key (kbd "s-2") 'capitalise-backwards)

(load "server")
(unless (server-running-p)
  (server-start))

;;; this add capability to define your own hook for responding to theme changes
(defvar after-load-theme-hook nil
  "Hook run after a color theme is loaded using `load-theme'.")
(defadvice load-theme (after run-after-load-theme-hook activate)
  "Run `after-load-theme-hook'."
  (run-hooks 'after-load-theme-hook))

(require 'color)
(defun hsl-to-hex (h s l)
  "Convert H S L to hex colours."
  (let (rgb)
    (setq rgb (color-hsl-to-rgb h s l))
    (color-rgb-to-hex (nth 0 rgb)
                      (nth 1 rgb)
                      (nth 2 rgb))))

(defun hex-to-rgb (hex)
  "Convert a 6 digit HEX color to r g b."
  (mapcar #'(lambda (s) (/ (string-to-number s 16) 255.0))
          (list (substring hex 1 3)
                (substring hex 3 5)
                (substring hex 5 7))))

(defun bg-color ()
  "Return COLOR or it's hexvalue."
  (let ((color (face-attribute 'default :background)))
    (if (equal (substring color 0 1) "#")
        color
      (apply 'color-rgb-to-hex (color-name-to-rgb color)))))

(defun bg-light ()
  "Calculate background brightness."
  (< (color-distance  "white"
                      (bg-color))
     (color-distance  "black"
                      (bg-color))))

(defun whitespace-line-bg ()
  "Calculate long line highlight depending on background brightness."
  (apply 'color-rgb-to-hex
   (apply 'color-hsl-to-rgb
          (apply (if (bg-light) 'color-darken-hsl 'color-lighten-hsl)
           (append
            (apply 'color-rgb-to-hsl
                   (hex-to-rgb
                    (bg-color)))
            '(7))))))

(defun bracket-colors ()
  "Calculate the bracket colours based on background."
  (let (hexcolors lightvals)
    (setq lightvals (if (bg-light)
                        (list (list .60 1.0 0.55) ; H S L
                              (list .30 1.0 0.40)
                              (list .11 1.0 0.55)
                              (list .01 1.0 0.65)
                              (list .75 0.9 0.55) ; H S L
                              (list .49 0.9 0.40)
                              (list .17 0.9 0.47)
                              (list .05 0.9 0.55))
                      (list (list .70 1.0 0.68) ; H S L
                            (list .30 1.0 0.40)
                            (list .11 1.0 0.50)
                            (list .01 1.0 0.50)
                            (list .81 0.9 0.55) ; H S L
                            (list .49 0.9 0.40)
                            (list .17 0.9 0.45)
                            (list .05 0.9 0.45))))
    (dolist (n lightvals)
      (push (apply 'hsl-to-hex n) hexcolors))
    (reverse hexcolors)))


(defun colorise-brackets ()
  "Apply my own colours to rainbow delimiters."
  (interactive)
  (require 'rainbow-delimiters)
  (custom-set-faces
   ;; change the background but do not let theme to interfere with the foreground
   `(whitespace-line ((t (:background ,(whitespace-line-bg)))))
   ;; or use (list-colors-display)
   `(rainbow-delimiters-depth-2-face ((t (:foreground ,(nth 0 (bracket-colors))))))
   `(rainbow-delimiters-depth-3-face ((t (:foreground ,(nth 1 (bracket-colors))))))
   `(rainbow-delimiters-depth-4-face ((t (:foreground ,(nth 2 (bracket-colors))))))
   `(rainbow-delimiters-depth-5-face ((t (:foreground ,(nth 3 (bracket-colors))))))
   `(rainbow-delimiters-depth-6-face ((t (:foreground ,(nth 4 (bracket-colors))))))
   `(rainbow-delimiters-depth-7-face ((t (:foreground ,(nth 5 (bracket-colors))))))
   `(rainbow-delimiters-depth-8-face ((t (:foreground ,(nth 6 (bracket-colors))))))
   `(rainbow-delimiters-depth-9-face ((t (:foreground ,(nth 7 (bracket-colors))))))
   `(rainbow-delimiters-unmatched-face ((t (:foreground "white" :background "red"))))
   `(highlight ((t (:foreground "#ff0000" :background "#888"))))))

(colorise-brackets)

(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook 'linum-mode)
(add-hook 'after-load-theme-hook 'colorise-brackets)

;; moving buffers
(require 'buffer-move)
;; need to find unused shortcuts for moving up and down
(global-set-key (kbd "<M-s-up>")     'buf-move-up)
(global-set-key (kbd "<M-s-down>")   'buf-move-down)
(global-set-key (kbd "<M-s-left>")   'buf-move-left)
(global-set-key (kbd "<M-s-right>")  'buf-move-right)


(provide 'personal)
;;; personal ends here
