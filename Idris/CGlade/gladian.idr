module Main

-- %include C "/home/jacek/Programming/Pyrulis/Idris/CGlade/gladian.h"
--%link C "/home/jacek/Programming/Pyrulis/Idris/CGlade/builddir/gladian@exe/gladian.c.o"

%dynamic "/home/jacek/Programming/Pyrulis/Idris/CGlade/builddir/libgladian.so"

gui_main : Int -> String -> IO ()
gui_main a c = foreign FFI_C "foo" (Int -> String -> IO ()) a c

main : IO ()
main = do
  gui_main 1 "1"
