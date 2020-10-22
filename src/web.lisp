(in-package :cl-user)
(defpackage love_lisp.web
  (:use :cl
        :caveman2
        :love_lisp.config
        :love_lisp.view
        :love_lisp.db
        :datafly
        :sxql)
  (:export :*web*))
(in-package :love_lisp.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;;
;; Routing rules

(defroute "/" ()
  (render-people))

(defroute ("/increment" :method :GET ) ()
  (increment-person)
  (render-people))

(defroute ("/decrement" :method :GET) ()
  (decrement-person)
  (render-people))

;;
;; Error pages

;;
;; Render

(defun render-people ()
  (render #P"index.html" `(:numbers ,(send-data))))

(defun send-data ()
  (with-connection (db)
    (retrieve-all
      (select :* (from :person)))))

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))

(defun increment-person ()
  (with-connection (db)
    (let ((num (retrieve-one (select :number
                               (from :person)
                               (where (:= :id 1))))) ) 
      (execute
        (update :person
          (set= :number (1+ (cadr num)))
          (where (:= :id 1))))  )))

(defun decrement-person ()
  (with-connection (db)
    (let ((num (retrieve-one (select :number
                               (from :person)
                               (where (:= :id 1))))) ) 
      (format t "うんこ ~d" 256)
      (format t " ~d" (cadr num ) )
      (execute
        (update :person
          (set= :number (1- (cadr num )))
          (where (:= :id 1))))  )))
