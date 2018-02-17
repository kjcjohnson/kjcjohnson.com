;;;
;;; utility.lisp - defines various utilities to be used throughout the app
;;;

(in-package :kjcjohnson-site)

;;
;; Pushes the given key-value pair to the front of the given alist
;;
(defmacro pusha (key value alist)
  "Pushes the given key and value to the front of the given alist."
  `(setf ,alist (acons ,key ,value ,alist)))

;;
;; Inserts the given view fragment in a cl-who block
;;
'(defmacro insert-fragment (pname)
  (let ((frag (gensym))
        (fstream (gensym)))
    `(with-open-file (,fstream (concatenate 'string (envget :fragment-directory) ,pname))
       (let ((,frag (make-string (file-length ,fstream))))
         (read-sequence ,frag ,fstream)
         (cl-who:str ,frag)))))

(defun preprocess-fragment (frag)
  (cl-ppcre:regex-replace-all "---" frag "&mdash;"))


(defmacro insert-fragment (pname)
  (let ((frag (gensym))
        (fstream (gensym))
        (fragpath (gensym)))
    `(let ((,fragpath (concatenate 'string (envget :fragment-directory) ,pname)))
       (progn
         (format t "Got frag path: ~a~%" ,fragpath) 
         (with-open-file (,fstream ,fragpath)
           (let ((,frag (make-string (file-length ,fstream))))
             (read-sequence ,frag ,fstream)
             (cl-who:str (preprocess-fragment ,frag))))))))

