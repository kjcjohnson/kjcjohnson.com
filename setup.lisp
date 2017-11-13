(in-package :kjcjohnson-site)

(defun start (&key port)
  (hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port port)))

(defun setup-environment ()
  (format t "Setting up environment...~%")
  (envadd :wwwroot)
  (envadd :fragment-directory)
  (envadd :b2-root))

(setup-environment)

(setf (cl-who:html-mode) :HTML5)
