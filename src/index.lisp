(in-package :kjcjohnson-site)

(asdf:oos 'asdf:load-op :ht-simple-ajax)


;; Handlers

(setf hunchentoot:*show-lisp-backtraces-p* t)

(hunchentoot:define-easy-handler (index :uri "/") ()
  

  (create-typical-page
   :title "Keith Johnson"
   :user-name (hunchentoot:session-value :username)
   :content ((:p "This website is mainly used for PaaS backend and other web-based endeavours. "
		 "Additionally, I also use it for sharing interesting code and files. "
		 "Currently, there are a set of convience scripts for installing IRAF on "
		 "x86 linux machines available. Hopefully, this site will be populated with "
		 "more front-end content soon."))))

(hunchentoot:define-easy-handler (music :uri "/music") ()

  (create-typical-page
   :title "Some Music of Mine"
   :content ((:p "These are a couple of pieces I wrote for U-M MusPerf 300, Video Game Music.")
	     (:ul :class "musicbullets"
		  (:li (:a :href "/music/waltz_themed.mp3" "Waltz Theme"))
		  (:li (:a :href "/music/walkinga.mp3"     "Walking Theme")))
             (:p "I recorded these with the SNsynth that I built.")
             (insert-fragment "cantina-band.frag")
             (insert-fragment "imperial-march.frag"))))

(hunchentoot:define-easy-handler (iraf :uri "/iraf") ()

  (create-typical-page 
   :title "Keith's IRAF tools"
   :content ((:p "These are a collection of bash install scripts that ease "
		"the install process of IRAF and x11IRAF on x86 linux systems. "
		"Note: Run at your own risk.")
	     (:ul :class "irafitems"
		  (:li (:a :href "/iraf/files/install_iraf" "install_iraf") ": Installs IRAF's dependencies")
		  (:li (:a :href "/iraf/files/install_x11iraf" "install_x11iraf") ": Installs x11IRAF and ds9")))))

(hunchentoot:define-easy-handler (blank-page :uri "/blank") ()

  (create-typical-page
   :jquery t
   :user-name (hunchentoot:session-value :username)
   :content ((:p))))

(hunchentoot:define-easy-handler (login :uri "/login") (fromp)

  (create-typical-page
   :title "Login"
   :content ((:p "This is a login page! fromp is " (cl-who:str fromp))
	     (:input :type "text" :id "username-field" :value "Username")
	     (:p :id "output")
	     (:button :type "button" :id "login-submit-button" "Login")
	     (:script :language "javascript" :type "text/javascript"
		      "$( '#login-submit-button' ).on( 'click', function(e) {
                          $.get( '/loginbackend', { username: $( '#username-field' ).val() },
                                                     function(msg) {
                                                        $( '#output' ).html( msg ); })});"))))

                         

(hunchentoot:define-easy-handler (logout :uri "/logout") (fromp)

  (hunchentoot:reset-sessions)
  (create-typical-page
   :title "Logout"
   :content ((:p "This is the logout page!"))))

(hunchentoot:define-easy-handler (spec-data :uri "/specdata") ()

  (create-typical-page
   :title "Astro 461 Spectroscopy Data"
   :content ((:p "These files have been removed for space reasons. Please contact me at kjcjohnson@ymail.com for access."))))     


(defparameter *ajax-processor*
  (make-instance 'ht-simple-ajax:ajax-processor :server-uri "/repl/process"))

(hunchentoot:define-easy-handler (loginbackend :uri "/loginbackend") (username)
  (handler-case (progn (hunchentoot:start-session)
		       (setf (hunchentoot:session-value :username) username)
		       (cl-who:with-html-output-to-string (s) (cl-who:str "Login Successful.")))
    (error (c) (cl-who:with-html-output-to-string (s) (format s "~a" c)))))

(hunchentoot:define-easy-handler (sessionmanager :uri "/sessionmanager") (command)
  (cond ((string= command "get-username") (if (null (nth-value 1 (hunchentoot:session-value :username))) ""
					      (hunchentoot:session-value :username)))
	(t "unknown")))

(ht-simple-ajax:defun-ajax repl-response (sexp) (*ajax-processor*)
			   (format nil "~a" (eval (read-from-string sexp))))

(push (ht-simple-ajax:create-ajax-dispatcher *ajax-processor*) hunchentoot:*dispatch-table*) 

(hunchentoot:define-easy-handler (repl-form :uri "/repl") ()

  (create-typical-page
   :jquery t
   :title "REPL for kjcjohnson.com"
   :head ((:script "function processREPL() {

                         

                     };")
	  (cl-who:str (format nil "~a" (ht-simple-ajax:generate-prologue *ajax-processor*)))
	  (:link :rel "stylesheet" :href "/static/REPL.css"))
   
   :content ((:p "Use this lisp REPL to change the website in real time! (LOL no)")
	     (:form
	      (:textarea :id "REPLHistory")
	      (:input :id "REPL")
	      (:script "$('#REPL').on('keydown', 
                          function(e){ 
                            if (e.which==13) {
                              processREPL();
                            }});" )))))
