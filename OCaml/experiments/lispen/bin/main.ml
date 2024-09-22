let skip name = Printf.printf "skipping %s" name

let printHeader name =
  Printf.printf "\n--- %s -------------------------------\n\n" name

let compileEmacs () =
  print_endline "compile Emscs" ;
  Sys.command "make; sudo make install"

let compileSBCL () =
  print_endline "compile SBCL" ;
  Sys.command "sh./clean.sh; sh /make.sh; sudo sh ./install "

let doEmacs () =
  printHeader "Emacs" ;
  Sys.chdir "/home/jacek/Programming/emacs-31" ;
  let _ = Sys.command "git pull; echo 'pulled Emacs'" in
  Printf.printf "Should I compile Emacs? Please enter your choice Y/n > " ;
  let rl = Stdlib.read_line () |> String.trim in
  if rl = "Y" then compileEmacs ()
  else if rl = "y" then compileEmacs ()
  else skip "Emacs"

let doSBCL () =
  printHeader "SBCL" ;
  Sys.chdir "/home/jacek/Programming/sbcl" ;
  let _ = Sys.command "git pull; echo 'pulled SBCL'" in
  Printf.printf "Should I compile SBCL? Please enter your choice Y/n > " ;
  let rls = Stdlib.read_line () |> String.trim in
  if rls = "Y" then compileSBCL ()
  else if rls = "y" then compileSBCL ()
  else skip "SBCL" ;
  Printf.printf "\n"

let main () = doEmacs () ; doSBCL ()

let () = main ()
