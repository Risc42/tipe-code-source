type fraction = int * int

let fraction_of_int (a : int) (b : int) = (a, b)
let rec pgcd (a : int) (b : int) = if a = 0 then b else pgcd (b mod a) a
let ppcm (a : int) (b : int) = if a = 0 && b = 0 then 0 else a * b / pgcd a b
let numerateur_frac ((a, b) : fraction) = a
let denominateur_frac ((a, b) : fraction) = b

let ppcm_denom_column (c : fraction array) =
  if Array.length c = 1 then denominateur_frac c.(0)
  else
    let d = ref (denominateur_frac c.(0)) in
    for i = 1 to Array.length c - 1 do
      d := ppcm !d (denominateur_frac c.(i))
    done;
    !d

let irred_frac ((a, b) : fraction) =
  if a = 0 && b = 0 then (0, 1)
  else fraction_of_int (a / pgcd a b) (b / pgcd a b)

let multiplie_2_frac ((a1, b1) : fraction) ((a2, b2) : fraction) =
  irred_frac (fraction_of_int (a1 * a2) (b1 * b2))

let divise_2_frac ((a1, b1) : fraction) ((a2, b2) : fraction) =
  multiplie_2_frac (a1, b1) (b2, a2)

let additionne_2_frac ((a1, b1) : fraction) ((a2, b2) : fraction) =
  irred_frac (fraction_of_int ((a1 * b2) + (a2 * b1)) (b1 * b2))

let soustrait_2_frac ((a1, b1) : fraction) ((a2, b2) : fraction) =
  additionne_2_frac (a1, b1) (-a2, b2)

let pgcd_fractions ((a1, b1) : fraction) ((a2, b2) : fraction) =
  irred_frac (pgcd a1 a2, ppcm b1 b2)

let rec exponentiation_rapide valeur puissance =
  if puissance = 1 then valeur
  else if puissance mod 2 = 0 then
    exponentiation_rapide (valeur * valeur) (puissance / 2)
  else valeur * exponentiation_rapide (valeur * valeur) ((puissance - 1) / 2)

type 'a matrix = 'a array array

let produit_matriciel (m1 : fraction matrix) (m2 : fraction matrix) =
  assert (Array.length m1.(0) = Array.length m2);
  let nb_lignes = Array.length m1 in
  let nb_colonnes = Array.length m2.(0) in
  let prod = Array.make_matrix nb_lignes nb_colonnes (0, 1) in
  for i = 0 to nb_lignes - 1 do
    for j = 0 to nb_colonnes - 1 do
      let somme = ref (0, 1) in
      for k = 0 to Array.length m1.(0) - 1 do
        somme :=
          additionne_2_frac !somme (multiplie_2_frac m1.(i).(k) m2.(k).(j))
      done;
      prod.(i).(j) <- !somme
    done
  done;
  prod

let produit_matriciel_matrix_column (m : fraction matrix) (c : fraction array) =
  let nb_lignes = Array.length m in
  let nb_commun = Array.length c in
  let prod = Array.make nb_lignes (0, 1) in
  for i = 0 to nb_lignes - 1 do
    let somme = ref (0, 1) in
    for j = 0 to nb_commun - 1 do
      somme := additionne_2_frac !somme (multiplie_2_frac m.(i).(j) c.(j))
    done;
    prod.(i) <- !somme
  done;
  prod

(*on suppose que a et b sont de la même taille*)
let produit_matriciel_line_column (a : fraction array) (b : fraction array) =
  let value = ref (0, 1) in
  for i = 0 to Array.length a - 1 do
    value := additionne_2_frac (multiplie_2_frac a.(i) b.(i)) !value
  done;
  !value

let fraction_array_of_int_array (a : int array) =
  Array.map (fun i -> fraction_of_int i 1) a

let fraction_matrix_of_int_matrix (m : int matrix) =
  Array.map (fun p -> Array.map (fun i -> fraction_of_int i 1) p) m

let echange_2_lignes (a : fraction matrix) (b : fraction array)
    (ind_ligne_1 : int) (ind_ligne_2 : int) =
  let temp_ligne_a = a.(ind_ligne_1) in
  let temp_ligne_b = b.(ind_ligne_1) in
  a.(ind_ligne_1) <- a.(ind_ligne_2);
  a.(ind_ligne_2) <- temp_ligne_a;
  b.(ind_ligne_1) <- b.(ind_ligne_2);
  b.(ind_ligne_2) <- temp_ligne_b

let triangule_matrix (m : fraction matrix) (column_matrix : fraction array) =
  let nb_lignes = Array.length column_matrix in
  let nb_colonnes = Array.length m.(0) in
  let pivot = ref m.(0).(0) in
  for i = 0 to nb_colonnes - 1 do
    (*parcourt les nb_colonnes 1eres lignes*)
    pivot := m.(i).(i);
    let pivot_non_nul = ref true in
    if numerateur_frac !pivot = 0 then begin
      pivot_non_nul := false;
      let temp_i = ref i in
      while !temp_i < nb_lignes && numerateur_frac m.(!temp_i).(i) = 0 do
        incr temp_i
      done;
      if !temp_i < nb_lignes then begin
        pivot_non_nul := true;
        echange_2_lignes m column_matrix i !temp_i;
        pivot := m.(i).(i)
      end
    end
    else pivot_non_nul := true;
    if !pivot_non_nul then begin
      for j = i + 1 to nb_lignes - 1 do
        (*L_j <- a_i,i*L_j - a_j,i*L_i*)
        let coeff_mult = m.(j).(i) in
        if numerateur_frac coeff_mult <> 0 then begin
          column_matrix.(j) <-
            soustrait_2_frac
              (multiplie_2_frac column_matrix.(j) !pivot)
              (multiplie_2_frac coeff_mult column_matrix.(i));
          for c = i to nb_colonnes - 1 do
            m.(j).(c) <-
              soustrait_2_frac
                (multiplie_2_frac m.(j).(c) !pivot)
                (multiplie_2_frac coeff_mult m.(i).(c))
          done
        end
      done
    end
  done

let copy_matrix (a : 'a matrix) =
  let n = Array.length a in
  let p = Array.length a.(0) in
  let copy = Array.make_matrix n p a.(0).(0) in
  for i = 0 to n - 1 do
    for j = 0 to p - 1 do
      copy.(i).(j) <- a.(i).(j)
    done
  done;
  copy

(*Fait une copie des deux matrices en entier pour ne pas les altérer*)
(*le pivot de Gauss n'est fait que si la matrice est carrée ou avec moins
de colonnes que de lignes, sinon pas d'intêrets *)
let pivot_de_gauss (a : fraction matrix) (b : fraction array) =
  let m = copy_matrix a in
  let column_matrix = Array.copy b in
  triangule_matrix m column_matrix;
  let nb_lignes = Array.length column_matrix in
  let nb_colonnes = Array.length m.(0) in
  let x = Array.make nb_colonnes (fraction_of_int 0 1) in
  let ind_x_en_cours = ref (nb_colonnes - 1) in
  for i = nb_lignes - 1 downto 0 do
    if numerateur_frac m.(i).(!ind_x_en_cours) <> 0 then begin
      x.(!ind_x_en_cours) <-
        divise_2_frac column_matrix.(i) m.(i).(!ind_x_en_cours);
      for j = 0 to i - 1 do
        begin
          column_matrix.(j) <-
            soustrait_2_frac column_matrix.(j)
              (multiplie_2_frac x.(!ind_x_en_cours) m.(j).(!ind_x_en_cours))
        end
      done;
      decr ind_x_en_cours
    end
  done;
  x

let mod_ith_colum (c : fraction array) (m : int) =
  Array.map (fun (n, d) -> (n mod m, d mod m)) c

let rec bezout a b =
  let rec euc (u, v, r, u', v', r') =
    if r' = 0 then (u, v, r)
    else
      let q = r / r' in
      euc (u', v', r', u - (q * u'), v - (q * v'), r - (q * r'))
  in
  euc (1, 0, a, 0, 1, b)
