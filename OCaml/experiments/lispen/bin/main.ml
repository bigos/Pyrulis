let skip () = print_endline "skipping"

let compile () = print_endline "compile"

let main () =
  Printf.printf "\nEmacs -------------------------------\n\n" ;
  Sys.chdir "/home/jacek/Programming/emacs-31" ;
  let _ = Sys.command "git pull" in
  Printf.printf "Should I compile Emacs? Please enter your choice Y/n > " ;
  let rl = Stdlib.read_line () |> String.trim in
  if rl = "Y" then compile () else if rl = "y" then compile () else skip ()

let () = main ()
