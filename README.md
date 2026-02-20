# TIPE - Code source

## Générateurs de nombres pseudo-aléatoires, Analyse et détermination

### 0. Message d'attention

Attention ! Le code présent ici est l'image brute avec quelques modifications
nécessaires pour rendre le programme fonctionnel de ce qui a été réalisé en 2022.
Aucune mise à jour majeure (ou même mineure) du code n'a été mise en place depuis.

### 1. Informations génériques

Ce _repo_ contient le code source d'un TIPE (projet d'initiation à la recherche
de CPGE) que j'ai réalisé en 2022. Il s'agit de l'implémentation en _OCaml_ de
deux algorithmes permettant à partir de la connaissance du générateur
pseudo-aléatoire et des différentes valeurs de sorties, de trouver le modulo
du générateur, et d'ainsi pouvoir déterminer à l'avance les prochaines valeurs
à sortir.

### 2. Sources

Les deux principaux algorithmes utilisés sont ceux de Joan BOYAR PLUMSTEAD et
Hugo KRAWCZYK dont voici les références :

- Joan BOYAR PLUMSTEAD : _Inferring sequences produced by pseudo-random number
  generators_ : J. ACM, p.129–141, 1989
- Hugo KRAWCZYK : _How to predict congruential generators_ : Journal of
  Algorithms 13, p.527–545, 1992

### 3. Comment compiler et tester le programme ?

À l'heure actuelle seul l'algorithme de KRAWCZYK (et toutes les fonctions
annexes, fonctions mathématiques comprises) est fonctionnel. L'algorithme de
BOYAR n'est pour le moment pas fini. On peut néanmoins tester le reste et se
faire une idée du fonctionnement de l'algorithme de BOYAR qui reste finalement
assez proche de l'autre.

Pour compiler, rien de plus simple si on a déjà installé `ocamlc` et `make`.
Sinon pour installer la toolchain _OCaml_ on peut suivre [ce tutoriel](https://ocaml.org/docs/installing-ocaml).
Une fois chose faite il suffit de faire :

- `make test`, pour compiler et exécuter les tests (à l'heure actuelle seulement
  la partie mathématique)
- `make krawczyk_algorithm`, pour compiler et exécuter l'algorithme de KRAWCZYK
  sur un générateur de type BlumBlumShub
- `make clean`, pour effacer tous les fichiers de compilation

### 4. Conclusion

Bonne découverte !
