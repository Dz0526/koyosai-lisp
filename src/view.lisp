(in-package :cl-user)
(defpackage love_lisp.view
  (:use :cl)
  (:import-from :love_lisp.config
                :*template-directory*)
  (:import-from :caveman2
                :*response*
                :response-headers)
  (:import-from :djula
                :add-template-directory
                :compile-template*
                :render-template*
                :*djula-execute-package*)
  (:import-from :datafly
                :encode-json)
  (:export :render
           :render-json))
(in-package :love_lisp.view)

(djula:add-template-directory *template-directory*)

(defparameter *template-registry* (make-hash-table :test 'equal))

(defun render (template-path &optional env)
  (let ((template (gethash template-path *template-registry*)))
    (unless template
      (setf template (djula:compile-template* (princ-to-string template-path)))
      (setf (gethash template-path *template-registry*) template))
    (apply #'djula:render-template*
           template nil
           env)))

(defun render-json (object)
  (setf (getf (response-headers *response*) :content-type) "application/json")
  (setf (getf (response-headers *response*) :Access-Control-Allow-Origin) "*")
  (setf (getf (response-headers *response*) :Access-Control-Allow-Methods) "GET, POST, PUT, DELETE")
  (setf (getf (response-headers *response*) :Access-Control-Allow-Headers) "Origin, Authorization, Accept, Content-Type")
  (print *response*)
  (encode-json object))


;;
;; Execute package definition

(defpackage love_lisp.djula
  (:use :cl)
  (:import-from :love_lisp.config
                :config
                :appenv
                :developmentp
                :productionp)
  (:import-from :caveman2
                :url-for))

(setf djula:*djula-execute-package* (find-package :love_lisp.djula))
