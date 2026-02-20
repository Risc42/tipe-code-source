open Maths_tools
open Prng

(* Fonction pour afficher un tuple *)
let print_tuple (a, b) = Printf.printf "(%d, %d) " a b

(* Fonction pour afficher une ligne de la matrice *)
let print_row row =
  Array.iter print_tuple row;
  Printf.printf "\n"

(* Fonction pour afficher la matrice complète *)
let print_matrix matrix = Array.iter print_row matrix

let prediction_process_step_2_krawczyk
    (k_functions_array : ((int, int) Hashtbl.t -> int -> int) array)
    (k_alpha_array : int array)
    (*_____*) (prev_elems_hashtable : (int, int) Hashtbl.t)
    (column_lin_indep_matrix : fraction matrix ref)
    (val_lin_indep_array : fraction array ref) (*_____*) (m : int)
    (supposed_m : int ref) (i : int) =
  let ith_elem_column, ith_value =
    return_ith_elem_column_and_ith_value k_functions_array k_alpha_array
      prev_elems_hashtable m i
  in
  let ith_elem_column_supposed_module =
    mod_ith_colum ith_elem_column !supposed_m
  in
  let x =
    pivot_de_gauss !column_lin_indep_matrix ith_elem_column_supposed_module
  in
  Hashtbl.add prev_elems_hashtable i (numerateur_frac ith_value);
  if
    produit_matriciel_matrix_column !column_lin_indep_matrix x
    = ith_elem_column_supposed_module
  then
    let n_estimated_ith_value, d_estimated_ith_value =
      produit_matriciel_line_column !val_lin_indep_array x
    in
    let estimated_ith_value =
      ( n_estimated_ith_value mod !supposed_m,
        d_estimated_ith_value mod !supposed_m )
    in
    if estimated_ith_value <> ith_value then begin
      supposed_m :=
        numerateur_frac
          (pgcd_fractions (!supposed_m, 1)
             (soustrait_2_frac estimated_ith_value ith_value))
    end
    else ()
  else (
    for j = 0 to Array.length !column_lin_indep_matrix - 1 do
      !column_lin_indep_matrix.(j) <-
        Array.append
          !column_lin_indep_matrix.(j)
          [| ith_elem_column_supposed_module.(j) |]
    done;
    val_lin_indep_array := Array.append !val_lin_indep_array [| ith_value |])

let step_2_krawksyk (seeds : int array)
    (k_functions_array : ((int, int) Hashtbl.t -> int -> int) array)
    (k_alpha_array : int array) (m : int) (supposed_m : int ref) =
  let i = ref 0 in
  let prev_elems_hashtable = Hashtbl.create (Array.length seeds) in
  Array.iteri (fun j value -> Hashtbl.add prev_elems_hashtable j value) seeds;

  let first_column, first_value =
    return_ith_elem_column_and_ith_value k_functions_array k_alpha_array
      prev_elems_hashtable m !i
  in
  let first_column_supposed_module = mod_ith_colum first_column !supposed_m in
  Hashtbl.add prev_elems_hashtable !i (numerateur_frac first_value);
  let column_lin_indep_matrix =
    ref (Array.make (Array.length first_column_supposed_module) [||])
  in
  for j = 0 to Array.length first_column_supposed_module - 1 do
    !column_lin_indep_matrix.(j) <- [| first_column_supposed_module.(j) |]
  done;
  let val_lin_indep_array = ref (Array.make 1 first_value) in
  while !supposed_m <> m do
    incr i;
    prediction_process_step_2_krawczyk k_functions_array k_alpha_array
      prev_elems_hashtable column_lin_indep_matrix val_lin_indep_array m
      supposed_m !i;
    Printf.printf "Étape 2 - Le modulo prédit est : %d à l'itération %d\n"
      !supposed_m !i
  done;
  !supposed_m

let calcule_smith m =
  if m.(0).(0) <> (0, 1) then (m, m, m, m, m) else (m, m, m, m, m)

let does_x_divides_colum (c : fraction array) (x : fraction) =
  let divides = ref true in
  for i = 0 to Array.length c - 1 do
    if denominateur_frac (divise_2_frac c.(i) x) <> 1 then divides := false
  done;
  !divides

let prediction_process_step_1
    (k_functions_array : ((int, int) Hashtbl.t -> int -> int) array)
    (k_alpha_array : int array)
    (*_____*) (prev_elems_hashtable : (int, int) Hashtbl.t)
    (column_lin_indep_matrix : fraction matrix ref)
    (val_lin_indep_array : fraction array ref) (*_____*) (m : int)
    (supposed_m : int ref) (i : int) =
  let ith_elem_column, ith_value =
    return_ith_elem_column_and_ith_value k_functions_array k_alpha_array
      prev_elems_hashtable m i
  in
  let x = pivot_de_gauss !column_lin_indep_matrix ith_elem_column in
  Hashtbl.add prev_elems_hashtable i (numerateur_frac ith_value);
  if
    produit_matriciel_matrix_column !column_lin_indep_matrix x = ith_elem_column
  then
    let estimated_ith_value =
      produit_matriciel_line_column !val_lin_indep_array x
    in
    if estimated_ith_value <> ith_value then begin
      let d = (ppcm_denom_column x, 1) in
      supposed_m :=
        abs
          (numerateur_frac
             (soustrait_2_frac
                (multiplie_2_frac d estimated_ith_value)
                (multiplie_2_frac d ith_value)))
    end
    else ()
  else (
    for j = 0 to Array.length !column_lin_indep_matrix - 1 do
      !column_lin_indep_matrix.(j) <-
        Array.append !column_lin_indep_matrix.(j) [| ith_elem_column.(j) |]
    done;
    val_lin_indep_array := Array.append !val_lin_indep_array [| ith_value |])

let step_1 (seeds : int array)
    (k_functions_array : ((int, int) Hashtbl.t -> int -> int) array)
    (k_alpha_array : int array) (m : int) =
  let supposed_m = ref max_int in
  let i = ref 0 in
  let prev_elems_hashtable = Hashtbl.create (Array.length seeds) in
  Array.iteri
    (fun j value ->
      Hashtbl.add prev_elems_hashtable j value;
      incr i)
    seeds;

  let first_column, first_value =
    return_ith_elem_column_and_ith_value k_functions_array k_alpha_array
      prev_elems_hashtable m !i
  in
  Hashtbl.add prev_elems_hashtable !i (numerateur_frac first_value);
  let column_lin_indep_matrix =
    ref (Array.make (Array.length first_column) [||])
  in
  for j = 0 to Array.length first_column - 1 do
    !column_lin_indep_matrix.(j) <- [| first_column.(j) |]
  done;
  let val_lin_indep_array = ref (Array.make 1 first_value) in
  while !supposed_m = max_int do
    incr i;
    prediction_process_step_1 k_functions_array k_alpha_array
      prev_elems_hashtable column_lin_indep_matrix val_lin_indep_array m
      supposed_m !i;
    Printf.printf "Étape 1 - Le modulo prédit est : %d à l'itération %d\n"
      !supposed_m (!i - 1)
  done;
  step_2_krawksyk seeds k_functions_array k_alpha_array m supposed_m

(*Ancien Test : u_n+1 = 3*u_n + 21 et u_0 = 42*)

(*old Nouveau Test : u_n+2 =
let seed_test = [|42; 7|]

let k_functions_array_test = [|(fun prev_elems_hashtable i -> 
  if i <= 1 then Hashtbl.find prev_elems_hashtable i
  else
    (Hashtbl.find prev_elems_hashtable (i-2))); (fun prev_elems_hashtable i -> 
    if i=0 then Hashtbl.find prev_elems_hashtable 0
    else (Hashtbl.find prev_elems_hashtable (i-1)))|]

let k_alpha_array_test = [|3; 9|]
*)

(*test u_n+1 = 5u_n + 35 mod m*)
(*let seed_test = [|42|]

let k_functions_array_test = [|fun prev_elems_hashtable i -> 
  if i = 0 then 
    Hashtbl.find prev_elems_hashtable i
  else
    (Hashtbl.find prev_elems_hashtable (i-1))+7|]

let k_alpha_array_test = [|5|]
let m = 179;;*)

(*test RANDU*)
(*let seed_test = [|13579|]

let k_functions_array_test = [|fun prev_elems_hashtable i -> 
  if i = 0 then 
    Hashtbl.find prev_elems_hashtable i
  else
    (Hashtbl.find prev_elems_hashtable (i-1))|]

let k_alpha_array_test = [|65539|]
let m = 2147483648;;*)

(*test BBS*)
let seed_test = [| 3 |]

let k_functions_array_test =
  [|
    (fun prev_elems_hashtable i ->
      if i = 0 then Hashtbl.find prev_elems_hashtable i
      else
        Hashtbl.find prev_elems_hashtable (i - 1)
        * Hashtbl.find prev_elems_hashtable (i - 1));
  |]

let k_alpha_array_test = [| 1 |]
let m = 272953;;

Printf.printf "Le modulo à trouver pour l'algorithme BlumBlumShub est %d\n" m;;

let supp_m = step_1 seed_test k_functions_array_test k_alpha_array_test m;;

Printf.printf "Le modulo trouvé à la fin vaut %d\n" supp_m
