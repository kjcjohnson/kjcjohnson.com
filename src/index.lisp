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

(push (hunchentoot:create-folder-dispatcher-and-handler "/iraf/"
      (concatenate 'string (heroku-slug-dir) "public/iraf/")) hunchentoot:*dispatch-table*)

(hunchentoot:define-easy-handler (index :uri "/") ()
  (cl-who:with-html-output-to-string (s)
    (:html
     (:head
      (:title "Keith Johnson")
      (:link :rel "stylesheet" :href "/static/default-style.css"))
     (:body
      (:div :id "wrapper"
	    (:h1 :id "title" "Keith Johnson")
	    (:ul :class "nav"
		 (:li 
		  (:a :href "/iraf/#" "IRAF Tools"))))))))

(hunchentoot:define-easy-handler (iraf :uri "/iraf/#") ()
  (cl-who:with-html-output-to-string (s)
    (:html
     (:head
      (:title "Keith Johnson's IRAF tools")
      (:link :rel "stylesheet" :href "/static/default-style.css"))
     (:body
      (:div :id "wrapper"
	    (:h1 :id "title" "Useful IRAF tools")
	    (:ul :class "nav"
		 (:li
		  (:a :href "/" "Home")))
	    (:p "These are a collection of bash install scripts that ease the process of installing IRAF, x11IRAF, and its dependencies. Note: run at your own risk.")
	    (:ul :class "irafitems"
		 (:li (:a :href "/iraf/install_iraf" "install_iraf") "Installs IRAF's dependencies")
		 (:li (:a :href "/iraf/install_x11iraf" "install_x11iraf") "Installs x11IRAF and ds9")))))))