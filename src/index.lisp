(in-package :kjcjohnson-site)

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


(defparameter kjcjohnson-site::*menu-items* nil)

(defun add-menu-item (location name)
  (let ((revmenu (nreverse kjcjohnson-site::*menu-items*)))
    (push (cons location name) revmenu)
    (setf kjcjohnson-site::*menu-items* revmenu)))

(add-menu-item "/" "Home" )
(add-menu-item "/blank" "Blank Page" )
(add-menu-item "/iraf" "IRAF Tools" )

(defmacro create-typical-page (&key (title "Keith Johnson")
			            head
			            (header `((:h1 :id "header-title" ,title)))
			            content
			            footer
			            (jquery nil))
    		 
    `(cl-who:with-html-output-to-string (s)
       (:html
	(:head
	 ,(if jquery
	    `(:script :src "http://code.jquery.com/jquery-1.9.1.js"))
	 (:title ,title)
	 (:link :rel "stylesheet" :href "/static/default-style.css")
	 ,@head)
	(:body
	 (:div :id "wrapper"
	       (:div :id "header"
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
		     (:p "kjcjohnson.com made proudly with Common Lisp, SBCL, and Hunchentoot.")
		     (:image :src "/static/lisplogo_alien.png")))))))


(hunchentoot:define-easy-handler (index :uri "/") ()

  (create-typical-page
   :title "Keith Johnson"
   :content ((:p "This website is mainly used for PaaS backend and other web-based endeavours. "
		 "Additionally, I also use it for sharing interesting code and files. "
		 "Currently, there are a set of convience scripts for installing IRAF on "
		 "x86 linux machines available. Hopefully, this site will be populated with "
		 "more front-end content soon."))))


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
   :content ((:p))))

(hunchentoot:define-easy-handler (spec-data :uri "/specdata") ()

  (create-typical-page
   :title "Astro 461 Spectroscopy Data"
   :content ((:p "Here are the files from the three nights, in .zip archives.")
	     (:ul (:li (:a :href "/461data/may10.zip" "May 10"))
		  (:li (:a :href "/461data/may11.zip" "May 11"))
		  (:li (:a :href "/461data/may12.zip" "May 12"))))))

(hunchentoot:define-easy-handler (repl-form :uri "/repl") ()

  (create-typical-page
   :jquery t
   :title "REPL for kjcjohnson.com"
   :head ((:script "function processREPL() {

                         $.post( '/repl/process',
                                 {sexp:$('#REPL').value()},
                                 function( data, status ) {
                                   text = $('#REPLHistory').val()
                                   $('#REPLHistory').val(text + data)
                                 });

                     };")
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

(hunchentoot:define-easy-handler (repl-process :uri "/repl/process") (sexp)

  (if (string= sexp "") (format nil "Null String")
      (handler-case 
	  (format nil (eval (read-from-string sexp)))
	(t (e) (format nil "ERROR! in (format (eval (read))): ~a" e)))))