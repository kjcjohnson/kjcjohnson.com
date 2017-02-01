(ql:quickload :hunchentoot)
(ql:quickload :ht-simple-ajax)
(ql:quickload :postmodern)

(load "kjcjohnson-site.asd")

(ql:quickload :kjcjohnson-site)

(hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port 8080 ))

