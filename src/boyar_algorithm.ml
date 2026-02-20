open Maths_tools
open Prng

let prediction_process_step_2_boyar
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
  let u, inverse_u, e, v, inverse_v = calcule_smith !column_lin_indep_matrix in
  let c = produit_matriciel_matrix_column inverse_u ith_elem_column in
  let i = ref 0 in
  let pgcd_e_i_supp_m = pgcd_fractions (!supposed_m, 1) e.(!i).(!i) in
  while not (does_x_divides_colum c pgcd_e_i_supp_m) do
    let frac_supp_m = (!supposed_m, 1) in
    let pgcd_e_i_supp_m = pgcd_fractions frac_supp_m e.(!i).(!i) in
    let denom_maj_supp_m =
      multiplie_2_frac frac_supp_m (pgcd_fractions c.(!i) pgcd_e_i_supp_m)
    in
    supposed_m :=
      numerateur_frac (divise_2_frac denom_maj_supp_m pgcd_e_i_supp_m);
    assert (
      denominateur_frac (divise_2_frac denom_maj_supp_m pgcd_e_i_supp_m) = 1);
    incr i
  done;
  let y = Array.make (Array.length ith_elem_column) (0, 1) in
  for i = 0 to Array.length y - 1 do
    if numerateur_frac e.(i).(i) = 0 then
      y.(i) <- divise_2_frac c.(i) (!supposed_m, 1)
      (*else
    if pgcd_fractions e.(i).(i) (!supposed_m, 1) = 1 then y.(i) <-*)
  done;
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

let step_2_boyar (seeds : int array)
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
  while !i < 50 do
    incr i;
    prediction_process_step_2_boyar k_functions_array k_alpha_array
      prev_elems_hashtable column_lin_indep_matrix val_lin_indep_array m
      supposed_m !i;
    Printf.printf "le m predit est : %d\n" !supposed_m
  done;
  !supposed_m
