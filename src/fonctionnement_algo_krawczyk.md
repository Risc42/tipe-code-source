## 1 - Définition

Soient $\Phi_1,...,\Phi_k$ des fonctions à valeur dans $\mathbb{R}$ et soit $k\in\mathbb{N}$. On pose la suite $(s_n)_{n\in\mathbb{N}}$ telle que $s_i = \sum\limits^k_{j=1}\alpha_j\Phi_j(s(i))\mod\ m$

- $m$ : valeur du modulo

- $s(i)$ : famille de vecteurs des $i$ premiers éléments générés

- $B_i$ représente ici la matrice

  $$
  B_i =
  \begin{pmatrix}
  \Phi_1(s(i))\\
  ...\\
  \Phi_k(s(i))
  \end{pmatrix}
  $$

- $B(i)$ représente la matrice
  $$
  B(i) =
  \begin{pmatrix} B_1 & ... & B_i\end{pmatrix}
  $$

### Abus

Tout au long je confondrai volontairement famille de vecteurs et matrice ligne par simplicité

## 2 - Résolution

`The idea behind the algorithm is to find linear dependencies among the columns of the matrix B (i) and to use these dependencies in making the prediction of the next element s_i`
-> Dépendance linéaire ?

Au début on suppose $m=\infin$

### A - Première étape (identique à celle de Boyar)

On suppose que $s(i)$ est connu.
On possède une famille libre $\overline{B(i-1)}$, telle qu'au rang $i$ si $B_i$ est linéairement indépendante de chaque matrice colonne de $\overline{B(i-1)}$, alors on a $$\overline{B(i)} = \begin{pmatrix}\overline{B(i-1)} & B_i\end{pmatrix}$$
-> Méthode : Calculer le rang de la matrice $\begin{pmatrix}\overline{B(i-1)} & B_i\end{pmatrix}$ et voir si égal à $Card(\overline{
B(i-1)})+1$ => **PIVOT DE GAUSS**

On pose $\overline{s(i-1)}$ la famille de vecteurs correspondant à la famille $s(i-1)$, avec uniquement les vecteurs "indexés" avec ceux de $\overline{B(i-1)}$.

Ensuite on résout $\overline{B(i-1)}X = B_i$, avec $X$ matrice colonne de taille correspondante au nombre de vecteurs dans $\overline{B(i-1)}$

- Si pas de solution alors $B_i$ est linéairement indépendante de chaque matrice colonne de $\overline{B(i-1)}$, alors on a $$\overline{B(i)} = \begin{pmatrix}\overline{B(i-1)} & B_i\end{pmatrix}$$

- Sinon
  Et sinon on poursuit les tours de boucle jusqu'à ne plus avoir d'erreurs.

### B - Deuxième étape - Indépendance linéaire sur l'anneau $\mathbb{Z}/n\mathbb{Z}$

