#ifndef TRIAVL_H
#define TRIAVL_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct arbre {
  char *ligne;
  struct arbre *gauche;
  struct arbre *droite;
  int hauteur;
}Arbre;


Arbre *creerArbre(char *ligne);
int hauteur(Arbre *a);
int max(int a, int b);
Arbre *rotationGauche(Arbre *x);
Arbre *rotationDroite(Arbre *y);
int equilibre(Arbre *a);
Arbre *insertion(Arbre *a, char *ligne);
void parcoursInfixe(Arbre *arb, FILE *sortie);
void detruireArbre(Arbre *arb);


#endif