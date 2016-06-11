To run web app trial please type following in repl:

(push #p "/home/jacek/Programming/Pyrulis/Lisp/QuoteMachine/" asdf:*central-registry*)
(ql:quickload :quote-machine)
(in-package :quote-machine)
(run)

To refresh the web content after editing the source run:
(ql:quickload :quote-machine)
