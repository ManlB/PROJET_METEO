#include "triABR.h"


/*
création d'un arbre
*/
Arbre *creerArbre(char *ligne) {
  Arbre *nouveau = (Arbre *)malloc(sizeof(Arbre));
  nouveau->ligne = (char *)malloc(strlen(ligne) + 1);
  strcpy(nouveau->ligne, ligne);
  nouveau->gauche = NULL;
  nouveau->droite = NULL;
  nouveau->hauteur = 1;
  return nouveau;
}


/*
hauteur de l'arbre
*/
int hauteur(Arbre *a) {
  if (a == NULL)
    return 0;
  return a->hauteur;
}


/*
le maximum entre deux entiers
*/
int max(int a, int b) {
  return (a > b) ? a : b;
}



Arbre *insertion(Arbre *a, char *ligne) {
  if (a == NULL)
    return creerArbre(ligne);

  if (strcmp(ligne, a->ligne) < 0)
    a->gauche = insertion(a->gauche, ligne);
  else if (strcmp(ligne, a->ligne) > 0)
    a->droite = insertion(a->droite, ligne);
  else return a;


    return a;
}


/*
parcours infixe pour avoir l'ordre croissant
*/
void parcoursInfixe(Arbre *arb, FILE *sortie) {
    if (arb != NULL) {
      parcoursInfixe(arb->gauche, sortie);
      fprintf(sortie, "%s\n", arb->ligne);
      parcoursInfixe(arb->droite, sortie);
    }
}


/*
supression de l'arbre
*/
void detruireArbre(Arbre *arb) {
  if (arb == NULL)
    return;
  detruireArbre(arb->gauche);
  detruireArbre(arb->droite);
  free(arb->ligne);
  free(arb);
}
