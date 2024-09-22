let skip name = Printf.printf "skipping %s" name

let compileEmacs () = print_endline "compile Emscs"

let compileSBCL () = print_endline "compile SBCL"

let main () =
  Printf.printf "\nEmacs -------------------------------\n\n" ;
  Sys.chdir "/home/jacek/Programming/emacs-31" ;
  let _ = Sys.command "git pull" in
  Printf.printf "Should I compile Emacs? Please enter your choice Y/n > " ;
  let rl = Stdlib.read_line () |> String.trim in
  if rl = "Y" then compileEmacs ()
  else if rl = "y" then compileEmacs ()
  else skip "Emacs" ;
  (* sbcl *)
  Printf.printf "\nSBCL -------------------------------\n\n" ;
  Sys.chdir "/home/jacek/Programming/sbcl" ;
  let _ = Sys.command "git pull" in
  Printf.printf "Should I compile SBCL? Please enter your choice Y/n > " ;
  let rls = Stdlib.read_line () |> String.trim in
  if rls = "Y" then compileSBCL ()
  else if rls = "y" then compileSBCL ()
  else skip "SBCL" ;
  Printf.printf "\n"

let () = main ()
