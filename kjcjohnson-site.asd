(asdf:defsystem #:kjcjohnson-site
  :serial t
  :description "A website devoted to Keith Johnson"
  :depends-on (#:hunchentoot
	       #:cl-who
	       #:postmodern)
  :components ((:file "package")
	       (:module :src
			:serial t      
			:components ((:file "hello-world")))))

