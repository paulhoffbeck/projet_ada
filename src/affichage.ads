package Affichage is
   procedure Afficher_Banniere_Main;
   procedure Afficher_Banniere_Menu;
   procedure Menu;
   procedure Faux_Main;
   procedure Faire_Init;
   procedure Faire_Dossier;
   procedure Faire_Touch;
   procedure Faire_Trouver_El;
   procedure Faire_Supprimer;
   procedure Faire_Copie;
   procedure Faire_Tar;
   function Choix_Fi(nom : string)return Boolean;
   Bad_Choice_Number : exception;
   Sortie : exception;
end Affichage;