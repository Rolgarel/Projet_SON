# Projet Son

## Réalisation d'un synthétiseur de bruit de pluie

Lors de notre projet SON, nous avons réalisé un synthétiseur de bruit de pluie.
Celui-ci implémente un bruit simulant une pluie battante superposé à des bruits de gouttes qui tombent aléatoirement.
De plus, un bruit de tonnerre (grondement et claquement) peut être produit à l'appui d'un bouton.

## Comment utiliser le synthétiseur sur le Teensy

Pour utiliser notre synthétiseur, il faut dans un premier temps réaliser les branchements suivants :
* Brancher un potentiomètre sur le port 14 (`A0`). Celui-ci permettra de régler le volume sonore en sortie du Teensy.
* Brancher un potentiomètre sur le port 16 (`A2`). Celui-ci permettra de régler l'intensité de la pluie.
* Brancher un bouton sur le port 0. Celui-ci permettra de créer un son de tonnerre lorsque le bouton est actionné.

Il faut ensuite télécharger le programme `Teensy.ino` sur un Teensy 4.0. La sortie audio du synthétiseur se fera alors sur la sortie audio de l'AudioShield du Teensy.

## Description de l'archive

Depuis la racine de l'archive, nous avons :
* `Poster.pdf` correspondant au poster de présentation de notre projet
* `RainSynth.dsp` qui est le code Faust contenant l'implémentation de notre synthétiseur
* `Teensy` qui est un dossier contenant le code C++ et le fichier `.ino` permettant d'exécuter notre synthétiseur sur un Teensy 4.0
