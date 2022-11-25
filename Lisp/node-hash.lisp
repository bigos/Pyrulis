;; (load "~/Programming/Pyrulis/Lisp/node-hash.lisp")

(defstruct node
  name
  parent
  hash)

(defun make-hash-table-for-node ()
  (make-hash-table :test #'equal))

(defun create-root-node ()
  (make-node :parent nil :name 'root :hash (make-hash-table-for-node)))

(defun add-child-node (parent-node name)
  (unless (eq 'node (type-of parent-node))
    (error "parent node is a ~S but we expected node" (type-of parent-node)))
  (setf (gethash name
                 (node-hash parent-node))
        (make-node :parent parent-node :name name :hash (make-hash-table-for-node))))

(defun ensure-child-nodes (parent-node names)
  (if (null names)
      parent-node
      (let ((next-one (gethash (car names) (node-hash parent-node))))
        (cond
          ((null next-one)
           (warn "null next=one ~S" names)
           (add-child-node parent-node (first names))
           (ensure-child-nodes (gethash (first names) (node-hash parent-node)) (rest names)))
          ((eq 'node (type-of next-one))
           (warn "next node detected ~S" names)
           (ensure-child-nodes next-one (rest names)))
          (T (error "we expected node ~S" parent-node))))))

(defun set-child-nodes (parent-node names key value)
  (setf
   (gethash key (node-hash (ensure-child-nodes parent-node names)))
   value))

(defun get-child-nodes (parent-node names key)
  (gethash key (node-hash (ensure-child-nodes parent-node names))))

(defun node-path (node &optional acc)
  (if (null node)
      acc
      (node-path (node-parent node)
                 (cons (node-name node)
                       acc))))
