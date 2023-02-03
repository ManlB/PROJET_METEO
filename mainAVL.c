#include "triAVL.h"


int main(int argc, char *argv[]) {

    char ligne[1024];
    Arbre *arb = NULL;

    if (argc != 3) {
        printf("Usage: %s <fichier_entree> <fichier_sortie>\n", argv[0]);
        return 1;
    }

    FILE *entree = fopen(argv[1], "r");
    if (entree == NULL) {
        printf("Impossible d'ouvrir le fichier d'entrée\n");
        return 2;
    }

    FILE *sortie = fopen(argv[2], "w");
    if (sortie == NULL) {
        printf("Impossible d'ouvrir le fichier de sortie\n");
        return 2;
    }


    while (fgets(ligne, 1024, entree) != NULL) {
        ligne[strlen(ligne) - 1] = '\0';
        arb = insertion(arb, ligne);
    }

    parcoursInfixe(arb, sortie);

    fclose(entree);
    fclose(sortie);

    detruireArbre(arb);
    arb = NULL;

    return 0;
}
