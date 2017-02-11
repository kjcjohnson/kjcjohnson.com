(asdf:defsystem #:kjcjohnson-site
  :serial t
  :description "A website devoted to Keith Johnson"
  :depends-on (#:hunchentoot
	       #:cl-who
	       #:postmodern
               #:ht-simple-ajax)
  :components ((:file "package")
	       (:module :src
			:serial t      
			:components ((:file "routes")
                                     (:file "template")
                                     (:file "heartbeat")
                                     (:file "index")))))

