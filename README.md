opendataAccidents06
===================

Repo contenant une série d'analyse des accidents dans les Alpes-Maritimes 
J'ai fait en sorte que chacun puisse réutiliser les scripts R pour reproduire l'analyse dans chaque département
Une demande d'analyse/question : "issues" à droite
Critiques et corrections fortement appréciées!

Concernant l'utilisation de l'API Google Maps, celle-ci est limitée à 2500 requêtes / jour, un peu de patience si il y a beaucoup d'accidents dans votre département (4 jours pour récupérer toutes les coordonnées GPS pour les Alpes Maritimes à titre d'exemple)

Cartes par Google

Cartes Shapefile par OpenStreetMap. Merci à eux !
Pour les autres départements, c'est par ici :
http://export.openstreetmap.fr/contours-administratifs/communes/

Données utilisées :

villes_france.csv
Merci à SQL.sh 
http://sql.sh/736-base-donnees-villes-francaises
Licence CC BY-SA 4.0

acc_fr_0610.csv
vehicules_implique.csv
http://www.data.gouv.fr/fr/dataset/base-de-donnees-accidents-corporels-de-la-circulation-sur-6-annees
Opence licence 


TODO : 

Dev :
- cartes alpes maritimes (densité, compa jour/nuit, 
- cartes Cannes, Grasse, Antibes 
- carte compa

- analyse stats/graphs

Write :
- articles Nice accidents 
