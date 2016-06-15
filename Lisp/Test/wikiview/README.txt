To run web app trial please type following in repl:

(push "/home/jacek/Programming/Pyrulis/Lisp/Test/wikiview/" asdf:*central-registry*)
(ql:quickload "wikiview")
(wikiview:run)


To refresh the web content after editing the source run:
(ql:quickload :wikiview)

and see it on: http://localhost:5000/
