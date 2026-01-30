package Affichage is

--CONTRATS A FAIRE


procedure Afficher_Banniere_Main;
-- pre  : aucune
-- post : bannière principale affichée

procedure Afficher_Banniere_Menu;
-- pre  : aucune
-- post : bannière menu affichée

procedure Menu;
-- pre  : aucune
-- post : menu exécuté, choix traité ou exception levée

procedure Faux_Main;
-- pre  : aucune
-- post : menu principal exécuté, choix traité ou sortie

procedure Faire_Init;
-- pre  : aucune
-- post : SGF initialisé

procedure Faire_Dossier;
-- pre  : aucune
-- post : dossier créé avec nom, chemin et droits saisis

procedure Faire_Touch;
-- pre  : aucune
-- post : fichier créé avec nom, chemin, droits et taille saisis

procedure Faire_Trouver_El;
-- pre  : aucune
-- post : élément recherché et informations affichées

procedure Faire_Supprimer;
-- pre  : aucune
-- post : fichier ou dossier supprimé

procedure Faire_Copie;
-- pre  : aucune
-- post : fichier ou dossier copié

procedure Faire_Tar;
-- pre  : aucune
-- post : dossier courant archivé

function Choix_Fi(nom : string) return Boolean;
-- pre  : nom non vide
-- post : retourne vrai si nom contient un point, sinon faux

   Bad_Choice_Number : exception;
   Sortie : exception;
end Affichage;