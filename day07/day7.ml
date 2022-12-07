type filetype = 
  | File of string * int
  | Folder of filesystem
and filesystem = 
  | FS of {name: string; mutable children: filetype list; mutable parent: filesystem}
  | Root of {name: string; mutable children: filetype list}

exception Not_found

let filename = "input.txt"

let root = Root({name="/"; children=[];})

let get_name filesystem = match filesystem with
  | Root(r) -> r.name
  | FS(fs) -> fs.name

let rec search_folder name lst = match lst with
  | [] -> raise Not_found
  | t::q -> (match t with
    | File(s, _) -> search_folder name q
    | Folder(fo) -> if (get_name fo) = name then fo else search_folder name q
  )

let rec get_children filesystem = match filesystem with
  | Root(r) -> r.children
  | FS(fs) -> fs.children
;;

let rec get_all_subdirectories filesystem= 
  let rec aux lst = match lst with
    | [] -> []
    | t::q -> (match t with
      | File(_) -> aux q
      | Folder(fs) -> fs::(get_all_subdirectories(fs)) @ (aux q)
    )
  in aux (get_children filesystem)
;;

let get_child name filesystem = match filesystem with
  | Root(r) -> search_folder name r.children
  | FS(fs) -> search_folder name fs.children
and get_parent filesystem = match filesystem with
  | FS(fs) -> fs.parent
  | Root(_) -> failwith "Root does not have a parent"

let add_child child filesystem = match filesystem with
  | Root(r) -> (match child with
    | File(_) -> r.children <- child::r.children;
    | Folder(fs) -> r.children <- child::r.children;
  )
  | FS(fs) -> fs.children <- child::fs.children

let rec get_size file = match file with
  | File (_, size) -> size
  | Folder(fs) -> (let rec aux lst = match lst with
    | [] -> 0
    | t::q -> aux q + get_size t
    in aux (get_children fs)
  )

let parse_cmd args filesystem = match args with
  | [] -> failwith "Noulle"
  | "cd"::q -> (match q with 
    | [] -> failwith "Need argument"
    | ".."::t -> get_parent filesystem 
    | a::t -> (try
      get_child a filesystem
      with Not_found -> failwith "Folder doesn't exitst"
    )
  )
  | "ls"::q -> filesystem
  | t::q -> failwith "Unknown command"
and parse_ls args filesystem = match args with
  | [] -> failwith "Noulle"
  | "dir"::q -> (match q with
    | [] -> failwith "Need argument"
    | name::t -> (
      try 
        let _ = get_child name filesystem in filesystem;
      with Not_found -> let f = FS({name=name; children=[]; parent=filesystem}) in add_child (Folder(f)) filesystem;filesystem;   
    )
  ) 
  | t::q -> (match q with
      | [] -> failwith "Need name"
      | name::_ -> let file = File(name, int_of_string t) in add_child file filesystem; filesystem;
  )
;;

let parse_line line filesystem = 
  if String.starts_with ~prefix:"$" line then (
    let cmd = String.sub line 2 ((String.length line) - 2) in
      let args = String.split_on_char ' ' cmd in
        parse_cmd args filesystem;
  ) else (
    let args = String.split_on_char ' ' line in
      parse_ls args filesystem;
  )
;;

let read_file filename = 
  let rec read_line in_chan filesystem =
    let s = input_line in_chan in
      let fs = parse_line s filesystem in
      read_line in_chan fs
  in 
    let in_file = open_in filename in
      try
        read_line in_file root
      with End_of_file -> close_in in_file    
;;

read_file filename

let part1 filesystem =
  let rec aux lst = match lst with 
    | [] -> 0
    | t::q -> let size = get_size (Folder(t)) in if size < 100_000 then size + aux q else aux q
  in aux (get_all_subdirectories filesystem)
;; 

print_string "Part1: "; print_int (part1 root); print_string "\n";;

let get_sub_dir_size dir = 
  let sub = get_all_subdirectories dir in
    let rec aux lst = match lst with 
      | [] -> []
      | t::q -> (t, get_size (Folder(t)))::(aux q)
    in (dir, get_size (Folder(dir)))::(aux sub)
;; 

let comp fss1 fss2 = let (_,s1) = fss1 and (_,s2) = fss2 in
  s1-s2
;;

let part2 filesystem = 
  let needed_space = 30_000_000 - (70_000_000 - get_size (Folder(root))) in
    let sub_dir_size = get_sub_dir_size root in 
      let sorted = List.sort comp sub_dir_size in
        let rec find_suitable lst = match lst with
          | [] -> failwith "No result"
          | t::q -> let (fs, size) = t in if size >= needed_space then (t) else find_suitable q
        in find_suitable sorted
;;

let _, size = part2 root;;

print_string "Part2: ";  print_int size; print_string "\n";;