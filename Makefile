tools:
	ocamlc -I src -c src/maths_tools.mli
	ocamlc -I src -c src/maths_tools.ml
prng:
	ocamlc -I src -c src/prng.mli
	ocamlc -I src -c src/prng.ml
krawksyk:
	ocamlc -I src -c src/krawksyk_algorithm.ml
	ocamlc -I src -o krawksyk_algorithm src/maths_tools.cmo src/prng.cmo src/krawksyk_algorithm.cmo
	./krawksyk_algorithm
test: tools
	ocamlc -I src -c src/test_maths_tools.ml 
	ocamlc -I src -o test src/maths_tools.cmo src/test_maths_tools.cmo
	./test
all :
	make clean
	make tools
	make prng
	make krawksyk
clean:
	rm -rf krawksyk_algorithm test src/*.cmi src/*.cmo src/*.cmx src/*.out
