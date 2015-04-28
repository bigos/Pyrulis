;;;

(setq prelude-guru nil)
(global-hl-line-mode -1)
;(setq prelude-whitespace nil)
(setq prelude-flyspell nil)
;(smartparens-global-mode -1)

(global-linum-mode )

;; (add-to-list 'load-path "~/emacs.d/vendor")
;; (require 'git-auto-commit-mode)

;;; MacOSX style shortcuts
(global-set-key (kbd "s-z") 'undo)
(global-set-key (kbd "s-x") 'clipboard-kill-region)
(global-set-key (kbd "s-c") 'clipboard-kill-ring-save)
(global-set-key (kbd "s-v") 'clipboard-yank)

(global-set-key (kbd "s-q") 'ace-jump-buffer)


(require 'slime-autoloads)
(setq slime-contribs '(slime-fancy))

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
(add-hook 'lfe-mode-hook (lambda () (swap-paredit)))
(add-hook 'lfe-mode-hook (lambda () (rainbow-delimiters-mode +1)))

(setq debug-on-error t)
(require 'color)
(defun custom-colours (colors-number saturation brightness increment)
  (let (colour-list '())
    (dotimes (last colors-number)
      (setq colour-list
            (concatenate 'list
                         colour-list
                         (list
                          (apply
                           'color-rgb-to-hex
                           (color-hsl-to-rgb (* last increment) saturation brightness))))))
    colour-list))

;;; bright background
;; (setq colour (custom-colours 4 1 0.45 0.23))

;;; dark background
(setq colour (custom-colours 4 1 0.6 0.2))

;;; printing of cusom colours
;;; (print colour  (get-buffer "*scratch*"))

(defun colorise-brackets ()
  (require 'rainbow-delimiters)
  (custom-set-faces
   '(rainbow-delimiters-depth-1-face ((t (:foreground "grey"))))
   `(rainbow-delimiters-depth-2-face ((t (:foreground ,(elt colour 0)))))
   `(rainbow-delimiters-depth-3-face ((t (:foreground ,(elt colour 1)))))
   `(rainbow-delimiters-depth-4-face ((t (:foreground ,(elt colour 2)))))
   `(rainbow-delimiters-depth-5-face ((t (:foreground ,(elt colour 3)))))
   `(rainbow-delimiters-depth-6-face ((t (:foreground ,(elt colour 0)))))
   `(rainbow-delimiters-depth-7-face ((t (:foreground ,(elt colour 1)))))
   `(rainbow-delimiters-depth-8-face ((t (:foreground ,(elt colour 2)))))
   `(rainbow-delimiters-depth-9-face ((t (:foreground ,(elt colour 3)))))
   '(rainbow-delimiters-unmatched-face ((t (:foreground "white" :background "red"))))
   '(highlight ((t (:foreground "#ff0000" :background "grey"))))))
   ;; to get rid of header line in REPL change Slime Header Line in Emacs settings


(colorise-brackets)


;; term
(defface term-color-black
  '((t (:foreground "#3f3f3f" :background "#272822")))
  "Unhelpful docstring.")
(defface term-color-red
  '((t (:foreground "#cc9393" :background "#272822")))
  "Unhelpful docstring.")
(defface term-color-green
  '((t (:foreground "#7f9f7f" :background "#272822")))
  "Unhelpful docstring.")
(defface term-color-yellow
  '((t (:foreground "#f0dfaf" :background "#272822")))
  "Unhelpful docstring.")
(defface term-color-blue
  '((t (:foreground "#6d85ba" :background "#272822")))
  "Unhelpful docstring.")
(defface term-color-magenta
  '((t (:foreground "#dc8cc3" :background "#272822")))
  "Unhelpful docstring.")
(defface term-color-cyan
  '((t (:foreground "#93e0e3" :background "#272822")))
  "Unhelpful docstring.")
(defface term-color-white
  '((t (:foreground "#dcdccc" :background "#272822")))
  "Unhelpful docstring.")
'(term-default-fg-color ((t (:inherit term-color-white))))
'(term-default-bg-color ((t (:inherit term-color-black))))

;; ansi-term colors
(setq ansi-term-color-vector
  [term term-color-black term-color-red term-color-green term-color-yellow
    term-color-blue term-color-magenta term-color-cyan term-coloqr-white])


(set-language-environment 'utf-8)
(set-default-coding-systems 'utf-8)
(set-selection-coding-system 'utf-8)
(set-locale-environment "en_GB.UTF-8")
(prefer-coding-system 'utf-8)

;; moving buffers
(require 'buffer-move)
;; need to find unused shortcuts for moving up and down
(global-set-key (kbd "<M-s-up>")     'buf-move-up)
(global-set-key (kbd "<M-s-down>")   'buf-move-down)
(global-set-key (kbd "<M-s-left>")   'buf-move-left)
(global-set-key (kbd "<M-s-right>")  'buf-move-right)
