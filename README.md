# TIPE - Code source

## Générateurs de nombres pseudo-aléatoires, Analyse et détermination

Ce _repo_ contient le code source d'un TIPE (projet d'initiation à la recherche de CPGE) que j'ai réalisé en 2022. Il s'agit de l'implémentation en _OCaml_ de deux algorithmes permettant à partir de la connaissance du générateur pseudo-aléatoire et des différentes valeurs de sorties, de trouver le modulo du générateur, et d'ainsi pouvoir déterminer à l'avance les prochaines valeurs à sortir.

Les deux principaux algorithmes utilisés sont ceux de Joan BOYAR PLUMSTEAD et
Hugo KRAWCZYK dont voici les références :

- Joan BOYAR PLUMSTEAD : _Inferring sequences produced by pseudo-random number
  generators_ : J. ACM, p.129–141, 1989
- Hugo KRAWCZYK : _How to predict congruential generators_ : Journal of
  Algorithms 13, p.527–545, 1992
