(load #p"/usr/share/common-lisp/source/asdf/asdf")
(push #p"/usr/share/common-lisp/systems/" asdf:*central-registry*)

(defparameter *history-file* "/home/watashi/.clisp_history")
(defparameter *history-size* 1024)
(readline:read-history *history-file*)
(push (lambda ()
        (readline:append-history *history-size* *history-file*)
        (readline:history-truncate-file *history-file* *history-size*)) *fini-hooks*)

