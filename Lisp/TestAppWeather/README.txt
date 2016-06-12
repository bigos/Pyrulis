To run the weather app please type following in repl:

(push #p "/home/jacek/Programming/Pyrulis/Lisp/TestAppWeather/" asdf:*central-registry*)
(ql:quickload :test-app-weather)
(in-package :test-app-weather)
(run)

To refresh the web content after editing the source run:
(ql:quickload :test-app-weather)

and see it on: http://localhost:5000/
