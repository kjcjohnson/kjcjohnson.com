;;;
;;; menu.lisp - defines functions/macros/constants for creating a site menu
;;;

(in-package :kjcjohnson-site)

;;
;; List of items to include in site menu
;;
(defparameter +menu-items+ nil)

;;
;; Stack of site menus
;;
(defparameter +menu-stack+ nil)

;;
;; Adds a new item to the end of the menu
;;
(defun add-menu-item (location name)
  (let ((revmenu (nreverse +menu-items+)))
    (push (cons location name) revmenu)
    (setf +menu-items+ (nreverse revmenu))))

;;
;; Resets the menu variable. Call before loading definitions.
;;
(defun reset-menu ()
  (setf +menu-items+ nil))

;;
;; Pushes the current menu to a stack
;;
(defun push-menu ()
  (push +menu-items+ +menu-stack+))

;;
;; Pops the current menu and restores the previous menu
;;
(defun pop-menu ()
  (setf +menu-items+ (pop +menu-stack+)))

;;
;; Iterates over all items in the menu in a loop environment
;;
(defmacro with-menu-items ((place-var name-var) &body body)
  `(loop for (,place-var . ,name-var) in +menu-items+ doing
        ,@body))
