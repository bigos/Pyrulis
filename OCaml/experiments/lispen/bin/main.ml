(* why the command output is in the wrong order? *)

let skip name =
  let _ = Sys.command "echo 'skipped'" in
  Printf.printf "skipping %s" name

let printHeader name =
  Printf.printf "\n--- %s -------------------------------\n\n" name

let compileEmacs () =
  Printf.printf "compile Emacs" ;
  let _ = Sys.command "make; sudo make install" in
  Printf.printf "done"

let compileSBCL () =
  Printf.printf "compile SBCL" ;
  let _ = Sys.command "sh ./distclean.sh; sh ./make.sh; sudo sh ./install.sh" in
  Printf.printf "done"

let doEmacs () =
  printHeader "Emacs" ;
  Sys.chdir "/home/jacek/Programming/emacs-31" ;
  let _ = Sys.command "git pull; echo 'pulled Emacs'" in
  Printf.printf "Should I compile Emacs? Please enter your choice Y/n > " ;
  let rl = Stdlib.read_line () |> String.trim in
  if rl = "Y" || rl = "y" then compileEmacs () else skip "Emacs"

let doSbcl () =
  printHeader "SBCL" ;
  Sys.chdir "/home/jacek/Programming/sbcl" ;
  let _ = Sys.command "git pull; echo 'pulled SBCL'" in
  Printf.printf "Should I compile SBCL? Please enter your choice Y/n > " ;
  let rl = Stdlib.read_line () |> String.trim in
  if rl = "Y" || rl = "y" then compileSBCL () else skip "SBCL"

let main () = doEmacs () ; doSbcl () ; Printf.printf "\n"

let () = main ()
