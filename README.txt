# PROJET_METEO

			READ ME
			
Pour compiler, écrire dans le terminal: make all

Les instructions pour executer :   	  ./app_meteo.sh  <options>  -f <nom_fichier>

	Vous avez tout d’abord l’option --help : pour afficher l’aide détaillé de l’application

	Une seule parmi ces options : -F pour la France
				      	       -G pour la Guyane
				      	       -O pour l’Océan Indien
				      	       -S pour Saint-Pierre et Miquelon
				      	       -A pour les Antilles
	
	Plusieurs parmi ces options : 

		 -t<mode> : pour afficher un graphique en fonction des températures
		 -p<mode>: pour afficher un graphique en fonction des pressions
			Les <modes> : 1 -  génère un graphique de type barres d’erreur
  					     2 - génère un graphique de type ligne simple
       					     3 - génère un graphique de type multi-lignes

		-w : génère un graphique de type vecteur, l’orientation moyenne et la vitesse moyenne des vents 
		-h : génère un graphique type carte interpolée et colorée en fonction de l'altitude
		-m : génère un graphique type carte interpolée et colorée en fonction de l’humidité

