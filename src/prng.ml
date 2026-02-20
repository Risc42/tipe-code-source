open Maths_tools

let generator algorithm seed n =
  let table_valeurs = Array.make n 0 in
  let last_value = ref seed in
  table_valeurs.(0) <- seed;
  for i = 1 to n - 1 do
    begin
      last_value := algorithm !last_value;
      table_valeurs.(i) <- !last_value
    end
  done;
  table_valeurs

(*formule générique pour les test mais qui ne servira pas pour l'algo en soit à 
part pour vérifier la prévision et calculer le taux d'erreur
se souvenir que k_functions_array est de (int,int) Hashtbl.t -> int -> int) 
array' car chaque fonction phi_i contenue à l'intérieur prend en entrée les 
précédentes valeurs et l'indice de la valeur actuelle à calculer
k_prec_elem représente u_n-1, u_n-2,..., u_n-k les k derniers éléments 
nécessaires pour que les algos fonctionnent (au tout début ce sont les seeds)
On suppose que k_functions_array et k_alpha_array ont la même taille*)
let krawczyk_generator
    (k_functions_array : ((int, int) Hashtbl.t -> int -> int) array)
    (k_alpha_array : int array) (prev_elems_hashtable : (int, int) Hashtbl.t)
    (m : int) (i : int) =
  let ith_elem = ref 0 in
  for j = 0 to Array.length k_functions_array - 1 do
    ith_elem :=
      !ith_elem
      + (k_alpha_array.(j) * k_functions_array.(j) prev_elems_hashtable i mod m)
  done;
  Hashtbl.add prev_elems_hashtable
    (Hashtbl.length prev_elems_hashtable)
    !ith_elem

(*retourne Phi_i(s(i)) pour un i compris dans l'intervalle de définition, et en 
ayant déjà les valeurs précédentes*)
let partial_ith_elem_krawczyk (alpha : int)
    (prev_elems_hashtable : (int, int) Hashtbl.t) (m : int) (i : int)
    (phi_i : (int, int) Hashtbl.t -> int -> int) =
  ((alpha * phi_i prev_elems_hashtable i, 1), (phi_i prev_elems_hashtable i, 1))

(*retourne une matrice colonne B_i comme indiquée dans le fonctionnement de 
l'algorithme et contenant ligne après ligne va valeur pour chaque fonction*)
let return_ith_elem_column_and_ith_value
    (k_functions_array : ((int, int) Hashtbl.t -> int -> int) array)
    (k_alpha_array : int array) (prev_elems_hashtable : (int, int) Hashtbl.t)
    (m : int) (i : int) =
  let n = Array.length k_functions_array in
  let ith_elem_column = Array.make n (0, 1) in
  let ith_value = ref (0, 1) in
  for j = 0 to n - 1 do
    begin
      let temp_with_alpha, temp_without_alpha =
        partial_ith_elem_krawczyk k_alpha_array.(j) prev_elems_hashtable m i
          k_functions_array.(j)
      in
      ith_elem_column.(j) <- temp_without_alpha;
      ith_value := additionne_2_frac temp_with_alpha !ith_value
    end
  done;
  (ith_elem_column, (numerateur_frac !ith_value mod m, 1))

(*******************************************)
(*Générateur Congruentiel Linéaire *)
(*Calcule les n premières valeurs de la suite d'un générateur congruentiel 
linéaire de la forme U_n = (a*U_n-1 + b) mod modulo à partir d'une graine d'un
modulo et de deux constantes a et b*)
let next_lcg a b modulo last_value = ((a * last_value) + b) mod modulo
let n_lcg a b seed modulo n = generator (next_lcg a b modulo) seed n

(*####################*)
(*RANDU*)
let n_randu n = n_lcg 65539 0 (Maths_tools.exponentiation_rapide 2 31) n

(******************************************)
(*Générateur Congruentiel Quadratique*)

(*####################*)
(*BlumBlumShub*)
(*Calcule la n_eme valeur de la suite de BlumBlumShub à partir de la n-1_eme*)
let next_bbs modulo last_value = last_value * last_value mod modulo

(*Calcule les n premières valeurs de la suite de BlumBlumShub à partir d'une 
graine et d'un modulo*)
let n_bbs seed modulo n = generator (next_bbs modulo) seed n
