(defpackage verti
  (:use :cl))
(in-package :verti)

(defun describe-instance (inst)
  (cons (type-of inst)
        (loop for slot in (sb-mop:class-direct-slots (class-of inst))
              collect (list
                       (sb-mop:slot-definition-name slot)
                       (slot-value inst (sb-mop:slot-definition-name slot))))))

(defstruct vert
  (source)
  (action)
  (target))

(defparameter *col3*
  '(("a" "a2b" "b")
    ("b" "b2c" "c")
    ("c" "c2a" "a")))

;;; usage: (build-combinations '(a b c))
(defun build-combinations (comb)
  (loop for p in (let ((zebr))
                   (alexandria:map-combinations (lambda (x) (push x zebr))
                                                comb
                                                :length 2)
                   zebr)
        collect (mapcar #'string-downcase
                        (list
                         (format nil "~A" (nth 0 p))
                         (format nil "~A2~A" (nth 0 p) (nth 1 p))
                         (format nil "~A" (nth 1 p))))))

(defun build-vert (source action target)
  (make-vert :source source :action action :target target))

(defun build-vert-collection (collection)
  (loop for l in collection
        collect (apply #'build-vert l)))

;; (remove-node "a" (build-combinations '(a b c d)))
(defun remove-node (node collection)
  (let ((vc (build-vert-collection collection)))
    (let ((others (loop for l in vc
                        unless (or (equalp node (vert-source l))
                                   (equalp node (vert-target l)))
                          collect l)))
      (let ((sources (loop for e in others collect (vert-source e)))
            (targets (loop for e in others collect (vert-target e))))
        (let ((ns  (loop for e  in vc when (equalp node (vert-target e)) collect (vert-source e)))
              (nt (loop for e  in vc when (equalp node (vert-source e)) collect (vert-target e))))
          (list 'vc vc 'o others 's sources 't targets 'ns ns 'nt nt)))))
  '(TODO
    Add handling of different cases
    removing where ((both ends match node)
                    (one and matches node and the other end is menber of sources or targets))
    adjusting where (one end matches and the other is not in others)
    leaving where (both ends are in others)))

#|
(loop for n in split-and-parsed
      count (if (eq n 0)
                nil
                (zerop (mod parsed n)))
        into counted
      finally (return counted))
|#
