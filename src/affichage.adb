with SGF; use SGF;
with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Affichage; use Affichage;

package body Affichage is
   procedure Afficher_Banniere_Main is
   begin
      Put_Line ("+-----------------------------------------------+");
      Put_Line ("|           Bienvenue dans le SGF               |");
      Put_Line ("|-----------------------------------------------|");
      Put_Line ("|   1. Mode Menu (navigation par chiffres)      |");
      Put_Line ("|   2. Mode Terminal (commandes manuelles)      |");
      Put_Line ("|   3. Quitter                                  |");
      Put_Line ("|                                               |");
      Put_Line ("|   Entrez votre choix (1-3)                    |");
      Put_Line ("+-----------------------------------------------+");
   end Afficher_Banniere_Main;

   procedure Faire_Init is
   begin
   Init_SGF;
   end Faire_Init;

   procedure Faire_Dossier is
   nom : string;
   chemin : string;
   droits : integer;
   
   begin

   end Faire_Dossier;

   procedure Faux_Main is
   choix : Integer;
   begin
    while True loop
      Afficher_Banniere_Main;
      Get(choix);
      case choix is 
         when 1 =>
            Menu;
            exit;
         when 2 =>
            Put_Line("Cmd");
            exit;
         when 3 =>
            exit;
         when others =>
            Put_Line ("Choix invalide");
      end case;
   end loop;
   end Faux_Main;

   procedure Afficher_Banniere_Menu is
   begin
      Put_Line ("+-----------------------------------------------+");
      Put_Line ("|      Bienvenue dans le SGF mode menu          |");
      Put_Line ("|-----------------------------------------------|");
      Put_Line ("|   1. Créer un SGF                             |");
      Put_Line ("|   2. Créer un dossier                         |");
      Put_Line ("|   3. Créer un fichier                         |");
      Put_Line ("|   4. Changer de répertoire                    |");
      Put_Line ("|   5. Afficher le répertoire                   |");
      Put_Line ("|   6. Changer de répertoire                    |");
      Put_Line ("|   7. Revenir au chois de mode                 |");
      Put_Line ("|                                               |");
      Put_Line ("|   Entrez votre choix (1-7)                    |");
      Put_Line ("+-----------------------------------------------+");
   end Afficher_Banniere_Menu;

   procedure Menu is
   choix :integer;
   begin

      Afficher_Banniere_Menu;
      Get(choix);
      case choix is
         when 1 =>
            Faire_Init;
         when 2 =>
            Faire_Dossier;
         when 3 =>
            Faire_Touch;
         when 4 =>
            Faire_CD;
         when 5 =>
            Faire_Ls;
         when 7 =>
            Faux_Main;
         when others =>
            Put_Line ("Choix invalide");
      end case;
   end Menu;
end Affichage;