(in-package :kjcjohnson-site)

(hunchentoot:define-easy-handler (music :uri "/music") ()

  (create-typical-page
   :title "Some Music of Mine"
   :content ((:p "These are a couple of pieces I wrote for U-M MusPerf 300, Video Game Music.")
	     (:ul :class "musicbullets"
		  (:li (:a :href "/music/waltz_themed.mp3" "Waltz Theme"))
		  (:li (:a :href "/music/walkinga.mp3"     "Walking Theme")))
             (:hr)
             (:p "I recorded these with the SNsynth that I built.")
             (insert-fragment "cantina-band.frag")
             (insert-fragment "imperial-march.frag"))))

