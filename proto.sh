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
opt_help=false

        #***********///*******\\\***********#
        #**********/  FONCTIONS  \**********#
        #******** ///***********\\\*********#

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
        }' temperature2.csv | sed 's/,/./g' | sort > tmp.csv
        mv tmp.csv temperature2.csv
    fi
}


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
        }' pression2.csv | sed 's/,/./g' | sort > tmp.csv
        mv tmp.csv pression2.csv
    fi
}



humidite() {

    fich=$1

    cut -d';' -f1,6 "$fich" | tail -n +2 > humidite.csv

    awk -F";" '
    {
        if (!($1 in max)) {
            max[$1] = $2;
        } else if ($2 > max[$1]) {
            max[$1] = $2;
        }
    }
    END {
        for (station in max) {
            print station ";" max[station];
        }
    }
    ' humidite.csv > tmp.csv
    mv tmp.csv humidite.csv
}



altitude() {

    fich=$1

    cut -d';' -f1,14 "$fich"| tail -n +2 > altitude.csv

    awk -F";" '
    {
        if (!($1 in max)) {
            max[$1] = $2;
        } else if ($2 > max[$1]) {
            max[$1] = $2;
        }
    }
    END {
        for (station in max) {
            print station ";" max[station];
        }
    }
    ' altitude.csv > tmp.csv
    mv tmp.csv altitude.csv
}


vent() {

    fich=$1

    cut -d';' -f1,4,5 "$fich" | tail -n +2 > vent.csv

    awk -F";" '
    {
        a[$1] += $2;
        b[$1] += $3;
        c[$1]++;
    }
    END {
        for (i in a) {
            print i ";" a[i]/c[i] ";" b[i]/c[i]
        }
    }
    ' vent.csv | sed 's/,/./g' > tmp.csv
    mv tmp.csv vent.csv
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
            echo "le fichier est $fichier et son extension est ${fichier#*.}"
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
            opt_help=true
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


# --------------------- FILTRAGE GEOGRAPHIQUE ------------------------ #
france(){
    awk -F ';' '$15 < 96000 { print }' meteoData.csv > france.csv
}

guyane(){
    awk -F ';' '$15 >= 97300 && $15 <= 97399 { print }' meteoData.csv > guyane.csv
}

stPierreMiq(){
    awk -F ';' '$15 >= 97300 && $15 <= 97399 { print }' meteoData.csv > stPierreMiq.csv
}

antilles(){
    awk -F ';' '$15 >= 97300 && $15 <= 97399 { print }' meteoData.csv > antilles.csv
}

oceanI(){
    awk -F ';' '{if( $10 ~ /^-?[0-9]+(\.[0-9]+)?,-?[0-9]+(\.[0-9]+)?$/ && $10 ~ /^([-+]?[0-9.]+),([-+]?[0-9.]+)/ )
                {if( ($10 < 0 && $10  < 40) && ($11 > 50 && $11 < 95) ) { print }}}' meteoData.csv > oceanI.csv
}

antarctique(){
    awk -F ';' '{if( $10 ~ /^-?[0-9]+(\.[0-9]+)?,-?[0-9]+(\.[0-9]+)?$/ && $10 ~ /^([-+]?[0-9.]+),([-+]?[0-9.]+)/ )
                {if( ($10 <= 70 && $10  >= 80) && ($11 >= 0 && $11 <= 100) ) { print }}}' meteoData.csv > oceanI.csv
}

   #*********// TRAITEMENT DES OPTIONS \\ *********#

if $opt_t ; then

    temperature "$fichier" "$mode_t"
    echo "L'option t a été utilisée avec le mode $mode_t"

fi


if $opt_p ; then

    pression "$fichier" "$mode_p"
    echo "L'option p a été utilisée avec le mode $mode_p"

fi


if $opt_w ; then

    vent "$fichier"
    echo "L'option w a été utilisée "

fi


if $opt_m ; then

    humidite "$fichier"
    echo "L'option m a été utilisée "

fi


if $opt_h ; then

    altitude "$fichier"
    echo "L'option h a été utilisée "

fi


if $opt_f ; then

    echo "L'option f a été utilisée avec le fichier $fichier "

fi


if $opt_A; then

    echo "L'option A a été utilisée "
    antilles

fi


if $opt_F ; then

    echo "L'option F a été utilisée "
    france

fi


if $opt_G ; then

    echo "L'option G a été utilisée "
    guyane

fi


if $opt_S ; then

    echo "L'option S a été utilisée "
    stPierreMiq

fi


if $opt_O ; then

    echo "L'option O a été utilisée "
    oceanI

fi


if $opt_Q; then

    echo "L'option Q a été utilisée "
    antarctique

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


if $opt_help ; then

    echo "L'option help a été utilisée "

fi

