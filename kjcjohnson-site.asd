(asdf:defsystem #:kjcjohnson-site
  :serial t
  :description "A website devoted to Keith Johnson"
  :depends-on (#:hunchentoot
	       #:cl-who
	       #:postmodern
               #:ht-simple-ajax
               #:uiop
               #:cl-ppcre)
  :components ((:file "package")
               (:module :framework
                        :serial t
                        :components ((:file "utility")
                                     (:file "environment")))
               (:file "setup")
	       (:module :src
			:serial t      
			:components ((:file "routes")
                                     (:file "template")
                                     (:file "heartbeat")
                                     (:file "index")))))

