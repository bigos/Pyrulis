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

(defun remove-node (node collection &optional (acc) (singles))
  (if (null collection)
      (progn
        (let ((sns (loop for ln in acc collect (vert-source ln)))
              (tns (loop for ln in acc collect (vert-target ln))))
          (concatenate 'list
                       acc
                       (remove-if #'null
                                  (mapcar (lambda (x)
                                            (when (not (or (member x sns :test #'equalp)
                                                           (member x tns :test #'equalp)))
                                              (build-vert x "" nil)))
                                          (remove-duplicates singles :test #'equalp))))))
      (let ((l (car collection))
            (new-acc acc)
            (new-singles singles))
        (cond
          ((and (not (equalp (vert-source l) node))
                (not (equalp (vert-target l) node)))
           (setf new-acc (cons l acc)))

          ((and (equalp (vert-source l) node)
                (equalp (vert-target l) node))
           (setf #| skipped for both ends matching |#))

          ((and (equalp (vert-source l) node)
                (not (equalp (vert-target l) node)))
           (setf new-singles (cons (vert-target l) singles)))

          ((and (not (equalp (vert-source l) node))
                (equalp (vert-target l) node))
           (setf new-singles (cons (vert-source l) singles)))
          (t
           (error "we should not end here with ~A" l)))
        (remove-node node (cdr collection) new-acc new-singles))))


(remove-node "a"
             (build-vert-collection '(("a" "a2a" "a")
                                      ("a" "a2b" "b")
                                      ("b" "b2a" "a")
                                      ("c" "c2b" "b")
                                      )))

(remove-node "a"
             (build-vert-collection '(("a" "a2a" "a")
                                      ("a" "a2b" "b")
                                      ("b" "b2a" "a")
                                      ("c" "c2b" "b")
                                      )))
