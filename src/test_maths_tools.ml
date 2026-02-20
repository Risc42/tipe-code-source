open Maths_tools

let a = [| [| 3; 2; -1 |]; [| -2; 1; 5 |]; [| 4; 5; 3 |] |]
let c = [| [| 2; 3; 4; 7 |]; [| 2; 5; 6; 3 |]; [| 5; 7; 3; 9 |] |]
let b = fraction_matrix_of_int_matrix a

(*let m = fraction_matrix_of_int_matrix
[|[|1;0;0|];
[|1;5;0|];
[|-1;-9;1|]|]*)

let m_bon_sens_n_est_ce_pas_gabin_hein =
  fraction_matrix_of_int_matrix
    [| [| 1; 1; -1 |]; [| 0; 5; -9 |]; [| 0; 0; 1 |] |]

let column_matrix = fraction_array_of_int_array [| -6; -24; 1 |]
let x = pivot_de_gauss m_bon_sens_n_est_ce_pas_gabin_hein column_matrix

let d =
  fraction_matrix_of_int_matrix
    [| [| 0; -1; 2 |]; [| -4; 1; -5 |]; [| 1; 1; -1 |] |]

let e = fraction_array_of_int_array [| 5; 0; -6 |];;

Printf.printf "lalalal %d vaut \n" (denominateur_frac d.(2).(0));;

let y = pivot_de_gauss d e;;

Printf.printf "num y.(0) %d\n" (numerateur_frac y.(0));;
Printf.printf "den y.(0) %d\n" (denominateur_frac y.(0));;
Printf.printf "num y.(1) %d\n" (numerateur_frac y.(1));;
Printf.printf "den y.(1) %d\n" (denominateur_frac y.(1));;
Printf.printf "num y.(2) %d\n" (numerateur_frac y.(2));;
Printf.printf "den y.(2) %d\n" (denominateur_frac y.(2));;

let f =
  fraction_matrix_of_int_matrix
    [| [| 1; 1; -1 |]; [| 1; 2; 1 |]; [| 2; 1; 2 |] |]

let g = fraction_array_of_int_array [| 1; 2; 3 |];;

triangule_matrix d e
