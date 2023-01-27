Date : 14/04/2020.

Auteurs : 	
	- Progs : 	CLEMENT Alexis, MILLEREUX Basile, OUCHICHAOU Youssef, FORET Julien.
	- Graphs : 	ITEMA Adam, DALMASSO Thomas.
	- SoundDesign : MILLEREUX Basile

Description : Roguelike (inspiré du jeu "The Binding of Isaac") où le but de la partie est d'explorer le donjon afin de trouver et de vaincre le boss (boule de neige).

Contrôles :

	- Menu : [Clic gauche] = Accès au jeu.
			       = Accès au wiki.
			       = Accès aux options.
			       = Accès aux crédits.
			       = Quitter le jeu.

	- Wiki : [Clic gauche] = Retour au menu.
		 [Echap] = Retour au menu.

	- Options : [Clic gauche] = Monter/Baisser le volume.
				  = Afficher les FPS.
				  = Retour au menu.
		    [Echap] = Retour au menu.


	- Jeu : Clic gauche = Tirer (si le joueur a une arme).

		[Z] = Déplacer vers le haut.
		[S] = Déplacer vers le bas.
		[Q] = Déplacer vers la gauche.
		[D] = Déplacer vers la droite.

		[R] = Recharger les munitions (si le joueur a une arme).
		[E] = Interagir (ouvrir les coffres, ramasser les armes, afficher le parchemin des contrôles).
		[Espace] = Dash.

		[Echap] = Mettre le jeu en pause.

	- Options : [Clic gauche] = Retour au menu.
		    	          = Quitter le jeu.
		    [Echap] = Retour au jeu.

	- GameWin : [Clic gauche] = Retour au menu.
		    [Echap] = Retour au menu.

	- GameOver : [Clic gauche] = Retour au menu.
		     [Echap] = Retour au menu.

Bugs connus :
	- Si on est tout en bas de la map avec le canon à neige, il n'y a pas de balles qui sortent (collision instantannée avec le mur).
	- Si on traverse une porte et qu'on revient dans la salle précédente, la map risque de changer visuellement.
	- Bug d'affichage au niveau des barrières.

Fonctionnalités du jeu :
	- Musique du jeu.
	- Sons des tirs, rechargement, interaction avec les objets...
	- Système de particules.
	- Gestion de donjon.
	- Génération procédurale.
	- MiniMap.
	- Gestion des différents types d'ennemis.
	- Intelligence artificielle des ennemis selon leurs armes.
	- Système d'armes (gestion des tires et rechargements).
	- Gestion des loots (gemmes, heals, armes).
	- Coffre avec des armes.
	- Système de dash pour le joueur.
	- Possibilité de victoire et de défaite.
	- Utilisation d'animations.
	- Utilisation du logiciel tiled.
	- Immunité d'un court instant quand on se prend des dégâts.
