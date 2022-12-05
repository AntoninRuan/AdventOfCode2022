(* Utilitaire pour le reste du programme *)

let width = 9;;
let filename = "input.txt";;
type instruction = {mutable number: int; mutable from: int; mutable dest: int};;

let instructions = ref [];;
let start_structure = Array.make width [];;

open Printf;;
let print_stru stru = 
  for i = 0 to Array.length stru - 1 do
    List.iter (printf "%c") stru.(i);
    print_string "\n";
  done;
;;

let print_instr instr = 
  print_string "number="; print_int instr.number;
  print_string "; from="; print_int instr.from;
  print_string "; dest="; print_int instr.dest;
  print_string "\n";
;;

let rec print_instrs instrs = match instrs with 
  | [] -> ();
  | t::q -> print_instr t; print_instrs q;
;;

let column_to_char_number c = 
  1 + (c * 4);;

(* Partie 1 *)
print_string "-------- Part1 --------\n";;

let rec read_file filename = let structure = ref true in
  let rec read_all_lines in_chan =
      let s = input_line in_chan in 
        if s = "" then (
          structure := false;
        ) else (
          if !structure then (
            read_struct_line s;
          ) else (
            read_instr_line s;
          );
        );
        read_all_lines in_chan
  in
    let in_file = open_in filename in
      try
          read_all_lines in_file
      with End_of_file -> close_in in_file
and read_struct_line line = 
  for i = 0 to (width - 1) do
    let c = line.[column_to_char_number i] in
      if c <> ' ' then (
        start_structure.(i) <- start_structure.(i) @ [c];
      );
  done;
and read_instr_line line = 
  let lst = (String.split_on_char ' ' line) and instr = {number = 0; from = 0; dest = 0} in
    let rec aux l compteur = match l with 
      | [] -> ()
      | t::q -> ( match compteur with 
        | 1 -> instr.number <- int_of_string t;
        | 3 -> instr.from <- (int_of_string t) - 1;
        | 5 -> instr.dest <- (int_of_string t) - 1;
        | _ -> ();
      ); aux q (compteur + 1);
    in
    aux lst 0; instructions := !instructions @ [instr];
;;

read_file filename;;

(* print_stru start_structure;; *)
(* print_instrs !instructions;; *)
let get_head lst = match lst with
  | [] -> failwith "Noulle";
  | t::q -> t;
;;

let move from dest arr = 
  let lst = arr.(from) in match lst with 
    | [] -> failwith "Colonne vide";
    | t::q -> arr.(from) <- q; arr.(dest) <- t::arr.(dest);
;;
let rec part1 str instrs = match instrs with
  | [] -> print_result str;
  | t::q -> for _ = 1 to t.number do
      move t.from t.dest str;
    done;
    part1 str q;
and print_result str = 
  for i = 0 to (Array.length str - 1) do
    print_char (get_head (str.(i)));
  done;
  print_string "\n";
;;

part1 start_structure !instructions;;

(* Part 2 *)
print_string "-------- Part2 --------\n";;

let move2 number from dest arr = 
  let rec pick number lst = match number with
    | 0 -> lst;
    | n -> let fr = arr.(from) in (match fr with
      | [] -> failwith "Colonne vide";
      | t::q -> arr.(from) <- q; pick (n - 1) (t::lst);
    );
  and drop lst = (match lst with 
    | [] -> ()
    | t::q -> arr.(dest) <- t::arr.(dest);drop q;
  )
  in drop (pick number [])
;;

for i = 0 to Array.length start_structure - 1 do
  start_structure.(i) <- [];
done;;
instructions := [];;

read_file filename;;

(* print_stru start_structure;; *)
(* print_instrs !instructions;; *)
(* print_string "\n";; *)

let rec part2 str instrs = match instrs with
  | [] -> print_result str;
  | t::q -> move2 t.number t.from t.dest str; 
    part2 str q;
and print_result str = 
  for i = 0 to (Array.length str - 1) do
    print_char (get_head (str.(i)));
  done;
  print_string "\n";
;;

part2 start_structure !instructions;;