;;;
;;; environment.lisp - defines functions/macros for interacting with web app's environment
;;;
;;;   This includes the program environment as well as the OS environment.
;;;

(in-package :kjcjohnson-site)

;;
;; The internal environment of the program. Does not get refreshed on reload.
;;
(defvar +environment+ nil "The internal environment of the program")

(defun key-to-os-env-key (key)
  "Converts a keyword to the equivalent OS environment variable name."
  (cl-ppcre:regex-replace-all "-"
                              (concatenate 'string
                                            "KJCJOHNSON_SITE_"
                                            (symbol-name key))
                              "_"))

;;
;; Adds a key from the OS environment to the local environment
;; Keys in the environment are of the form KJCJOHNSON_SITE_KEY,
;;   where KEY is capitalized and has all hyphens changed to underscores
;;
(defmacro envadd (key)
  "Adds the specified key to the internal environment from the OS environment"
  `(pusha ,key 
          (uiop:getenvp 
           (key-to-os-env-key ,key))
          +environment+))

;;
;; Retuns a key from the internal environment
;;
(defmacro envget (key)
  "Returns the specified key from the internal environment. Returns NIL if key does not exist."
  `(cdr (assoc ,key +environment+)))

;;
;; Sets a key in the internal environment. Updates an existing key if it exists, or adds a new one.
;;
(defmacro envset (key val)
  "Sets (adds or updates) the specified key in the internal environment."
  (let ((assoc-cons (gensym)))
    `(let ((,assoc-cons (assoc ,key +environment+)))
       (if (consp ,assoc-cons)
           (rplacd ,assoc-cons ,val)
           (pusha ,key ,value +environment+)))))

;;;
;;; Updates a key in the internal environment from the OS environment
;;; Adds the key if it doesn't exist.
;;;
(defmacro envupd (key)
  "Updates a key from the OS environment. Adds if key does not yet exist."
  `(envset ,key (uiop:getenvp (key-to-os-env-key ,key))))
