#include "tri.h"


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


/*
Rotation gauche pour AVL
*/
Arbre *rotationGauche(Arbre *x) {
  Arbre *y = x->droite;
  Arbre *t2 = y->gauche;

  y->gauche = x;
  x->droite = t2;

  x->hauteur = max(hauteur(x->gauche), hauteur(x->droite)) + 1;
  y->hauteur = max(hauteur(y->gauche), hauteur(y->droite)) + 1;

  return y;
}


/*
Rotation droite pour AVL
*/
Arbre *rotationDroite(Arbre *y) {
  Arbre *x = y->gauche;
  Arbre *t2 = x->droite;

  x->droite = y;
  y->gauche = t2;

  y->hauteur = max(hauteur(y->gauche), hauteur(y->droite)) + 1;
  x->hauteur = max(hauteur(x->gauche), hauteur(x->droite)) + 1;

  return x;
}


/*
equilibre de l'AVL
*/
int equilibre(Arbre *a) {
  if (a == NULL)
    return 0;
  return hauteur(a->gauche) - hauteur(a->droite);
}


/*
insertion pour ABR
*/
Arbre *insertionABR(Arbre *a, char *ligne) {
  if (a == NULL)
    return creerArbre(ligne);

  if (strcmp(ligne, a->ligne) < 0)
    a->gauche = insertionABR(a->gauche, ligne);
  else if (strcmp(ligne, a->ligne) > 0)
    a->droite = insertionABR(a->droite, ligne);
  else
    return a;

  return a;
}



/*
insertion pour AVL
*/
Arbre *insertionAVL(Arbre *a, char *ligne) {
  if (a == NULL)
    return creerArbre(ligne);

  if (strcmp(ligne, a->ligne) < 0)
    a->gauche = insertionAVL(a->gauche, ligne);
  else if (strcmp(ligne, a->ligne) > 0)
    a->droite = insertionAVL(a->droite, ligne);
  else
    return a;

  a->hauteur = 1 + max(hauteur(a->gauche), hauteur(a->droite));
  int balance = equilibre(a);

  if (balance > 1 && strcmp(ligne, a->gauche->ligne) < 0)
    return rotationDroite(a);

  if (balance < -1 && strcmp(ligne, a->droite->ligne) > 0)
    return rotationGauche(a);

  if (balance > 1 && strcmp(ligne, a->gauche->ligne) > 0) {
    a->gauche = rotationGauche(a->gauche);
    return rotationDroite(a);
  }

  if (balance < -1 && strcmp(ligne, a->droite->ligne) < 0) {
    a->droite = rotationDroite(a->droite);
    return rotationGauche(a);
  }

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
parcours postfixe pour avoir l'ordre décroissant
*/
void parcoursPostfixe(Arbre *arb, FILE *sortie) {
    if (arb != NULL) {
      parcoursPostfixe(arb->droite, sortie);
      fprintf(sortie, "%s\n", arb->ligne);
      parcoursPostfixe(arb->gauche, sortie);
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