This is the stub README.txt for the "TestAppWikipediaViewer" project.

To run the app app please type following in repl:

(push #p "/home/jacek/Programming/Pyrulis/Lisp/TestAppWikipediaViewer/" asdf:*central-registry*)
(ql:quickload :testappwikipediaviewer)
(in-package :testappwikipediaviewer)
(run)

To refresh the web content after editing the source run:
(ql:quickload :testappwikipediaviewer)

and see it on: http://localhost:5000/
