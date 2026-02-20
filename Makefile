tools:
	ocamlc -c src/maths_tools.mli
	ocamlc -c src/maths_tools.ml
prng:
	ocamlc -c src/prng.mli
	ocamlc -c src/prng.ml
krawksyk:
	ocamlc -c src/krawksyk_algorithm.ml
	ocamlc -o src/krawksyk_algorithm src/maths_tools.cmo src/prng.cmo src/krawksyk_algorithm.cmo
test: tools
	ocamlc -c src/test_maths_tools.ml 
	ocamlc -o test src/maths_tools.cmo src/test_maths_tools.cmo
all :
	make clean
	make tools
	make prng
	make krawksyk
clean:
	rm -rf krawksyk_algorithm test src/*.cmi src/*.cmo src/*.cmx src/*.out
