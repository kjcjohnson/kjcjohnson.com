(in-package :kjcjohnson-site)

;;
;; Reset so a reload clears the menu list
;;
(reset-menu)

;;
;; Site-wide menu definitions
;;
(add-menu-item "/" "Home" )
(add-menu-item "/blank" "Blank Page" )
;; (add-menu-item "/iraf" "IRAF Tools" )
;; Deprecated Oct. 25, 2017 - IRAF installation is much better now
(add-menu-item "/projects" "Projects")
(add-menu-item "/music" "Music")
(add-menu-item "/art" "\"Art\"")
