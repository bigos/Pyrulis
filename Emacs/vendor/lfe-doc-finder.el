;;; lfedoc --- Code for finding LFE documentation

;;; Commentary:

;;; This is supposed to make easier to look up documentation.
;;; To make it useful I need to study following file
;;; https://github.com/rvirding/lfe/blob/develop/doc/user_guide.txt

;;; Usage:

;;; Load this file by adding it in the load-path and running:
;;; (load "lfe-doc-finder.el")

;;; LOOK-UP

;;; M-x lfedoc-helpme
;;; Will hopefully take you to a relevant page in Erlang documentation.

;;; M-x lfedoc-inspect
;;; Will print to the mini buffer the sexp at the cursor.

;;; AUTO-COMPLETION FUNCTIONS

;;; placing your cursor anywhere between ( and ) in the following sexps
;;; and running Emacs functions will give you a data that can be used in
;;; creation of a plugin that could help with LFE

;;; M-x lfedoc-modules =========================================================
;; (: ) ; will give all loaded modules
;; (: a ) ; only modules that start with a
;; () list of all loaded modules
;; (i ) despite initial letter you will get all loaded modules

;;; M-x lfedoc-module-functions ================================================
;; (: io  ) ; will give all exported functions in io module
;; (: io p) ; only functions that start with p

;;; old style module and function syntax
;;; (zlib: ) will give all exported functions in zlib module
;;; (zlib:a ) only functions that start with a

;;; old syntax errors with lfedoc-module-functions
;;; (zlib : a ) nothing
;;; (zlib : ) nothing

;;; M-x lfedoc-functions =======================================================
;; (a ) ; will give all user guide functions that start with a
;; () ; will give you nothing

;;; old syntax errors with lfedoc-functions
;;; (zlib : a) will give nothing
;;; (zlib:a) wrong type argument error
;;; (zlib: a) wrong type argument error

;;; Code:

(require 'browse-url)


(global-set-key (kbd "s-6") 'lfedoc-modules)
(global-set-key (kbd "s-7") 'lfedoc-module-functions)
(global-set-key (kbd "s-9") 'lfedoc-functions)
(global-set-key (kbd "s-/") 'lfedoc-helpme)
;;; ----------------------------------------------------------------------------

;;; define global variable for loaded modules
(setq lfedoc-global-loaded-modules (list nil))

(defun lfedoc-query-loaded-modules ()
  "Get loaded module names."
  (if (car lfedoc-global-loaded-modules)
      (-map 'car
            lfedoc-global-loaded-modules)
    ;; refresh if not loaded
    (-map 'car
          (lfedoc-refresh-loaded-modules))))

(defun lfedoc-query-module-functions (module)
  "Get Exports information about loaded MODULE."
  (let ((exports-seen))
    (-sort 'string<
           (-flatten
            (-map 'lfedoc-split-string-on-spaces
                  (cdr
                   (-reject 'null ; reject everything before the "Exports: " line
                            (-map
                             (lambda (x)
                               (when (equal "Exports: " x)
                                 (setq exports-seen t))
                               (when exports-seen
                                 x))
                             (lfedoc-string-to-lines
                              (shell-command-to-string
                               (format "lfe -e \"(m (quote %s))\""
                                       module)))))))))))

;;; You need to run it after every reload of this file.
(defun lfedoc-refresh-loaded-modules ()
  "Refresh the list of loaded modules."
  (interactive)
  (setq lfedoc-global-loaded-modules
        (-map 'lfedoc-split-string-on-spaces
              (cdr (butlast
                    (lfedoc-string-to-lines
                     (shell-command-to-string (format "lfe -e \"%s\" "
                                                      "(m)")))))))
  (princ "Modules have been refreshed.")
  lfedoc-global-loaded-modules)

;;; ----------------------------------------------------------------------------

(defun lfedoc-string-to-lines (str)
  "Split STR into a list of lines."
  (-reject 'null
           (split-string str (format "%c" 10))))

(defun lfedoc-split-string-on-spaces (str)
  "Split STR on spaces."
  (-filter (lambda (x) (> (length x) 0))
           (split-string str " ")))

;;; ----------------------------------------------------------------------------
(defun lfedoc-module-functions ()
  "Get a list of module exported functions that start with given character(s)
or all functions if no function characters are given."
  (interactive)
  (let ((call-struct (lfedoc-call-struct (read
                                          (lfedoc-sanitise
                                           (sexp-at-point))))))
    (if (nth 0 call-struct)
        (pp
         (-filter
          (lambda (x)
            (if (nth 1 call-struct)
                ;; if any character of the function given show possible completions
                ;; otherwise show all available functions
                (lfedoc-string/starts-with
                 x
                 (format "%s"  (nth 1 call-struct)))
              t))
          (lfedoc-query-module-functions (nth 0 call-struct)))))))

(defun lfedoc-modules ()
  "Get list of loaded modules that start with given character(s)."
  (interactive)
  (let ((call-struct (lfedoc-call-struct (read
                                          (lfedoc-sanitise
                                           (sexp-at-point))))))
    (pp (if (nth 0 call-struct)
            (-filter (lambda (x) t
                       (lfedoc-string/starts-with
                         x
                        (format "%s" (nth 0 call-struct)))
                       )
                     (lfedoc-query-loaded-modules))
          (lfedoc-query-loaded-modules)))))

(defun lfedoc-functions ()
  "Get list of known user guide functions that start with given character(s)."
  (interactive)
  ;; we get the character from the call struct
  (let ((call-struct (lfedoc-call-struct (read
                                          (lfedoc-sanitise
                                           (sexp-at-point))))))
    (when (nth 1 call-struct)
      (princ
       (-distinct
        (-sort 'string<
               (-flatten
                (-map 'cdr
                      (lfedoc-find-symbol-autocompletions
                       (nth 1 call-struct))))))))))

(defun lfedoc-autocomplete-function ()
  "Autocomplete the function divided into user guide sections."
  (interactive)
  (let ((call-struct (lfedoc-call-struct (read
                                          (lfedoc-sanitise
                                           (sexp-at-point))))))
    (if (nth 1 call-struct)
        (princ (list 'autocompleting 'function (nth 1 call-struct)
                     call-struct
                     (lfedoc-find-symbol-autocompletions (nth 1 call-struct)))))))

(defun lfedoc-string/starts-with (s begins)
  "Return non-nil if string S start with BEGINS."
  (cond ((>= (length s) (length begins))
         (string-equal (substring s 0 (length begins)) begins))
        (t nil)))

(defun lfedoc-get-symbol-functions ()
  "Get the list of functions that return function symbols."
  '(lfedoc-data-core-forms
    lfedoc-data-basic-macro-forms
    lfedoc-data-common-lisp-inspired-macros
    lfedoc-data-older-scheme-inspired-macros
    lfedoc-data-module-definition
    lfedoc-data-standard-operators
    lfedoc-data-predefined-lfe-functions
    lfedoc-data-supplemental-common-lisp-functions
    lfedoc-data-common-lisp-predicates))

(defun lfedoc-find-symbol-autocompletions (symb)
  "Find symbol SYMB in known symbols and return the function names that return it."
  ;; example (lfedoc-find-symbol-functions  (quote car))
  (-filter (lambda (x) (not (null (nth 1 x))))
           (-map (lambda (f) (list f
                                   (-filter (lambda (sf)
                                              (lfedoc-string/starts-with
                                               (symbol-name sf)
                                               (symbol-name symb)))
                                            (funcall f))))
                 (lfedoc-get-symbol-functions))))

(defun lfedoc-inspect ()
  "Print sexp."
  (interactive)
  (let ((sexp-str (sexp-at-point)))
    ;; show read source and the sanitised version used for reading by Emacs
    (princ (list sexp-str 'sanitised-version (lfedoc-sanitise sexp-str)))))

(defun sexp-at-point ()
  "Find the sexp string."
  (let ((original-buffer (current-buffer))
        (original-marker (point-marker))
        (opening-bracket)
        (closing-bracket))
    ;; find opening bracket
    (backward-up-list)
    (setq opening-bracket (point-marker))
    ;; find closing bracket
    (forward-list)
    (setq closing-bracket (point-marker))
    ;; return to the original position
    (goto-char (marker-position original-marker))
    ;; and finally return the string containing the sexp
    (buffer-substring (marker-position opening-bracket) (marker-position closing-bracket))))

(defun lfedoc-helpme ()
  "Go to Erlang website for help."
  (interactive)
  ;; Read sanitised sexp and extract model and function for browse-url look-up
  (let ((call-struct (lfedoc-call-struct (read
                                          (lfedoc-sanitise
                                           (sexp-at-point))))))
    (if (car call-struct)
        (progn
          (if (or (equalp "cl" (car call-struct)) ; different forms are read differently
                  (equalp 'cl (car call-struct)))
              ;; browse Hyperspec
              (browse-url
               (format "http://clhs.lisp.se/Body/f_%s.htm" (nth 1 call-struct)))
            ;; browse Erlang documentation
            (browse-url
             (apply 'format
                    (cons "http://erlang.org/doc/man/%s.html#%s-%d"
                          call-struct)))))
      (princ (list "search"
                   (lfedoc-find-symbol-functions (nth 1 call-struct))
                   "for"
                   (nth 1 call-struct)
                   'arity (nth 2 call-struct))))))

(defun lfedoc-call-struct (my-sexp)
  "Examine MY-SEXP and return a structure representing module function and arity."
  (cond ((lfedoc-new-erlang-callp my-sexp)
         (lfedoc-new-erlang-call-args my-sexp))
        ((lfedoc-old-erlang-callp my-sexp)
         (lfedoc-old-erlang-call-args my-sexp))
        (t
         (lfedoc-unknown-code my-sexp))))

(defun lfedoc-sanitise (str)
  "Sanitise the string STR for reading."
  ;; now lfedoc helpme does not trip over some lfe specific constructs
  ;; TODO: Elisp read might trip over other constructs, I need to find them
  (replace-regexp-in-string "#("        ;vector
                            " ("
                            (replace-regexp-in-string "#[.BM](" ;binary string or map
                                                      "  ("
                                                      str)))
(defun lfedoc-cl-function-callp (sl)
  "Check if the SL is a supplemental Lisp function.")

(defun lfedoc-cl-function-call-args (sl)
  "Try to loop up for SL using the Hyperspec equivalent.")

(defun lfedoc-new-erlang-callp (sl)
  "Check id the SL is the new Erlang call syntax."
  (eql (car sl) :))

(defun lfedoc-new-erlang-call-args (sl)
  "Get new Erlang call info for the documentation look-up list SL."
  (cond ((and (nth 1 sl)
              (nth 2 sl))
         (list (nth 1 sl) (nth 2 sl) (- (length sl) 3)))
        ((nth 1 sl)
         (list (nth 1 sl) nil nil))
        (t
         (list nil nil nil))))

(defun lfedoc-old-erlang-callp (sl)
  "Check id the SL is the old Erlang call syntax."
  (eql (length (split-string (symbol-name (car sl))
                             ":"))
       2))

(defun lfedoc-old-erlang-call-args (sl)
  "Get old Erlang call info for the documentation look-up list SL."
  (let ((call-str (split-string (symbol-name (car sl)) ":")))
    (list (nth 0 call-str)
          (nth 1 call-str)
          (- (length sl) 1))))

(defun lfedoc-unknown-code (sl)
  "Provide unrecognised module information from SL."
  ;; because it's not a module:function of : module function
  ;; we returm nil as module but still return the function and arity
  (list nil (car sl) (- (length sl) 1)))

(defun lfedoc-find-symbol-functions (symb)
  "Find symbol SYMB in known symbols and return the function names that return it."
  ;; example (lfedoc-find-symbol-functions  (quote car))
  (-reject 'null
           (-map (lambda (f) (when (-contains? (funcall f) symb) f))
                 (lfedoc-get-symbol-functions))))

;;; ----------------------------------------------------------------------------

(defun lfedoc-data-core-forms ()
  "Core forms."
  '(quote cons car cdr list tuple binary map map-get map-set map-update lambda
          match-lambda let let-function letrec-function let-macro progn if case receive
          catch try case catch when after funcall call define-module extend-module
          define-function define-macro type-test guard-bif))

(defun lfedoc-data-basic-macro-forms ()
  "Basic macro forms."
  ;; except (: mod fun) and (mod:fun)
  ;; ? and ++
  '(list* let* flet flet* fletrec cond andalso orelse fun fun lc list-comp
      bc binary-comp match-spec))

(defun lfedoc-data-common-lisp-inspired-macros ()
  "Common Lisp inspired macros."
  '(defun defmacro defsyntax macrolet syntaxlet prog1 prog2 defmodule defrecord))

(defun lfedoc-data-older-scheme-inspired-macros ()
  "Older scheme inspired macros."
  '(define define define-syntax let-syntax begin define-record))

(defun lfedoc-data-module-definition ()
  "Symbols used in module definition."
  '(defmodule export import))

(defun lfedoc-data-standard-operators ()
  "Standard operators."
  '(+ - * / > >= < =< == /= =:= =/=))

(defun lfedoc-data-predefined-lfe-functions ()
  "Predefined LFE functions."
  '(acons pairlis assoc assoc-if assoc-if-not rassoc rassoc-if rassoc-if-not
          subst subst-if subst-if-not sublis macroexpand-1 macroexpand
          macroexpand-all eval))

(defun lfedoc-data-supplemental-common-lisp-functions ()
  "Macros that closely mirror Hyperspec."
  ;; excluding make-lfe-bool, make-cl-bool and putf
  '(mapcar maplist mapc mapl symbol-plist symbol-name get get getl putprop
           remprop getf getf remf get-properties elt length reverse some every
           notany notevery reduce reduce reduce reduce remove remove-if
           remove-if-not remove-duplicates find find-if find-if-not
           find-duplicates position position-if position-if-not
           position-duplicates count count-if count-if-not count-duplicates car
           first cdr rest nth nthcdr last butlast subst subst-if subst-if-not
           sublis member member-if member-if-not adjoin union intersection
           set-difference set-exclusive-or subsetp acons pairlis pairlis assoc
           assoc-if assoc-if-not rassoc rassoc-if rassoc-if-not type-of coerce))

(defun lfedoc-data-common-lisp-predicates ()
  "Predefied predicates, equivalent of Erlang is_* function."
  '(alivep atomp binaryp bitstringp boolp booleanp builtinp floatp funcp
           functionp intp integerp listp mapp numberp pidp process-alive-p
           recordp recordp refp referencep tuplep))

(provide 'lfedoc)
;;; lfe-doc-finder.el ends here
