type fraction = int * int

val fraction_of_int : int -> int -> fraction
val pgcd : int -> int -> int
val ppcm : int -> int -> int
val exponentiation_rapide : int -> int -> int
val numerateur_frac : fraction -> int
val denominateur_frac : fraction -> int
val ppcm_denom_column : fraction array -> int
val irred_frac : fraction -> fraction
val multiplie_2_frac : fraction -> fraction -> fraction
val divise_2_frac : fraction -> fraction -> fraction
val additionne_2_frac : fraction -> fraction -> fraction
val soustrait_2_frac : fraction -> fraction -> fraction
val fraction_array_of_int_array : int array -> fraction array
val pgcd_fractions : fraction -> fraction -> fraction

type 'a matrix = 'a array array

val produit_matriciel : fraction matrix -> fraction matrix -> fraction matrix

val produit_matriciel_matrix_column :
  fraction matrix -> fraction array -> fraction array

val produit_matriciel_line_column : fraction array -> fraction array -> fraction
val fraction_matrix_of_int_matrix : int matrix -> fraction matrix
val echange_2_lignes : fraction matrix -> fraction array -> int -> int -> unit
val copy_matrix : 'a matrix -> 'a matrix
val triangule_matrix : fraction matrix -> fraction array -> unit
val pivot_de_gauss : fraction matrix -> fraction array -> fraction array
val mod_ith_colum : fraction array -> int -> fraction array
