#include "test.h"

int max(int a, int b){
    return(a<b ? b : a);
}



int min(int a, int b){
    return(a < b ? a : b);
}



int maxT(int a, int b, int c){

    
    int m = a;
    if(b > m){
        m = b;
    }
    if(c > m){
        m = c;
    }
    

    return m;
}



int minT(int a, int b, int c){

    int m = a;
    
    if(b < m){
        m = b;
    }
    if(c < m){
        m = c;
    }

    return m;
}



/*  ------------------------------------------  */
adrNoeud rotaG(adrNoeud a){
    adrNoeud pivot;
    int eqA;
    int eqP;

    pivot = a->droit;
    a->droit = pivot->gauche;
    pivot->gauche = a;

    eqA = a->eq;
    eqP = pivot->eq;
    a->eq = (eqA - max(eqP,0) - 1);
    pivot->eq = minT(eqA-2,eqA+eqP-2,eqP-1);
    a = pivot;

    return a;
}



/*  ------------------------------------------  */
adrNoeud rotaD(adrNoeud a){
    adrNoeud pivot;
    int eqA;
    int eqP;

    pivot = a->gauche;
    a->gauche = pivot->droit;
    pivot->droit = a;

    eqA = a->eq;
    eqP = pivot->eq;
    a->eq = (eqA - min(eqP,0) + 1);
    pivot->eq = maxT(eqA+2,eqA+eqP+2,eqP+1);
    a = pivot;

    return a;
}



/*  ------------------------------------------  */
adrNoeud doubleRD(adrNoeud a){
    a->gauche = rotaG(a->gauche);
    return (rotaD(a));
}




/*  ------------------------------------------  */
adrNoeud doubleRG(adrNoeud a){
    a->droit = rotaD(a->gauche);
    return (rotaG(a));
}



/*  ------------------------------------------  */
adrNoeud eqAVL(adrNoeud a){

    if(a->eq == -2){
        rotaD(a);
        if(a->gauche->eq <= 0){
            rotaD(a);
        }
        else{
            doubleRD(a);
        }
    }
    else if(a->eq == 2){
        rotaG(a);
        if(a->droit->eq >= 0){
            rotaG(a);
        }
        else{
            doubleRG(a);
        }
    }
    return a;
}



void trier(FILE *fich1, FILE *fich2){
    
    adrNoeud racine = NULL;
  
    racine = entree_vers_arbre(fich1);

    arbre_vers_sortie(racine,fich2);
}

adrNoeud entree_vers_arbre(FILE * fichier){
    
    char mot[LONGMAX];
    adrNoeud racine = NULL;
  
    while (lire_mot(fichier,mot)!=EOF){
        racine = inser_arbre(racine,mot);
    }
    
    return racine;
}



int lire_mot(FILE *fichier, char * mot){
    
    int c;
    int i;
  
    while ((isspace(c = getc(fichier)) || ispunct(c))
           && (c!='_') && (c != EOF));
    if (c == EOF) return EOF;
    else{
        for (i = 0; !(isspace(c) || ispunct(c) || c == EOF)
             || (c == '_'); i++){
                mot[i] = c;
                c = getc(fichier);
        }
        mot[i] = '\0';
        return mot[0];
    }
}



adrNoeud inser_arbre(adrNoeud rac, char * mot){
    
    int comp;
  
    if (rac == NULL){
        rac = (adrNoeud) malloc(sizeof(Noeud));
        rac->mot = (char *) malloc(strlen(mot)+1);
        rac->nbOcc = 1;
        strcpy(rac->mot, mot);
        rac->gauche = rac->droit = NULL;
        eqAVL(rac);
    }
    
    else if ((comp = strcmp(mot,rac->mot)) == 0){
        rac->nbOcc++;
        eqAVL(rac);
    }
    else if (comp < 0){
        rac->gauche = inser_arbre(rac->gauche,mot);
        eqAVL(rac);
    }
    else{
        rac->droit = inser_arbre(rac->droit, mot);
        eqAVL(rac);
    }
    return rac;
}



int arbre_vers_sortie(adrNoeud rac,FILE *fichier){
    
//    FILE *f2;
    
    if (rac != NULL){
        arbre_vers_sortie(rac->gauche, fichier);
        fprintf(fichier,"%s \n",rac->mot);
        arbre_vers_sortie(rac->droit, fichier);
        eqAVL(rac);
        fprintf(fichier,"%s \n",rac->mot);
    }
    return 3;
}

