(in-package :kjcjohnson-site)

(hunchentoot:define-easy-handler (art :uri "/art") ()

  (create-typical-page
   :title "\"Art\" and Galleries"
   :content ((:p "Various \"artwork\" still under construction")
             (:h3 "Backstory")
             (insert-fragment "art/backstory.frag"))))
 
