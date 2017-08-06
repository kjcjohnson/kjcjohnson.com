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
