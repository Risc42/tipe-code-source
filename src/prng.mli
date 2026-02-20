open Maths_tools

val generator : (int -> int) -> int -> int -> int array

val krawczyk_generator :
  ((int, int) Hashtbl.t -> int -> int) array ->
  int array ->
  (int, int) Hashtbl.t ->
  int ->
  int ->
  unit

val partial_ith_elem_krawczyk :
  int ->
  (int, int) Hashtbl.t ->
  int ->
  int ->
  ((int, int) Hashtbl.t -> int -> int) ->
  fraction * fraction

val return_ith_elem_column_and_ith_value :
  ((int, int) Hashtbl.t -> int -> int) array ->
  int array ->
  (int, int) Hashtbl.t ->
  int ->
  int ->
  fraction array * fraction

val next_lcg : int -> int -> int -> int -> int
val n_lcg : int -> int -> int -> int -> int -> int array
val n_randu : int -> int -> int array
val next_bbs : int -> int -> int
val n_bbs : int -> int -> int -> int array
