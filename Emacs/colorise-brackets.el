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
   '(rainbow-delimiters-depth-5-face ((t (:foreground "violet"))))
   '(rainbow-delimiters-depth-6-face ((t (:foreground "blue"))))
   '(rainbow-delimiters-depth-7-face ((t (:foreground "green"))))
   '(rainbow-delimiters-depth-8-face ((t (:foreground "yellow"))))
   '(rainbow-delimiters-depth-9-face ((t (:foreground "violet"))))
   '(rainbow-delimiters-unmatched-face ((t (:foreground "red"))))
   '(highlight ((t (:foreground "#ff0000" :background "black"))))
   ))
(colorise-brackets)
