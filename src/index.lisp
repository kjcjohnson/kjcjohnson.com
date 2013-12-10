(in-package :kjcjohnson-site)

(asdf:oos 'asdf:load-op :ht-simple-ajax)

;;Look into wuwei

;; Utils
(defun heroku-getenv (target)
  #+ccl (ccl:getenv target)
  #+sbcl (sb-posix:getenv target))

(defun heroku-slug-dir ()
  (heroku-getenv "HOME"))

(defun db-params ()
  "Heroku database url format is postgres://username:password@host:port/database_name.
TODO: cleanup code."
  (let* ((url (second (cl-ppcre:split "//" (heroku-getenv "DATABASE_URL"))))
	 (user (first (cl-ppcre:split ":" (first (cl-ppcre:split "@" url)))))
	 (password (second (cl-ppcre:split ":" (first (cl-ppcre:split "@" url)))))
	 (host (first (cl-ppcre:split ":" (first (cl-ppcre:split "/" (second (cl-ppcre:split "@" url)))))))
	 (database (second (cl-ppcre:split "/" (second (cl-ppcre:split "@" url))))))
    (list database user password host)))

;; Handlers

(push (hunchentoot:create-folder-dispatcher-and-handler "/static/" 
      (concatenate 'string (heroku-slug-dir) "/public/")) hunchentoot:*dispatch-table*)

(push (hunchentoot:create-static-file-dispatcher-and-handler "/default-style.css" 
      (concatenate 'string (heroku-slug-dir) "/public/default-style.css")) hunchentoot:*dispatch-table*)

(push (hunchentoot:create-folder-dispatcher-and-handler "/iraf/files/"
      (concatenate 'string (heroku-slug-dir) "/public/iraf/")) hunchentoot:*dispatch-table*)

(push (hunchentoot:create-folder-dispatcher-and-handler "/461data/"
      (concatenate 'string (heroku-slug-dir) "/public/461data/")) hunchentoot:*dispatch-table*)

(push (hunchentoot:create-folder-dispatcher-and-handler "/music/"
      (concatenate 'string (heroku-slug-dir) "/public/music/")) hunchentoot:*dispatch-table*)


(defparameter kjcjohnson-site::*menu-items* nil)
(setf hunchentoot:*show-lisp-backtraces-p* t)

(defun add-menu-item (location name)
  (let ((revmenu (nreverse kjcjohnson-site::*menu-items*)))
    (push (cons location name) revmenu)
    (setf kjcjohnson-site::*menu-items* (nreverse revmenu))))

(add-menu-item "/" "Home" )
(add-menu-item "/blank" "Blank Page" )
(add-menu-item "/iraf" "IRAF Tools" )
(add-menu-item "/music" "Music")

(defmacro defjsfun (name arglist &rest body)

  `(defmacro ,(intern (format nil "jsfunc-~a" name)) ,(cons 'stream arglist)
     `(cl-who:with-html-output ,(list stream)
	(:script :language "javascript" :type "text/javascript" 
		 ,(format nil "function ~a {" ,name)
		 ,@(loop for el in ,body collecting
		     (symbol-name el))
		 "}"))))
									

(defmacro create-typical-page (&key (title "Keith Johnson")
			            head
			            (header `((:h1 :id "header-title" ,title)))
			            content
			            footer
			            (user-name `(hunchentoot:session-value :username)) 
			            (jquery t))
    		 
    
    `(cl-who:with-html-output-to-string (s)
       (:html
	(:head
	 (:script :language "javascript" :type "text/javascript"
		  ,(if (null user-name)
		  "function loginRedirect() {
                      window.location = '/login?fromp='+window.document.URL;
                   }"

                   "function logoutRedirect() {
                      window.location = '/logout?fromp='+window.document.URL;
                   }"))    
                      
	 ,(if jquery
	    `(:script :src "http://code.jquery.com/jquery-1.9.1.min.js"))
	 (:title ,title)
	 (:link :rel "stylesheet" :href "/static/default-style.css")
	 ,@head)
	(:body
	 (:div :id "wrapper"
	       (:div :id "header"
		     (:div :id "userinfo" ,(if (null user-name)
					       '(:p :id "login-link" "Login") 
					       `(:p "Welcome, " (:p :id "login-link" ,user-name))))
		     ,@header)
	       (:div :id "navdiv"
		     (:ul :class "nav"
			 (loop for ( place .  name ) in *menu-items* doing
			      (cl-who:htm (:li (:a :href place (cl-who:str name)))))))
	       
	       (:div :id "content"
		     ,@content)
	       (:div :id "footer"
		     (:hr :id "footer-top")
		     ,@footer
		     (:p "kjcjohnson.com made proudly with " 
                       (:a :href "http://common-lisp.net" :class "subtle-link" "Common Lisp") ", "
		       (:a :href "http://www.sbcl.org/" :class "subtle-link" "SBCL") ", and "
		       (:a :href "http://weitz.de/hunchentoot/" :class "subtle-link" "Hunchentoot") ".")
		     (:image :src "/static/lisplogo_alien.png")))
	 (:script :language "javascript" :type "text/javascript"
		  "$( '#login-link' ).on( 'click', function(e) {" ,(if (null user-name) "loginRedirect()" "logoutRedirect()")"});")))))


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
		  (:li (:a :href "/music/walkinga.mp3"     "Walking Theme"))))))

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

                         ajax_repl_response( $('#REPL').val(),
                                 function( respn ) {
                                   text = $('#REPLHistory').val()
                                   $('#REPLHistory').val(text + respn)
                                 });

                     };")
	  (cl-who:str (format nil "~a" (ht-simple-ajax:generate-prologue *ajax-processor*)))
	  (:link :rel "stylesheet" :href "/static/REPL.css"))
   
   :content ((:p "Use this lisp REPL to change the website in real time!")
	     (:form
	      (:textarea :id "REPLHistory")
	      (:input :id "REPL")
	      (:script "$('#REPL').on('keydown', 
                          function(e){ 
                            if (e.which==13) {
                              processREPL();
                            }});" )))))
