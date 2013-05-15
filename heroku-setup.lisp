(in-package :cl-user)

(print ">>> Building system....")

(load (merge-pathnames "kjcjohnson-site.asd" *build-dir*))

(ql:quickload :ht-simple-ajax)
(ql:quickload :kjcjohnson-site)

;;; Redefine / extend heroku-toplevel here if necessary.

(print ">>> Done building system")
