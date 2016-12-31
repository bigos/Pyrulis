;;; lfedoc --- Code for finding LFE documentation

;;; Commentary:

;;; This is supposed to make easier to look up documentation.
;;; To make it useful I need to study following file
;;; https://github.com/rvirding/lfe/blob/develop/doc/user_guide.txt

;;; Usage:

;;; Load this file by adding it in the load-path and running:
;;; (load "lfe-doc-finder.el")


;;; M-x lfedoc-helpme
;;; Will hopefully take you to a relevant page in Erlang documentation.

;;; M-x lfedoc-inspect
;;; Will print to the mini buffer the sexp at the cursor.

;;; Code:

(require 'browse-url)

(defun lfedoc-inspect ()
  "Print sexp."
  (interactive)
  (let ((sexp-str (sexp-at-point)))
    (princ sexp-str)))

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

;;; hopefully at some point I will be able to extract more info using
;;; (: lfe_scan tokens), or similar, but i need a way of passing text from Emacs to the lfe process

(defun lfedoc-helpme ()
  "Go to Erlang website for help."
  (interactive)
  ;; Read sanitised sexp and extract model and function for browse-url look-up
  (let ((call-struct (lfedoc-call-struct (read
                                          (lfedoc-sanitise
                                           (sexp-at-point))))))
    (if (car call-struct)
        (browse-url
         (apply 'format
                (cons "http://erlang.org/doc/man/%s.html#%s-%d"
                      call-struct)))
      (princ (list "search LFE specific documentation for"
                   'function (nth 1 call-struct)
                   'arity (nth 2 call-struct))))))

(defun lfedoc-call-struct (my-sexp)
  "Examine MY-SEXP and return a structure representing module function and arity."
  (cond ((lfedoc-new-erlang-callp my-sexp)
         (lfedoc-new-erlang-call-args my-sexp))
        ((lfedoc-old-erlang-callp my-sexp)
         (lfedoc-old-erlang-call-args my-sexp))
        (t (lfedoc-unknown-code my-sexp))))

(defun lfedoc-sanitise (str)
  "Sanitise the string STR for reading."
  ;; now lfedoc helpme does not trip over some lfe specific constructs

  ;; TODO: Elisp read might trip over other constructs, I need to find them
  (replace-regexp-in-string "#("        ;vector
                            " ("
                            (replace-regexp-in-string "#[BM](" ;binary string or map
                                                      "  ("
                                                      str)))

(defun lfedoc-new-erlang-callp (sl)
  "Check id the SL is the new Erlang call syntax."
  (eql (car sl) :))

(defun lfedoc-new-erlang-call-args (sl)
  "Get new Erlang call info for the documentation look-up list SL."
  (list (nth 1 sl) (nth 2 sl) (- (length sl) 3)))

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

(defun lfedoc-known-symbols ()
  "Collection of various kinds of predefined symbols."
  (let (
        (core-forms)
        (basic-macro-forms)
        (common-lisp-inspired-macros)
        (older-scheme-inspired-macros)
        (module-definition)
        (standard-operators)
        (predefined-lfe-functions)
        (supplemental-common-lisp-functions)
        (common-lisp-predicates)
        )
    ))

(defun lfedoc-find-symbol-functions (symb)
  "Find symbol SYMB in known symbols and return the function names that return it."
  ;; example (lfedoc-find-symbol-functions  (quote car))
  (let ((symbol-function-names '(lfedoc-data-core-forms
                                 lfedoc-data-basic-macro-forms
                                 lfedoc-data-common-lisp-inspired-macros
                                 lfedoc-data-older-scheme-inspired-macros
                                 lfedoc-data-module-definition
                                 lfedoc-data-standard-operators
                                 lfedoc-data-predefined-lfe-functions
                                 lfedoc-data-supplemental-common-lisp-functions
                                 lfedoc-data-common-lisp-predicates)))
    (-reject 'null
             (-map (lambda (f) (when (-contains? (funcall f) symb) f))
                   symbol-function-names))))

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
  '(defun defmacro defsyntax macrole syntaxlet prog1 prog2 defmodule defrecord))

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
