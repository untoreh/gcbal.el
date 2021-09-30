(cl-defun my/genlist
    (&optional (n 4096)
               (fgen (lambda () 0)))
  " Generates a list of length N with values returned by FGEN"
  (let ((l (list)))
    (dotimes (_ n) (push (funcall fgen) l))
    l))

(cl-defun my/genvector
    (&optional (n 4096)
               (fgen (lambda () 0)))
  " Generates a vector of length N with values returned by FGEN"
  (let ((vec (make-vector n nil)))
    (dotimes (i n)
      (setf (seq-elt vec i) (funcall fgen)))
  vec
  ))

(cl-defun my/garbage-list (&optional (depth-1 64) (depth-2 32) (raw nil))
  " Generate a list of length DEPTH-1 of lists of length DEPTH-2 "
  (let* ((max-lisp-eval-depth most-positive-fixnum)
         (max-specpdl-size most-positive-fixnum)
         (fgen-2 (lambda () (cl-copy-list (my/genlist depth-2))))
         (fgen-1 (lambda () (cl-copy-list (my/genlist depth-2 fgen-2))))
         (l (my/genlist depth-1 fgen-1))
         (size (caliper-object-size l))
         )
    (if raw
        size
     (file-size-human-readable size) )))

(cl-defun my/garbage-vect (&optional (depth-1 64) (depth-2 44) (raw nil))
  " Generate a vector of length DEPTH-1 of vectors of length DEPTH-2 "
  (let* ((max-lisp-eval-depth most-positive-fixnum)
         (max-specpdl-size most-positive-fixnum)
         (fgen-2 (lambda () (cl-copy-seq (my/genvector depth-2))))
         (fgen-1 (lambda () (cl-copy-seq (my/genvector depth-2 fgen-2))))
         (l (my/genvector depth-1 fgen-1))
         (size (caliper-object-size l)))
    (if raw
        size
      (file-size-human-readable size))))

(cl-defun my/gc-bench(fn &optional (times 3))
  (garbage-collect)
  (first (last (benchmark-call
   (lambda () (funcall fn)
     (garbage-collect)
     ) times))))
