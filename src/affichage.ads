package Affichage is
   procedure Afficher_Banniere_Main;
   procedure Afficher_Banniere_Menu;
   procedure Menu;
   procedure Faux_Main;
   procedure Faire_Init;
   procedure Faire_Dossier;
   procedure Faire_Touch;
   
   Bad_Choice_Number : exception;
   Sortie : exception;
end Affichage;