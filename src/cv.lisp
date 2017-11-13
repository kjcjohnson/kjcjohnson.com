(in-package :kjcjohnson-site)

(hunchentoot:define-easy-handler (cv :uri "/cv") ()

  (create-typical-page
   :title "Keith's CV"
   :content ((:p "A very much DRAFT copy of my CV can be found "
                 (:a :href (b2link "/cv.pdf") "[here]")
                 ". It has not been grammer-, spelling-, or format-checked, "
                 "and does not represent the usual quality of my work."))))
