(in-package :kjcjohnson-site)

(hunchentoot:define-easy-handler (projects :uri "/projects") ()

  (create-typical-page
   :title "Projects and Constructions"
   :content ((:p "Various projects still under construction"))))
 
