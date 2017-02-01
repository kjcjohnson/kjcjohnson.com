;;;
;;; Routes.lisp
;;;
(in-package :kjcjohnson-site)


(defmacro site-root () "/home/keith/kjcjohnson.com/kjcjohnson-site")

(push (hunchentoot:create-folder-dispatcher-and-handler "/static/" 
      (concatenate 'string (site-root) "/public/")) hunchentoot:*dispatch-table*)

(push (hunchentoot:create-static-file-dispatcher-and-handler "/default-style.css" 
      (concatenate 'string (site-root) "/public/default-style.css")) hunchentoot:*dispatch-table*)

(push (hunchentoot:create-folder-dispatcher-and-handler "/iraf/files/"
      (concatenate 'string (site-root) "/public/iraf/")) hunchentoot:*dispatch-table*)

(push (hunchentoot:create-folder-dispatcher-and-handler "/461data/"
      (concatenate 'string (site-root) "/public/461data/")) hunchentoot:*dispatch-table*)

(push (hunchentoot:create-folder-dispatcher-and-handler "/music/"
      (concatenate 'string (site-root) "/public/music/")) hunchentoot:*dispatch-table*)
