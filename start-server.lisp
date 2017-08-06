
;; Check if quicklisp is available. If not, load the file
#-quicklisp (load "quicklisp.lisp")

(ql:quickload :hunchentoot)
(ql:quickload :ht-simple-ajax)
(ql:quickload :postmodern)
(ql:quickload :uiop)
(ql:quickload :cl-ppcre)

(load "kjcjohnson-site.asd")

(ql:quickload :kjcjohnson-site)

(kjcjohnson-site:start :port 8080)
