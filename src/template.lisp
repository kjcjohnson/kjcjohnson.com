;;
;; template.lisp
;;
(in-package :kjcjohnson-site)


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
    		 
    
    `(cl-who:with-html-output-to-string (s nil :prologue t :indent t)					
       (:html
	(:head
	 (:script :language "javascript" :type "text/javascript"
		  (if (null ,user-name)
		  (cl-who:htm "function loginRedirect() {
                      window.location = '/login?fromp='+window.document.URL;
                   }")

                   (cl-who:htm "function logoutRedirect() {
                      window.location = '/logout?fromp='+window.document.URL;
                   }"))) 
                      
	 ,(if jquery
	    `(:script :src "https://code.jquery.com/jquery-1.9.1.min.js"))
	 (:title ,title)
	 (:link :rel "stylesheet" :href "/static/default-style.css")
	 ,@head)
	(:body
	 (:div :id "wrapper"
	       (:div :id "header"
		     (:div :id "userinfo" (if (null ,user-name)
					       (cl-who:htm (:p :id "login-link" "Login")) 
					       (cl-who:htm (:p "Welcome, " (:p :id "login-link" (cl-who:str ,user-name))))))
		     ,@header)
	       (:div :id "navdiv"
		     (:ul :class "nav"
                          (with-menu-items (place name)
                            (cl-who:htm (:li (:a :href place (cl-who:str name)))))))
	       
	       (:div :id "content"
		     ,@content)
               (:div :class "push"))
         (:footer :id "footer"
                  (:hr :id "footer-top")
                  ,@footer
                  (:p "kjcjohnson.com made proudly with " 
                      (:a :href "http://common-lisp.net" :class "subtle-link" "Common Lisp") ", "
                      (:a :href "http://www.sbcl.org/" :class "subtle-link" "SBCL") ", and "
                      (:a :href "http://weitz.de/hunchentoot/" :class "subtle-link" "Hunchentoot") ".")
                  (:img :src "/static/lisplogo_alien.png"))
	 (:script :language "javascript" :type "text/javascript"
		  "$( '#login-link' ).on( 'click', function(e) {" 
                  (if (null ,user-name) (cl-who:htm "loginRedirect()") (cl-who:htm "logoutRedirect()"))"});")))))
