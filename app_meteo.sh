#!/bin/bash


#INITIALISATION DES VARIABLES

mode_p=0
mode_t=0

compte_geo=0
compte_tri=0

fichier=""
opt_f=false
opt_p=false
opt_t=false
opt_w=false
opt_m=false
opt_h=false
opt_F=false
opt_G=false
opt_S=false
opt_A=false
opt_O=false
opt_Q=false
opt_tab=false
opt_avl=false
opt_abr=false

        #***********///*******\\\***********#
        #**********/  FONCTIONS  \**********#
        #******** ///***********\\\*********#

aide(){
    echo "
    UTILISATION DE L'APP METEO:   ./app_meteo.sh [OPTION]...[FICHIER]

    Vous devez écrire le fichier d'entrée avec l'option obligatoire:
        -f [FICHIER] : le fichier doit être un csv.


    Vous devez utiliser au moins une option obligatoire. Les options obligatoires sont les suivantes:

    -t<mode>: permet d'afficher un graphique en fontion des températures, doit être accompagner d'un mode:
        -1: génère un graphique de type barres d’erreur avec en abscisse l’identifiant de la
            station, et en ordonnée le minimum, maximum et la moyenne.
        -2 : génère un graphique de type ligne simple avec en abscisse la date des mesures, et en ordonnée la moyenne des mesures.
        -3 : génère un graphique de type multi-lignes avec en abscisse les jours, et en ordonnée les valeurs mesurées.

    -p<mode>: permet d'afficher un graphique en fontion des pressions, doit être accompagner d'un mode:
        -1: génère un graphique de type barres d’erreur avec en abscisse l’identifiant de la
            station, et en ordonnée le minimum, maximum et la moyenne.
        -2 : génère un graphique de type ligne simple avec en abscisse la date des mesures, et en ordonnée la moyenne des mesures.
        -3 : génère un graphique de type multi-lignes avec en abscisse les jours, et en ordonnée les valeurs mesurées.

    -w : génère un graphique de type vecteur, avec les vecteur qui ont pour composante la direction et la vitesse moyenne du vent.

    -h : génère un graphique type carte interpolée et colorée en fonction de l'altitude de chaque station.

    -m : génère un graphique type carte interpolée et colorée en fonction de l'humidité maximum de chaque station.


    Vous pouvez également utiliser des options géographiques afin d'affiner le filtrage. Une seule option géographique doit être utilisée:
                -F : (F)rance : France métropolitaine + Corse.
                -G : (G)uyane française.
                -S : (S)aint-Pierre et Miquelon : ile située à l’Est du Canada
                -A : (A)ntilles.
                -O : (O)céan indien.

    Vous pouvez également préciser le mode de tri souhaité:

    "
}

#*********FILTRAGE DE LA TEMPERATURE*********
temperature(){

    fich=$1

        #***MODE 1
    if [ $2 -eq 1 ]; then

        cut -d';' -f1,11 "$fich" | tail -n +2 > temperature.csv

        awk -F ';' '{printf("%s;%.0f\n", $1, $2)}' temperature.csv > temp.csv  && mv temp.csv temperature.csv

        awk -F';' '{
            a[$1]+=$2; 
            if ($2 > max[$1] || !max[$1]) max[$1] = $2;
            if ($2 < min[$1] || !min[$1]) min[$1] = $2;
            b[$1]++;
        }
        END{
            for(i in a) {
                print i";"max[i]";"min[i]";"a[i]/b[i]
            }
        }' temperature.csv | sed 's/,/./g' > tmp.csv
        mv tmp.csv temperature.csv

        fi

        #***MODE 2
    if [ $2 -eq 2 ]; then

        cut -d';' -f1,2,11 "$fich" | tail -n +2 > temperature2.csv

        awk -F";" '{
            date = substr($2, 1, 10);
            a[date]+=$3;
            b[date]++
        } 
        END {
            for(i in a) {
                print i";" a[i]/b[i]
            }
        }' temperature2.csv | sed 's/,/./g' > tmp.csv
        mv tmp.csv temperature2.csv
    fi

    #***MODE 3
    if [ $2 -eq 3 ]; then

        cut -d';' -f1,2,11 "$fich" | tail -n +2 > temperature3.csv

        awk -F ";" '
        {
            key = $2";"$1;
            temperatures[key] = $3;
        }
        END {
            for (key in temperatures) {
            print key ";" temperatures[key];
            }
        }
        ' temperature3.csv > tmp.csv
                mv tmp.csv temperature3.csv
    fi
}


#*********FILTRAGE DE LA PRESSION*********
pression(){

    fich=$1

        #***MODE 1
    if [ $2 -eq 1 ]; then

        cut -d';' -f1,7 "$fich" | tail -n +2 > pression.csv

        awk -F ';' '{printf("%s;%.0f\n", $1, $2)}' pression.csv > tmp.csv  && mv tmp.csv pression.csv

        awk -F';'  'NF>0 && $2 != 0 {
            a[$1]+=$2; 
            if ($2 > max[$1] || !max[$1]) max[$1] = $2;
            if ($2 < min[$1] || !min[$1]) min[$1] = $2;
            b[$1]++;
        }
        END{
            for(i in a) {
                print i";"max[i]";"min[i]";"a[i]/b[i]
            }
        }' pression.csv | sed 's/,/./g' > tmp.csv
            mv tmp.csv pression.csv
    fi


       #***MODE 2
    if [ $2 -eq 2 ]; then

        cut -d';' -f1,2,7 "$fich" | tail -n +2 > pression2.csv

        awk -F";" 'NF>0 && $3 != ""{
            date = substr($2, 1, 10);
            a[date]+=$3;
            b[date]++
        } 
        END {
            for(i in a) {
                print i";" a[i]/b[i]
            }
        }' pression2.csv | sed 's/,/./g' > tmp.csv
        mv tmp.csv pression2.csv
    fi

    
       #***MODE 3
    if [ $2 -eq 3 ]; then

        cut -d';' -f1,2,7 "$fich" | tail -n +2 > pression3.csv

        awk -F ";" '
        {
            key = $2";"$1;
            temperatures[key] = $3;
        }
        END {
            for (key in temperatures) {
            print key ";" temperatures[key];
            }
        }
        ' pression3.csv > tmp.csv
        mv tmp.csv pression3.csv
    fi
}


#*********FILTRAGE DE L'HUMIDITE'*********
humidite() {

    fich=$1

    cut -d';' -f1,6,10 "$fich" | tail -n +2 | sed 's/,/;/g' > humidite.csv

    awk -F";" '
    {
        if (!($1 in max)) {
            max[$1] = $2;
            x[$1] = $3;
            y[$1] = $4;
        } else if ($2 > max[$1]) {
            max[$1] = $2;
        }
    }
    END {
        for (station in max) {
            print station ";" max[station] ";" x[station] ";" y[station] ;
        }
    }
    ' humidite.csv > tmp.csv
    mv tmp.csv humidite.csv
}


#*********FILTRAGE DE L'ALTITUDE*********
altitude() {

    fich=$1

    cut -d';' -f1,10,14 "$fich"| tail -n +2 | sed 's/,/;/g' > altitude.csv

    awk -F";" '
    {
        if (!($1 in max)) {
            max[$1] = $4;
            x[$1] = $2;
            y[$1] = $3;
        } else if ($4 > max[$1]) {
            max[$1] = $4;
        }
    }
    END {
        for (station in max) {
            print station ";" max[station] ";" x[station] ";" y[station] ;
        }
    }
    ' altitude.csv > tmp.csv
    mv tmp.csv altitude.csv
}


#*********FILTRAGE DE LU VENT*********
vent() {

    fich=$1

    cut -d';' -f1,4,5,10 "$fich" | tail -n +2 | sed 's/,/;/g' > vent.csv

    awk -F";" '
    {
        direction[$1] += $2;
        vitesse[$1] += $3;
        c[$1]++;
        x[$1] = $4;
        y[$1] = $5;
    }
    END {
        for (i in direction) {
            print i ";" direction[i]/c[i] ";" vitesse[i]/c[i] ";"  x[i] ";" y[i]
        }
    }
    ' vent.csv | sed 's/,/./g' > tmp.csv
    mv tmp.csv vent.csv
}


# --------------------- FILTRAGE GEOGRAPHIQUE ------------------------ #
france(){
    fich=$1
    awk -F ';' '$15 < 96000 { print }' "$fich" > france.csv
}

guyane(){
    fich=$1
    awk -F ';' '$15 >= 97300 && $15 <= 97399 { print }' "$fich" > guyane.csv
}

stPierreMiq(){
    fich=$1
    awk -F ';' '$15 >= 97300 && $15 <= 97399 { print }' "$fich" > stPierreMiq.csv
}

antilles(){
    fich=$1
    awk -F ';' '$15 >= 97300 && $15 <= 97399 { print }' "$fich"> antilles.csv
}

oceanI(){
    fich=$1
    awk -F ';' '{if( $10 ~ /^-?[0-9]+(\.[0-9]+)?,-?[0-9]+(\.[0-9]+)?$/ && $10 ~ /^([-+]?[0-9.]+),([-+]?[0-9.]+)/ )
                {if( ($10 < 0 && $10  < 40) && ($11 > 50 && $11 < 95) ) { print }}}' "$fich" > oceanI.csv
}

antarctique(){
    fich=$1
    awk -F ';' '{if( $10 ~ /^-?[0-9]+(\.[0-9]+)?,-?[0-9]+(\.[0-9]+)?$/ && $10 ~ /^([-+]?[0-9.]+),([-+]?[0-9.]+)/ )
                {if( ($10 < 80 && $10  > 70) && ($11 > 0 && $11 < 100) ) { print }}}'  "$fich" > antarctique.csv
}


#-----------------------------------------------------------------------------#

verifexe(){

    EXECUTABLE=./exe
    SOURCES="triAVL.c mainAVL.c"

    if [ ! -e "$EXECUTABLE" ]; then
        gcc $SOURCES -o "$EXECUTABLE"
        if [ $? -ne 0 ]; then
            echo "La compilation a échouée."
            return 1
        
        else
            echo "Compilation réussie"
            return 0
        fi
    fi

}



              #*******ON GERE LES OPTIONS AVEC GETOPT*******#

options=$(getopt -o "f:p:t:wmhFGSAOQ" --long "tab,abr,avl,help" -n "test.sh" -- "$@")

if [ $? -ne 0 ] ; then
  echo "Il y a une erreur d'options, merci de vérifier la syntaxe."
  exit 1
fi

eval set -- "$options"

while true; do
    case "$1" in
        -f)
            opt_f=true
            fichier="$2"
            if [ "${fichier#*.}" != "csv" ] ; then
                echo "Le type de fichier est incorrect. Veuillez entrer un fichier csv."
                exit 1
            fi
            echo "Vous avez choisi le fichier $fichier."
            shift 2;;
            
        -p)
            opt_p=true  
            mode_p="$2"
            if [ "$mode_p" != "1" ] && [ "$mode_p" != "2" ] && [ "$mode_p" != "3" ]; then
                echo "-p doit avoir un mode entre 1 et 3"
                exit 1
            fi
            shift 2;;

        -t)
            opt_t=true  
            mode_t="$2"
            if [ "$mode_t" != "1" ] && [ "$mode_t" != "2" ] && [ "$mode_t" != "3" ]; then
                echo "-t doit avoir un mode entre 1 et 3"
                exit 1
            fi
            shift 2;;

        -w)
            opt_w=true
            shift;;
            
        -m)
            opt_m=true
            shift;;

        -h)
            opt_h=true
            shift;;

        -F)
            compte_geo=$((compte_geo+1))
            opt_F=true
            shift;;

        -G)
            compte_geo=$((compte_geo+1))
            opt_G=true
            shift;;

        -S)
            compte_geo=$((compte_geo+1))
            opt_S=true
            shift;;

        -A)
            compte_geo=$((compte_geo+1))
            opt_A=true
            shift;;

        -O)
            compte_geo=$((compte_geo+1))
            opt_O=true
            shift;;

        -Q)
            compte_geo=$((compte_geo+1))
            opt_Q=true
            shift;;

        --tab)
            compte_tri=$((compte_tri+1))
            opt_tab=true
            shift;;

        --abr)
            compte_tri=$((compte_tri+1))
            opt_abr=true
            shift;;

        --avl)
            compte_tri=$((compte_tri+1))
            opt_avl=true
            shift;;

        --help)
            aide
            exit 1
            shift;;
        --)
            shift
            break;;
    esac
done


#VERIFICATION DE LA PRESENCE D'AU MOINS UNE DES FONCTIONS OBLIGATOIRES

if ! $opt_t && ! $opt_p && ! $opt_w && ! $opt_m && ! $opt_h; then
    echo "Erreur: vous devez utiliser au moins l'une des options suivantes:
    -t
    -p
    -w
    -m
    -h"
    exit 1
fi


#VERIFICATION DE LA PRESENCE D'UN FICHIER

if ! $opt_f; then
    echo "Erreur: vous devez obligatoirement utiliser l'option -f pour entrer un fichier."
    exit 1
fi


#VERIFICATION DE L'UTILISATION EXCLUSIVE D'UNE SEULE OPTION GEOGRAPHIQUE

if [ $compte_geo -gt 1 ] ; then
    echo "Erreur: Vous ne pouvez utiliser qu une seule option de limitation géographique:
    -F
    -G
    -S
    -A
    -O
    -Q"
    exit 1
fi


#VERIFICATION DE L'UTILISATION EXCLUSIVE D'UNE SEULE OPTION DE TRI

if [ $compte_tri -gt 1 ] ; then
    echo "Erreur: Vous ne pouvez utiliser qu une seule option de tri:
    --tab
    --abr
    --avl"
    exit 1
fi



   #*********// TRAITEMENT DES OPTIONS \\ *********#

if $opt_A; then

    antilles "$fichier"
    fichier=antilles.csv
    echo "L'option A a été utilisée "

fi


if $opt_F ; then

    france "$fichier"
    fichier=france.csv
    echo "L'option F a été utilisée "

fi


if $opt_G ; then

    guyane "$fichier"
    fichier=guyane.csv
    echo "L'option G a été utilisée "

fi


if $opt_S ; then

    stPierreMiq "$fichier"
    fichier=stPierreMiq.csv
    echo "L'option S a été utilisée "

fi


if $opt_O ; then

    oceanI "$fichier"
    fichier=oceanI.csv
    echo "L'option O a été utilisée "

fi


if $opt_Q; then

    antarctique "$fichier"
    fichier=antarctique.csv
    echo "L'option Q a été utilisée "

fi


if $opt_t ; then


    temperature "$fichier" "$mode_t"

    if [ "$mode_t" -eq 1 ]; then
        if verifexe ; then
            ./exe temperature.csv temp1trie.csv

            echo "L'option t a été utilisée avec le mode $mode_t"
        fi
    fi

    if [ "$mode_t" -eq 2 ]; then
        if verifexe ; then
            ./exe temperature2.csv temp2trie.csv

            echo "L'option t a été utilisée avec le mode $mode_t"
        fi
    fi

    if [ "$mode_t" -eq 3 ]; then
        if verifexe ; then
            ./exe temperature3.csv temp3trie.csv

            echo "L'option t a été utilisée avec le mode $mode_t"
        fi
    fi


fi


if $opt_p ; then

    pression "$fichier" "$mode_p"

    if [ "$mode_p" -eq 1 ]; then
        if verifexe ; then
            ./exe pression.csv pression1trie.csv

            echo "L'option -p(pression) a été utilisée avec le mode $mode_p"
        fi
    fi


    if [ "$mode_p" -eq 2 ]; then
        if verifexe ; then
            ./exe pression2.csv pression2trie.csv

            echo "L'option -p(pression) a été utilisée avec le mode $mode_p"
        fi
    fi


    if [ "$mode_p" -eq 3 ]; then
        if verifexe ; then
            ./exe pression3.csv pression3trie.csv

            echo "L'option -p(pression) a été utilisée avec le mode $mode_p"
        fi
    fi

fi


if $opt_w ; then

    vent "$fichier"

    if verifexe ; then
            ./exe vent.csv venttrie.csv

            echo "L'option -w(vent) a été utilisée."
    fi

fi


if $opt_m ; then

    humidite "$fichier"

    if verifexe ; then
            ./exe humidite.csv humiditetrie.csv

            echo "L'option -m(humidite) a été utilisée."
    fi
fi


if $opt_h ; then

    altitude "$fichier"

    if verifexe ; then
            ./exe altitude.csv altitudetrie.csv

            echo "L'option -h(altitude) a été utilisée."
    fi

fi


if $opt_tab ; then

    echo "L'option tab a été utilisée "

fi


if $opt_avl ; then

    echo "L'option avl a été utilisée "

fi


if $opt_abr ; then

    echo "L'option abr a été utilisée "

fi



