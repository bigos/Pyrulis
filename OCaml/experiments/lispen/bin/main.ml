let skip name = Printf.printf "skipping %s\n" name
let flush () = Printf.printf "%!"

let printHeader name =
  Printf.printf "\n\n--- %s -------------------------------\n\n" name

let compileProj (name : string) (code : string) : unit =
  Printf.printf "compile %s" name;
  flush ();
  let _ = Sys.command code in
  Printf.printf "done"

let doProj pname ppath compileFn skipFn =
  printHeader pname;
  Sys.chdir ppath;
  flush ();
  let _ = Sys.command "git pull" in
  Printf.printf "Should I compile %s? Please enter your choice Y/n > " pname;
  let rl = Stdlib.read_line () |> String.trim |> String.uppercase_ascii in
  if rl = "Y" then compileFn () else skipFn ()

let doEmacs () =
  let pname = "Emacs" in
  doProj pname "/home/jacek/Programming/emacs-31"
    (fun () -> compileProj pname "make; sudo make install")
    (fun () -> skip pname)

let doSbcl () =
  let pname = "SBCL" in
  doProj pname "/home/jacek/Programming/sbcl"
    (fun () ->
      compileProj pname "sh ./distclean.sh; sh ./make.sh; sudo sh ./install.sh")
    (fun () -> skip pname)

let main () =
  doEmacs ();
  doSbcl ();
  Printf.printf "\n"

let () = main ()
