#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE_LENGTH 1000
#define MAX_COLUMN_COUNT 100

void fusion2tab(int A[n], int B[n], int C[n]){
    int iA = 0;
    int iB = 0;
    int i;
    
    for(i=0; i<2n; i++){
        if(A[iA] < B[iB]){
            C[i] = A[iA];
            iA++;
        }
        else{
            C[i] = B[iB];
            iB++;
        }
    }
}

void triFusion(int A[n]){
    triFusionRec(A,0,n-1);
}

void triFusionRec(int A[n], int d, int f){
    int m;
    
    if(d < f){
        m = (d+f)/2;
        triFusionRec(A,d,m);
        triFusionRec(A,m+1,f);
        fusionner(A,d,m,f);
    }
}

void fusionner(int A[n], int d, int m, int f){
    int iA = d;
    int iB = f;
    int i;
    int aux[n];
    
    for(i=d; i<m+1; i++){
        aux[i] = A[i];
    }
    for(i=m+1; i<f+1; i++){
        aux[i] = A[f-i+m+1];
    }
    for(i=d; i<f+1; i++){
        if(aux[iA] <= aux[iB]){
            A[i] = aux[iA];
            iA++;
        }
        else{
            A[i] = aux[iB];
            iB = iB - 1;
        }
    }
}
int main(int argc, char *argv[]){
    if(argc != 4){
        printf("Usage : %s inputFile outputFile --tab",argv[0]);
        return 1;
    }
    
    char *f1 = argv[1];
    char *f2 = argv[2];
    FILE *f1In = fopen(inputFile, "r");
    if (f1In == NULL) {
        printf("Cannot open file: %s\n", inputFile);
        return 1;
    }
    
    int column = 15;
    char line[MAX_LINE_LENGTH];
    int i = 0;
    
    while (fgets(line, MAX_LINE_LENGTH, fpIn) != NULL){
        char *token = strtok(line,";");
        int j = 0;
        while(token != NULL){
            if(j == column){
                column[I++] = atoi(token);
            }
            token = strtok(NULL, ";");
            j++
        }
    }
    fclose(f2In);
    int n = i;
    printf("n = %d\n", n);
    for(int i=0; i <n; i++){
        printf("column[%d] = %d\n",i,column[i]);
        triFusion(column[i]);
    }

    
    int n = i;
    printf("n = %d\n", n);
    for (int i = 0; i < n; i++) {
        printf("column[%d] = %d\n", i, column[i]);
        triFusion(column[i]);
    }
    FILE *f2Out = fopen(outputFile, "w");
    if (f2Out == NULL) {
        printf("Cannot open file: %s\n", outputFile);
        return 1;
    }
    for (int i = 0; i < n; i++) {
        fprintf(f2Out, "%d\n", column[i]);
    }
    fclose(f2Out);
    return 0;
}

int main(int argc, char *argv[]) {

    int columnIndex = 15 - 1;
    char line[MAX_LINE_LENGTH];
    int i = 0;
    while (fgets(line, MAX_LINE_LENGTH, fpIn) != NULL) {
        char *token = strtok(line, ",");
        int j = 0;
        while (token != NULL) {
            if (j == columnIndex) {
                column[i++] = atoi(token);
            }
            token = strtok(NULL, ",");
            j++;
        }
    }
    fclose(fpIn);
    int n = i;
    printf("n = %d\n", n);
    for (int i = 0; i < n; i++) {
        printf("column[%d] = %d\n", i, column[i]);
    }
    quickSort(column, 0, n - 1);
    FILE *fpOut = fopen(outputFile, "w");
    if (fpOut == NULL) {
        printf("Cannot open file: %s\n", outputFile);
        return 1;
    }
    for (int i = 0; i < n; i++) {
        fprintf(fpOut, "%d\n", column[i]);
    }
    fclose(fpOut);
    return 0;
}
