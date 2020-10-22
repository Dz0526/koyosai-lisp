(defsystem "love_lisp-test"
  :defsystem-depends-on ("prove-asdf")
  :author "ito"
  :license ""
  :depends-on ("love_lisp"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "love_lisp"))))
  :description "Test system for love_lisp"
  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
