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



(defparameter kjcjohnson-site::*menu-items* nil)
(push '( "/iraf" . "IRAF Tools") kjcjohnson-site::*menu-items*)
(push '( "/" . "Home" ) kjcjohnson-site::*menu-items*)

(defmacro create-typical-page (&key (title "Keith Johnson")
			            head
			            (header `((:h1 :id "header-title" ,title)))
			            content
			            footer
			            menu)
    		 
    `(cl-who:with-html-output-to-string (s)
       (:html
	(:head
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
		     ,@footer))))))


(hunchentoot:define-easy-handler (index :uri "/") ()

  (create-typical-page
   :title "Keith Johnson"
   :menu '(("his" . "hers"))
   :content ((:p "This website is mainly used for PaaS backend and other web-based endeavours. "
		 "Additionally, I also use it for sharing interesting code and files. "
		 "Currently, there are a set of convience scripts for installing IRAF on "
		 "x86 linux machines available. Hopefully, this site will be populated with "
		 "more front-end content soon."))
   :footer ((:p "Made proudly with Common Lisp, SBCL, and Hunchentoot.")
	    (:image :src "/static/lisplogo_alien.png"))))


(hunchentoot:define-easy-handler (iraf :uri "/iraf") ()

  (create-typical-page 
   :title "Keith's IRAF tools"
   :menu '(("sierra" . "jill"))
   :content ((:p "These are a collection of bash install scripts that ease "
		"the install process of IRAF and x11IRAF on x86 linux systems. "
		"Note: Run at your own risk.")
	     (:ul :class "irafitems"
		  (:li (:a :href "/iraf/files/install_iraf" "install_iraf") ": Installs IRAF's dependencies")
		  (:li (:a :href "/iraf/files/install_x11iraf" "install_x11iraf") ": Installs x11IRAF and ds9")))))