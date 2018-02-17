(in-package :kjcjohnson-site)

(hunchentoot:define-easy-handler (music :uri "/music") ()

  (create-typical-page
   :title "Some Music of Mine"
   :content ((:p "These are a couple of pieces I wrote for U-M MusPerf 300, Video Game Music.")
	     (:ul :class "musicbullets"
		  (:li (:a :href "/music/waltz_themed.mp3" "Waltz Theme")
                       (:blockquote 
                        (:p "I imagine this first piece to be the background "
                            "music to some sort of puzzle game set in a "
                            "castle, which seems ordinary at first but "
                            "has some...quirks. "
                            "It is majestic and thematic, and everything seems "
                            "to be going as usual until the quirky court "
                            "jester-turned-wizard has some innocent "
                            "(or sometimes malevolent) fun." )))
		  (:li (:a :href "/music/walkinga.mp3"     "Walking Theme")
                       (:blockquote
                        (:p "The second piece is music that could be heard "
                            "while walking through some sort of barren, desert "
                            "wasteland early in the morning. Mirages pop up, "
                            "sometimes shimmering and disappearing "
                            "immediately, and others linger for some time. "
                            "Occasionally, a small sand storm may blow by, or "
                            "an animal could run by, but the majority of the "
                            "landscape is minimalistic and static." ))))
             (:hr)
             (:p "I recorded these with the SNsynth that I built.")
             (insert-fragment "cantina-band.frag")
             (insert-fragment "imperial-march.frag"))))

