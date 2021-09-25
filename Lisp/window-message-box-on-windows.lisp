;; https://gist.github.com/RobBlackwell/5373163

(ql:quickload :cffi)

(cffi:load-foreign-library "user32.dll")

(cffi:defctype hwnd :unsigned-int)

(cffi:defcfun ("MessageBoxA" message-box) :int
  (wnd     hwnd)
  (text    :string)
  (caption :string)
  (type    :unsigned-int))

(message-box 0 "hello" "world" 0)


;; (load "c:/Users/Jacek/Documents/Programming/Pyrulis/Lisp/window-message-box-on-windows.lisp")
