module Main

-- same as " `pkg-config --libs gtk+-3.0`
%flag C "-lgtk-3 -lgdk-3 -lpangocairo-1.0 -lpango-1.0 -latk-1.0 -lcairo-gobject -lcairo -lgdk_pixbuf-2.0 -lgio-2.0 -lgobject-2.0 -lglib-2.0"
%include C "myc.h"
%link C "myc.o"

myCallback : Int -> Int
myCallback a = a * 5

myMult     : Int -> Int -> IO Int
myMult x y = foreign FFI_C "myMult"
  (Int -> Int -> CFnPtr (Int -> Int) -> IO Int)
  x y (MkCFnPtr myCallback)

zzz : IO Int
zzz = foreign FFI_C "zzz"
  (IO Int)


main : IO ()
main = do
  r <- myMult 5 4
  putStrLn ("doubled " ++ (show r))
  s <- zzz
  putStrLn ("koniec with status " ++ (show s))
