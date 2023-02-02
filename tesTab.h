#ifndef __TRI_H__
#define __TRI_H__


#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#define LONGMAX 25

//typedef struct avl{
//
//    char *mot;
//    int eq;
//    struct avl *gauche;
//    struct avl *droit;
//}Avl, *pAvl;


typedef struct noeud{
    
    char *mot;
    int nbOcc;
    int eq;
    struct noeud *gauche;
    struct noeud *droit;
}Noeud, *adrNoeud;



void trier(FILE *,FILE *);
adrNoeud entree_vers_arbre(FILE *);
int arbre_vers_sortie(adrNoeud rac,FILE *fichier);
adrNoeud inser_arbre(adrNoeud,char *);
int lire_mot(FILE *,char *);


int max(int , int);
int min(int , int);
int maxT(int , int , int);
int minT(int , int , int);

adrNoeud rotaG(adrNoeud a);
adrNoeud rotaD(adrNoeud a);
adrNoeud doubleRD(adrNoeud a);
adrNoeud doubleRG(adrNoeud a);
adrNoeud eqAVL(adrNoeud a);

#endif
