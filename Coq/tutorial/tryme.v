(* experimental *)

Inductive bool : Type :=
| true : bool
| false : bool.

Inductive day : Type :=
| monday : day
| tuesday : day
| wednesday : day
| thursday : day
| friday : day
| saturday : day
| sunday : day.

Definition next_weekday (d:day) : day :=
  match d with
  | monday  =>  tuesday
  | tuesday => wednesday
  | wednesday => thursday
  | thursday => friday
  | friday => monday
  | saturday => monday
  | sunday => monday
  end.

Compute (next_weekday friday).


Example test_next_weekday:
  (next_weekday (next_weekday saturday)) = tuesday.

Definition negb (b:bool) : bool :=
  match b with
  | true => false
  | false => true
  end.

Definition andb (b1:bool) (b2:bool) : bool :=
  match b1 with
  | true => b2
  | false => false
  end.

Definition orb (b1:bool) (b2:bool) : bool :=
  match b1 with
  | true => true
  | false => b2
  end.

Example test_orb1: (orb true false) = true.
Proof. simpl. reflexivity. Qed.
Example test_orb2: (orb false false) = false.
Proof. simpl. reflexivity. Qed.
Example test_orb3: (orb false true) = true.
Proof. simpl. reflexivity. Qed.
Example test_orb4: (orb true true) = true.
Proof. simpl. reflexivity. Qed.

Infix "&&" := andb.
Infix "||" := orb.

Example test_orb5: false || false || true = true.
Proof. simpl. reflexivity. Qed.

Definition nandb (b1:bool) (b2:bool) : bool :=
(negb (andb b1 b2)).

Example test_nandb1: (nandb true false) = true.
Proof. simpl. reflexivity. Qed. 
Example test_nandb2: (nandb false false) = true.
Proof. simpl. reflexivity. Qed. 
Example test_nandb3: (nandb false true) = true.
Proof. simpl. reflexivity. Qed. 
Example test_nandb4: (nandb true true) = false.
Proof. simpl. reflexivity. Qed. 

(* we need proofs to fail wrong code *)

Definition andb3 (b1:bool) (b2:bool) (b3:bool) : bool :=
(b1 && b2 && b3).
Example test_andb3_1: (andb3 true true true) = true.
Proof. simpl. reflexivity. Qed.
Example test_andb3_2: (andb3 true true false) = false.
Proof. simpl. reflexivity. Qed.
Example test_andb3_3: (andb3 true false true) = false.
Proof. simpl. reflexivity. Qed.
Example test_andb3_4: (andb3 false true true) = false.
Proof. simpl. reflexivity. Qed.

(* function types *)

Check true.
Check (negb true).
Check negb.

(* modules *)

(* numbers *)

