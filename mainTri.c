#include "tri.h"


int main(int argc, char *argv[]) {

    char ligne[1024];
    Arbre *arb = NULL;

    if ( argc > 7) {
        printf("Usage: %s -f <fichier_entree> -o <fichier_sortie> --<mode_tri>\n", argv[0]);
        return 1;
    }


    /****** TRI AVEC UN AVL ******/

    if (strcmp(argv[5], "--avl") == 0) {

        FILE *entree = fopen(argv[2], "r");
        if (entree == NULL) {
            printf("Impossible d'ouvrir le fichier d'entrée\n");
            return 2;
        }

        FILE *sortie = fopen(argv[4], "w");
        if (sortie == NULL) {
            printf("Impossible d'ouvrir le fichier de sortie\n");
            return 3;
        }


        while (fgets(ligne, 1024, entree) != NULL) {
            ligne[strlen(ligne) - 1] = '\0';
            arb = insertionAVL(arb, ligne);
        }

        if (strcmp(argv[6], "-r") == 0){
            parcoursPostfixe(arb, sortie);
        }
        else{
            parcoursInfixe(arb, sortie);
        }

        fclose(entree);
        fclose(sortie);

        detruireArbre(arb);
        arb = NULL;

        printf("Trié à l'aide d'un AVL\n");

        return 0;
    }


     /****** TRI AVEC UN ABR ******/

     if (strcmp(argv[5], "--abr") == 0) {

        FILE *entree = fopen(argv[2], "r");
        if (entree == NULL) {
            printf("Impossible d'ouvrir le fichier d'entrée\n");
            return 2;
        }

        FILE *sortie = fopen(argv[4], "w");
        if (sortie == NULL) {
            printf("Impossible d'ouvrir le fichier de sortie\n");
            return 2;
        }


        while (fgets(ligne, 1024, entree) != NULL) {
            ligne[strlen(ligne) - 1] = '\0';
            arb = insertionABR(arb, ligne);
        }

        if (strcmp(argv[6], "-r") == 0){
            parcoursPostfixe(arb, sortie);
        }
        else{
            parcoursInfixe(arb, sortie);
        }

        fclose(entree);
        fclose(sortie);

        detruireArbre(arb);
        arb = NULL;

        printf("Trié à l'aide d'un ABR\n");

        return 0;

        

     }

}
