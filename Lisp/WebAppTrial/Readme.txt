To run web app trial please type following in repl:

(push #p "/home/jacek/Programming/Pyrulis/Lisp/WebAppTrial/" asdf:*central-registry*)
(ql:quickload :web-app-trial)
(in-package :web-app-trial)
(run)

To refresh the web content after editing the source run:
(ql:quickload :web-app-trial)
